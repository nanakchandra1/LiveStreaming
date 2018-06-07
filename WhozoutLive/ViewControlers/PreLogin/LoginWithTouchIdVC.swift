

import UIKit
import LocalAuthentication

class LoginWithTouchIdVC: BaseViewControler {

    @IBOutlet weak var touchidButton: UIButton!
    
    @IBOutlet weak var loginWithEmailButton: UIButton!
    
    @IBOutlet weak var thumbImage: UIImageView!
    
    
    let authenticationContext = LAContext()
 
    
    var error:NSError?
    override func viewDidLoad() {
        super.viewDidLoad()
        
          self.authenticateUser()
        
    }
    
    
    @IBAction func touchIdButtonTapped(_ sender: UIButton) {
        
            self.authenticateUser()
        
       // self.authenticateUser()
        
    }
    
    @IBAction func loginWithEmailbuttonTapped(_ sender: UIButton) {
        
//        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginID") as! LoginVC
//        self.navigationController?.pushViewController(vc, animated: true)
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
    
    func authenticateUser() {
        // Get the local authentication context.
       
        var error: NSError?
        
        let reasonString = "Authentication is needed to access your account."
        
        
         if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
            {
      
                authenticationContext.evaluatePolicy(
                    .deviceOwnerAuthenticationWithBiometrics,
                    localizedReason: reasonString,
                    reply: { [unowned self] (success, error) -> Void in
                        
                        if( success ) {
                            
                            printDebug(object: "success")
                            
                             if let email = SSKeychain.password(forService: appBundleId, account: loogedInUserEmail),
                                let pass = SSKeychain.password(forService: appBundleId, account: loogedInUserPassword){
                                
                                CommonFunction.getMainQueue {
                                    
                                    self.loginService(email: email, password: pass)
                                }
                               
                             }else{
                                _ = self.navigationController?.popViewController(animated: true)
                                CommonFunction.showTsMessageError(message: "Please login (if already registered) or register to enable Touch Id.")

                            }
                            
                        }else {
                            
                            if let error = error {
                                
                        let message = self.errorMessageForLAErrorCode(errorCode: error._code)
                                
                                printDebug(object: error._code)
                                
                                printDebug(object: message)
                                
                              
                                
                               // self.showAlertViewAfterEvaluatingPolicyWithMessage(message)
                                
                            }
                            
                        }
                        
                })
            
         }else{
            
        }
        
        
    }

    
    
    func errorMessageForLAErrorCode( errorCode:Int ) -> String{
        
        var message = ""
        
        switch errorCode {
            
        case  LAError.appCancel.rawValue:
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
    

    

    func showAlertViewIfNoBiometricSensorHasBeenDetected(){
        
        showAlertWithTitle(title: "Error", message: "This device does not have a TouchID sensor.")
        
    }
    
    func showAlertWithTitle( title:String, message:String ) {
        
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        
        
       // dispatch_async(dispatch_get_main_queue()) { () -> Void in
            
            self.present(alertVC, animated: true, completion: nil)
            
        //}
        
    }


}


//MARK:- Webservices
//======================
extension LoginWithTouchIdVC{
    
    func loginService(email:String,password:String){
        let params : [String : AnyObject] = ["email":email as AnyObject,"password" : password as AnyObject]
        
         self.thumbImage.image = UIImage(named: "thumbFilled")
        
        CommonFunction.showLoader(vc: self)
        UserService.loginApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
              //  SocketHelper.sharedInstance.connectSocket()

                printDebug(object: data)
                

               // CommonFunction.setTabBarToRoot()

                
                CommonFunction.pushToHome()
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
            
        }
    }
}
