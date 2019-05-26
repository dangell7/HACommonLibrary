//
//  AuthenticationService.swift
//  HACommonLibrary
//
//  Created by Denis Angell on 5/24/19.
//

import LocalAuthentication

@available(iOS 9.0, *)
public class AuthenticationService {
    
    public init() {}
    
    public func showErrorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case LAError.appCancel.rawValue:
            message = "Authentication was cancelled by application"
            
        case LAError.authenticationFailed.rawValue:
            message = "The user failed to provide valid credentials"
            
        case LAError.invalidContext.rawValue:
            message = "The context is invalid"
            
        case LAError.passcodeNotSet.rawValue:
            message = "Passcode is not set on the device"
            
        case LAError.systemCancel.rawValue:
            message = "Authentication was cancelled by the system"
            
        case LAError.touchIDLockout.rawValue:
            message = "Too many failed attempts."
            
        case LAError.touchIDNotAvailable.rawValue:
            message = "TouchID is not available on the device"
            
        case LAError.userCancel.rawValue:
            message = "The user did cancel"
            
        case LAError.userFallback.rawValue:
            message = "The user chose to use the fallback"
            
        default:
            message = "Did not find error code on LAError object"
            
        }
        
        return message
        
    }
    
    public func authenticateUserTouchID() {
        let context : LAContext = LAContext()
        // Declare a NSError variable.
        let myLocalizedReasonString = "Authentication is needed to access your Home ViewController."
        var authError: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &authError) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: myLocalizedReasonString) { success, evaluateError in
                if success // IF TOUCH ID AUTHENTICATION IS SUCCESSFUL, NAVIGATE TO NEXT VIEW CONTROLLER
                {
                    DispatchQueue.main.async{
                        print("Authentication success by the system")
                        //                        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                        //                        let homeVC = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                        //                        self.navigationController?.pushViewController(homeVC, animated: true)
                    }
                }
                else // IF TOUCH ID AUTHENTICATION IS FAILED, PRINT ERROR MSG
                {
                    if let error = evaluateError as? LAError {
                        let message = self.showErrorMessageForLAErrorCode(errorCode: error.code.rawValue)
                        print(message)
                    }
                }
            }
        }
    }
}

