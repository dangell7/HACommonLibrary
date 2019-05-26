//
//  ViewController.swift
//  HACommonLibrary
//
//  Created by dangell7 on 05/23/2019.
//  Copyright (c) 2019 dangell7. All rights reserved.
//

import UIKit
import HACommonLibrary
import FirebaseFirestore

class ViewController: UIViewController {
    
    let authenticationService = AuthenticationService()
    let geoHashService = GeoHashService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        authenticationService.authenticateUserTouchID()
        geoHashService.getGeoHashQueries(latitude: 33.4657, longitude: -117.9484, radius: 100.0) { (result, error) in
            print(result)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

