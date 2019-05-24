//
//  GeotificationService.swift
//  HACommonLibrary
//
//  Created by Denis Angell on 05/23/2019.
//  Copyright © 2018 Harp Angell. All rights reserved.
//

import UIKit
import MapKit
import FirebaseFirestore
import CoreLocation

class GeoHashFireService {
    
    func degreesToRadians(degrees: Double, completion: @escaping (Double, Error?) -> Void) {
        let multiplier = degrees * Double.pi
        completion(multiplier / 180.0, nil)
    }
    
    func metersToLongitudeDegrees(distance: Double, latitude: Double, completion: @escaping (Double, Error?) -> Void) {
        let EARTH_EQ_RADIUS = 6378137.0;
        // this is a super, fancy magic number that the GeoFire lib can explain (maybe)
        let E2 = 0.00669447819799;
        let EPSILON = 1e-12;
        degreesToRadians(degrees: latitude) { (radians, error) in
            guard error == nil else {
                completion(0.0, error)
            }
            let num = cos(radians) * EARTH_EQ_RADIUS * Double.pi / 180.0
            let denom = 1 / sqrt(1 - E2 * sin(radians) * sin(radians))
            let deltaDeg = num * denom;
            if deltaDeg < EPSILON {
                if distance > 0 {
                    completion(360, nil)
                }
                completion(0, nil)
            }
            completion(min(360, distance / deltaDeg), nil)
        }
    }
    
    func wrapLongitude(longitude: Double, completion: @escaping (Double, Error?) -> Void) {
        var newAdjusted: Double?
        
        if longitude <= 180.0 && longitude >= -180.0 {
            completion(longitude, nil)
        }
        let adjusted = longitude + 180.0
        
        if adjusted > 0 {
            let remainder = adjusted.remainder(dividingBy: 360.0)
            newAdjusted = remainder - 180.0
            completion(newAdjusted!, nil)
        }
        // else
        let remainder = adjusted.remainder(dividingBy: 360.0)
        newAdjusted = 180.0 - remainder
        completion(-newAdjusted!, nil)
    }
    
    func latitudeBitsForResolution(size: Double, completion: @escaping (Double, Error?) -> Void) {
        let MAXIMUM_BITS_PRECISION = 22.0 * 5.0
        let EARTH_MERI_CIRCUMFERENCE = 40007860.0
        let bits = min(log2(EARTH_MERI_CIRCUMFERENCE / 2.0 / size), MAXIMUM_BITS_PRECISION);
        completion(bits, nil)
    }
    
    func longitudeBitsForResolution(resolution: Double, latitude: Double, completion: @escaping (Double, Error?) -> Void) {
        metersToLongitudeDegrees(distance: resolution, latitude: latitude) { (degs, error) in
            if (abs(degs) > 0.000001) {
                completion(max(1, log2(360)), nil)
            }
            completion(1, nil)
        }
        
        completion(1, nil)
    }
    
    func geohashQuery(geohash: String, bits: Double, completion: @escaping ([String], Error?) -> Void) {
        let BITS_PER_CHAR = 5.0
        let BASE32 = "0123456789bcdefghjkmnpqrstuvwxyz"
        let precision = ceil(Double(geohash.count) / Double(BITS_PER_CHAR))
        //        let precision = 12.0
        if geohash.count < Int(precision) {
            completion([geohash, "\(geohash)~"], nil)
        }
        let gindex = geohash.index(geohash.startIndex, offsetBy: Int(precision))
        let ghash = geohash.prefix(upTo: gindex)
        let newIndex = ghash.count - 1
        let base = ghash.prefix(newIndex)
        
        let newGIndex = ghash.index(ghash.startIndex, offsetBy: newIndex)
        let newChar: Character = ghash[newGIndex]
        
        let range: Range<String.Index> = BASE32.range(of: newChar.lowercased())!
        let lastValue: Int = BASE32.distance(from: BASE32.startIndex, to: range.lowerBound)
        
        let significantBits = bits - Double(base.count) * BITS_PER_CHAR
        let unusedBits = Int(BITS_PER_CHAR - significantBits)
        // delete unused bits
        let startValue = (lastValue >> unusedBits) << unusedBits
        let endValue = startValue + (1 << unusedBits)
        
        let startIndex = BASE32.index(BASE32.startIndex, offsetBy: startValue) //will call succ 2 times
        let newStartChar: Character = BASE32[startIndex] //now we can index!
        
        if endValue > 31 {
            completion(["\(base)\(newStartChar.lowercased())", "\(base)~"], nil)
        } else {
            let endIndex = BASE32.index(BASE32.startIndex, offsetBy: endValue) //will call succ 2 times
            let newEndChar: Character = BASE32[endIndex] //now we can index!
            
            completion(["\(base)\(newStartChar.lowercased())", "\(base)\(newEndChar.lowercased())"], nil);
        }
    }
    
