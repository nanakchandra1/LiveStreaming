

import UIKit

class ResetPasswordVC: BaseViewControler {

    
    //MARK:- Variables
    //=================
    var email : String!
    
    //MARK:- IBOutlets
    //=================
    @IBOutlet weak var newPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordSeperatorView: UIView!
    @IBOutlet weak var confirmPasswordSeperatorView: UIView!
    @IBOutlet weak var saveButton: UIButton!
    
    
    //MARK:- View lifecycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

//MARK:- Private functions
//============================
private extension ResetPasswordVC{
    
    //MARK:- set up view
    //======================
    func setUpSubView(){
        self.newPasswordTextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        self.newPasswordTextField.autocorrectionType = .no
        self.confirmPasswordTextField.autocorrectionType = .no
        self.confirmPasswordTextField.isSecureTextEntry = true
        self.newPasswordTextField.isSecureTextEntry = true
        self.newPasswordTextField.returnKeyType = .next
        self.confirmPasswordTextField.returnKeyType = .done
        self.newPasswordTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "NEW PASSWORD")
        self.confirmPasswordTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "CONFIRM PASSWORD")
        
        self.saveButton.layer.cornerRadius = 2.0
        self.saveButton.clipsToBounds = true
    
        
    }
    
    func isAllFieldsVarified() -> Bool{
        
        if (self.newPasswordTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("new password empty", comment: ""))
            return false
        }else if (self.newPasswordTextField.text?.characters.count)! < 6{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password length", comment:""))
            return false
        }else if (self.confirmPasswordTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("confirm password empty", comment: ""))
            return false
        }else if self.newPasswordTextField.text != self.confirmPasswordTextField.text{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password match", comment:""))
            return false
        }
        
        return true
    }

}


//MARK:- IBAction
//====================
extension ResetPasswordVC{
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        
        if isAllFieldsVarified(){
            self.resetPasswordService()
        }
        
    }
}

//MARK:- Textfield delegate
//===========================
extension ResetPasswordVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.newPasswordTextField{
            self.newPasswordSeperatorView.backgroundColor = AppColors.pinkColor
            self.confirmPasswordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
        }else{
            self.newPasswordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
            self.confirmPasswordSeperatorView.backgroundColor = AppColors.pinkColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.newPasswordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
        self.confirmPasswordSeperatorView.backgroundColor = AppColors.seperatorGreyColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if string == " " && range.location == 0{
            return false
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.text?.characters.count)! == 50 && isBackSpace != -92{
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.newPasswordTextField{
            
        }else{
            
        }
        return true
    }
}


//MAREK:- webservices
//=====================
extension ResetPasswordVC{
    
    func resetPasswordService(){
        let params : [String : AnyObject] = ["password" : self.newPasswordTextField.text! as AnyObject , "email" : self.email as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.resetPasswordApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
               
                guard let vcs = self.navigationController?.viewControllers else{
                    return
                }
                
                for vc in vcs{
                    
                        if vc.isKind(of: LoginVC.self){
                       _ = self.navigationController?.popToViewController(vc, animated: true)
                        
                    }
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
    }
}

