

import UIKit

class LoginVC: BaseViewControler {
    
    //MARK:- IBOutlets
    //==================
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var letMeInButton: UIButton!
    @IBOutlet weak var forgetButton: UIButton!
    @IBOutlet weak var loginWithTouchId: UIButton!
    @IBOutlet weak var emailSeperatorview: UIView!
    @IBOutlet weak var passwordSeperatorView: UIView!
    @IBOutlet weak var hideShowPasswordButton: UIButton!
    
    
    
    //MARK:- View life cycle
    //===================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubview()
    }
    

}

private extension LoginVC{
    
    //MARK:- set up your view
    //==========================
    func setUpSubview(){
        self.emailTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "EMAIL ADDRESS")
        self.emailTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "PASSWORD")
        self.emailSeperatorview.backgroundColor = AppColors.seperatorGreyColor
        self.passwordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
        self.passwordTextField.autocorrectionType = .no
        self.emailTextField.autocorrectionType = .no
        self.hideShowPasswordButton.setImage( UIImage(named: "passwordShow"), for: UIControlState.normal)
        self.passwordTextField.isSecureTextEntry = true
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.autocorrectionType = .no
        self.passwordTextField.autocorrectionType = .no
        self.emailTextField.returnKeyType = .next
        self.passwordTextField.returnKeyType = .done
        self.letMeInButton.layer.cornerRadius = 2.0
        self.letMeInButton.clipsToBounds = true
        self.hideShowPasswordButton.isHidden = true
    }
    
    //MARK:- Validation
    //===================
    func isAllFieldsVarified() -> Bool{
        
        if (self.emailTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("email empty", comment: ""))
            return false
        }else if !CommonFunction.isValidEmail(testStr: self.emailTextField.text!){
            CommonFunction.showTsMessageError(message: NSLocalizedString("invalid email", comment: ""))
            return false
        }else if (self.passwordTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password empty", comment: ""))
            return false
        }else if (self.passwordTextField.text?.characters.count)! < 6{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password length", comment: ""))
            return false
        }
        
        return true
    }
}


//MARK:- IBA tions
//===================
extension LoginVC{
    
    
    @IBAction func letMeInButtonTapped(_ sender: UIButton) {
        
        
        if isAllFieldsVarified(){
            self.loginService()
            
        }
        
        
        
        
    }
    
    @IBAction func forgetButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "ForgetPasswordID") as! ForgetPasswordVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginWithTouchIdButtonTapped(_ sender: UIButton){
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginWithTouchIdID") as! LoginWithTouchIdVC
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    @IBAction func hideShowPasswordButtontapped(_ sender: UIButton){
        if sender.isSelected{
            print("sel")
            self.passwordTextField.isSecureTextEntry = true
            self.hideShowPasswordButton.setImage( UIImage(named: "passwordShow"), for: UIControlState.normal)
        }else{
            print("dsel")
            self.passwordTextField.isSecureTextEntry = false
            self.hideShowPasswordButton.setImage( UIImage(named: "passwordHide"), for: UIControlState.normal)
        }
        sender.isSelected = !sender.isSelected
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "SignUpID") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- Textfield delegate
//=============================
extension LoginVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.emailTextField{
            self.emailSeperatorview.backgroundColor = AppColors.pinkColor
            self.passwordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
        }else{
            self.emailSeperatorview.backgroundColor = AppColors.seperatorGreyColor
            self.passwordSeperatorView.backgroundColor = AppColors.pinkColor
            
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.emailSeperatorview.backgroundColor = AppColors.seperatorGreyColor
        self.passwordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        CommonFunction.delay(delay: 0.1) {
            
            
            if string == " " && range.location == 0{
                return false
            }else if (textField.text?.isEmpty)!{
                self.hideShowPasswordButton.isHidden = true
                return true
            }else{
                self.hideShowPasswordButton.isHidden = false
                return true
            }
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.emailTextField{
            self.passwordTextField.becomeFirstResponder()
        }else{
            if isAllFieldsVarified(){
                self.loginService()
            }
        }
        return true
    }
    
}

//MARK:-  Webservices
//=====================
extension LoginVC {
    //MARK: Login api
    //==================
    func loginService(){
        let token =  AppUserDefaults.value(forKey: AppUserDefaults.Key.DevideToken)
        
        printDebug(object: token)
        let params : [String : AnyObject] = ["email":self.emailTextField.text! as AnyObject,
            "password" : self.passwordTextField.text! as AnyObject, "deviceToken" : token.stringValue as AnyObject]
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.loginApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
               //SocketHelper.sharedInstance.connectSocket()

                printDebug(object: data)
                
                SSKeychain.setPassword(self.emailTextField.text!, forService: appBundleId, account: loogedInUserEmail)
                SSKeychain.setPassword(self.passwordTextField.text!, forService: appBundleId, account: loogedInUserPassword)
                
               // CommonFunction.setTabBarToRoot()
                
                 CommonFunction.pushToHome()
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
            
        }
    }
    
}