    func boundingBoxBits(coordinate: CLLocationCoordinate2D, size: Double, completion: @escaping (Double, Error?) -> Void) {
        let MAXIMUM_BITS_PRECISION = 5.0
        let METERS_PER_DEGREE_LATITUDE = 110574.0
        let latDeltaDegrees = size / METERS_PER_DEGREE_LATITUDE
        let latitudeNorth = min(90, coordinate.latitude + latDeltaDegrees)
        let latitudeSouth = max(-90, coordinate.latitude - latDeltaDegrees)
        var bitsLat: Double?
        latitudeBitsForResolution(size: size) { (bitsLatResult, error) in
            bitsLat = floor(bitsLatResult) * 2.0
        }
        var bitsLongNorth: Double?
        longitudeBitsForResolution(resolution: size, latitude: latitudeNorth) { (bitsLngNResult, error) in
            bitsLongNorth = floor(bitsLngNResult) * 2.0 - 1.0
        }
        var bitsLongSouth: Double?
        longitudeBitsForResolution(resolution: size, latitude: latitudeSouth) { (bitsLngSResult, error) in
            bitsLongSouth = floor(bitsLngSResult) * 2.0 - 1.0
        }
        completion(min(bitsLat!, bitsLongNorth!, bitsLongSouth!, MAXIMUM_BITS_PRECISION), nil)
    }
    
    func getGeoHashFireQueries(latitude: Double, longitude: Double, radius: Double, completion: @escaping ([[String]], Error?) -> Void) {
        
        let myCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let kmPerDegree = 110574.0
        let latDegrees = radius / kmPerDegree;
        let latitudeNorth = min(90, myCoordinate.latitude + latDegrees);
        let latitudeSouth = max(-90, myCoordinate.latitude - latDegrees);
        // calculate longitude based on current latitude
        var longDegsNorth: Double?
        
        metersToLongitudeDegrees(distance: radius, latitude: latitudeNorth) { (degsNorth, error) in
            guard error == nil else {
                completion([], error)
            }
            longDegsNorth = degsNorth
        }
        
        var longDegsSouth: Double?
        metersToLongitudeDegrees(distance: radius, latitude: latitudeSouth) { (degsSouth, error) in
            guard error == nil else {
                completion([], error)
            }
            longDegsSouth = degsSouth
        }
        
        let longDegs = max(longDegsNorth!, longDegsSouth!)
        
        var longWrappedMinus: Double?
        wrapLongitude(longitude: myCoordinate.longitude - longDegs) { (newLongWrapped, error) in
            guard error == nil else {
                completion([], error)
            }
            longWrappedMinus = newLongWrapped
        }
        
        var longWrappedPlus: Double?
        wrapLongitude(longitude: myCoordinate.longitude + longDegs) { (newLongWrapped, error) in
            guard error == nil else {
                completion([], error)
            }
            longWrappedPlus = newLongWrapped
        }
        
        let newQueryArray = [
            [myCoordinate.latitude, myCoordinate.longitude],
            [myCoordinate.latitude, longWrappedMinus],
            [myCoordinate.latitude, longWrappedMinus],
            [latitudeNorth, myCoordinate.longitude],
            [latitudeNorth, longWrappedMinus],
            [latitudeNorth, longWrappedPlus],
            [latitudeSouth, myCoordinate.longitude],
            [latitudeSouth, longWrappedMinus],
            [latitudeSouth, longWrappedPlus],
        ]
        
        var queryBits: Double?
        boundingBoxBits(coordinate: myCoordinate, size: radius) { (boxBits, error) in
            queryBits = max(1, boxBits);
        }
        
        var geoQueries: [[String]] = []
        
        for coordinate in newQueryArray {
            let hash = CLLocationCoordinate2D(latitude: coordinate[0]!, longitude: coordinate[1]!).geohash(length: 12)
            geohashQuery(geohash: hash, bits: queryBits!) { (queryArray, error) in
                if queryArray.count > 0 {
                    geoQueries.append(queryArray)
                }
            }
        }
        
        var newFilteredQueries: [[String]] = []
        var count: Int = 0
        for _query in geoQueries {
            if count == 0 {
                newFilteredQueries.append(_query)
                count += 1
            }
            
            if _query != geoQueries[count - 1] {
                newFilteredQueries.append(_query)
                count += 1
            }
        }
        completion(newFilteredQueries, nil)
    }
}

