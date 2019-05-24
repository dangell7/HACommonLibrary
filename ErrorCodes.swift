////
////  ErrorCodes.swift
////  HACommonLibrary
////
////  Created by Anderson, Logan on 11/5/17.
////  Copyright © 2017 Harp Angell. All rights reserved.
////
//
//import Foundation
//import UIKit
//import FCAlertView
//
//class ErrorCodes: NSObject {
//    static let sharedInstance = ErrorCodes()
//    
//    var alert = FCAlertView()
//    
//    let codes: [String: Error] = [
//        "SERV1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error Communinucating With The Server"]),
//        
//        "BADC1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Someone Wrote Some Poor Code"]),
//        
//        "ESREG1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a First Name"]),
//        "ESREG2": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Last Name"]),
//        "ESREG3": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter an Email"]),
//        "ESREG4": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Password"]),
//        "ESREG5": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter an Establishment"]),
//        "ESREG6": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter an Activation Code"]),
//        
//        "EAUTH1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter an Email Address"]),
//        "EAUTH2": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Password"]),
//        
//        "AG1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a First Name"]),
//        "AG2": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Last Name"]),
//        "AG3": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Phone Number"]),
//        
//        "PAUTH1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter a Phone Number"]),
//        
//        "AUTH1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Your Account Has Been Deleted, Please Talk to the Owner"]),
//        
//        "VEAUTH1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Your email has not been verified, please check your email and verify your account"]),
//        
//        "FPAS1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter Your Email Address"]),
//        "FPAS2": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter The Code Emailed To You"]),
//        "FPAS3": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Please Enter New Password"]),
//        
//        "VGL1": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error While Saving Virtual Guest List Details"]),
//        "VGL2": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Something went wrong. Please try again"]),
//        "VGL3": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error While Retrieving Virtual Guest List Details"]),
//        "VGL4": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error While Deleting Virtual Guest List Details"]),
//        "VGL5": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error While Updating Virtual Guest List Details"]),
//        "VGL6": NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Error While Add Guest to Virtual Guest List Details"]),
//    ]
//    
//    public func getError(_ code: String) -> Error? {
//        return codes[code]
//    }
//    
//    public func setUpAlert() {
//        alert = FCAlertView()
//        alert.darkTheme = true
//        alert.animateAlertOutToBottom = true
//        alert.animateAlertInFromBottom = true
//        alert.bounceAnimations = true
//        alert.dismissOnOutsideTouch = false
//        alert.subTitleColor = UIColor(red: 48/255, green: 219/255, blue: 240/255, alpha: 1)
//    }
//    
//    public func showAlertWithCompletions(message: String, cancelCompletion: @escaping () -> Void, okCompletion: @escaping () -> Void) {
//        hideAlert()
//        setUpAlert()
//        alert.addButton("Ok", withActionBlock: okCompletion)
//        alert.addButton("Cancel", withActionBlock: cancelCompletion)
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//    }
//    
//    public func showCautionAlertWithCompletions(message: String, cancelCompletion: @escaping () -> Void, okCompletion: @escaping () -> Void) {
//        hideAlert()
//        setUpAlert()
//        alert.makeAlertTypeCaution()
//        alert.addButton("Ok", withActionBlock: okCompletion)
//        alert.addButton("Cancel", withActionBlock: cancelCompletion)
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//    }
//    
//    public func showRegularAlert(message: String) {
//        hideAlert()
//        setUpAlert()
//        alert.showAlert(withTitle: nil, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//    }
//    
//    public func showErrorAlert(message: String) {
//        hideAlert()
//        setUpAlert()
//        alert.makeAlertTypeWarning()
//        alert.numberOfButtons = 1
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: ["Ok"])
//    }
//    
//    public func showSuccessAlert(message: String) {
//        hideAlert()
//        setUpAlert()
//        alert.makeAlertTypeSuccess()
//        alert.numberOfButtons = 1
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: message, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: ["Ok"])
//    }
//    
//    public func showLoadingAlert() {
//        hideAlert()
//        setUpAlert()
//        alert.makeAlertTypeProgress()
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: "Doing Cool Stuff...", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//    }
//    
//    public func showTimeoutAlert() {
//        hideAlert()
//        setUpAlert()
//        alert.makeAlertTypeCaution()
//        alert.numberOfButtons = 1
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: nil, withSubtitle: "You have been logged out due to inactivity", withCustomImage: nil, withDoneButtonTitle: nil, andButtons: ["Ok"])
//    }
//    
//    public func showQuantityAlert(completion: @escaping ((Bool, String?) -> Void)) {
//        hideAlert()
//        setUpAlert()
//        var quantityString = "1"
//        let textField = UITextField()
//        textField.keyboardType = .numberPad
//        textField.keyboardAppearance = .alert
//        alert.addTextField(withCustomTextField: textField, andPlaceholder: "1") { text in
//            quantityString = text ?? "1"
//            
//        }
//        
//        alert.addButton("Cancel") {
//            textField.resignFirstResponder()
//            completion(true, nil)
//        }
//        
//        alert.addButton("Ok") {
//            textField.resignFirstResponder()
//            completion(false, quantityString)
//        }
//        
//        alert.hideDoneButton = true
//        alert.showAlert(withTitle: "How Many?", withSubtitle: nil, withCustomImage: nil, withDoneButtonTitle: nil, andButtons: nil)
//        textField.becomeFirstResponder()
//    }
//    
//    public func hideAlert() {
//        alert.dismiss()
//    }
//}
