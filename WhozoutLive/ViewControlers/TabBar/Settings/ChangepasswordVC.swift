
import UIKit

class ChangepasswordVC : UIViewController {

    //MARK:- Variables
    //===================
    
    
    
    //MARK:- IBOutlets
    //===================
    
    @IBOutlet weak var oldPasswordTextField: UITextField!
    @IBOutlet weak var newPasswordtextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var SUBMITBUTTON: UIButton!
    @IBOutlet weak var newPasswordSeperator: UIView!
    @IBOutlet weak var oldPasswordSeperator: UIView!
    @IBOutlet weak var confirmPasswordSeperator: UIView!
    
    
    //MARK:- view life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    
    }

//MARK:- IBActions
//===============
    @IBAction func submitButtontapped(_ sender: UIButton) {
        
        if self.isAllFieldsVarified(){
            
            if Networking.isConnectedToNetwork{
                self.changepasswordService()
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))

            }
            
        }else{
            
        }
    }
    
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}

//MARK:- Private functions
//===============================
private extension ChangepasswordVC{
    
    //MARK:- Set up view
    //=====================
    func setUpSubView(){
        
        self.oldPasswordTextField.delegate = self
        self.newPasswordtextField.delegate = self
        self.confirmPasswordTextField.delegate = self
        
        self.oldPasswordTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "OLD PASSWORD")
        self.newPasswordtextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "NEW PASSWORD")
        self.confirmPasswordTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "CONFIRM PASSWORD")
        
        self.oldPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        self.newPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        self.confirmPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor

    }
    
    //MARK:- Verify all fields
    //==============================
    
    func isAllFieldsVarified() -> Bool{
        
        if (self.oldPasswordTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("old password empty", comment: ""))
            return false
        }else if (self.oldPasswordTextField.text?.characters.count)! < 6{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password length", comment:""))
            return false
        }else if (self.newPasswordtextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("new password empty", comment: ""))
            return false
        }else if (self.newPasswordtextField.text?.characters.count)! < 6{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password length", comment:""))
            return false
        }else if (self.confirmPasswordTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("confirm password empty", comment: ""))
            return false
        }else if self.newPasswordtextField.text != self.confirmPasswordTextField.text{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password match", comment:""))
            return false
        }else if self.newPasswordtextField.text == self.oldPasswordTextField.text{
         CommonFunction.showTsMessageError(message: NSLocalizedString("old pass new pass not same", comment:""))
            return false
        }
        return true
    }

    
}

//MARK:- Textfield delegate
//===========================
extension ChangepasswordVC : UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.oldPasswordTextField{
            self.oldPasswordSeperator.backgroundColor = AppColors.pinkColor
            self.newPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
             self.confirmPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        }else if textField == self.newPasswordtextField{
            self.oldPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
            self.newPasswordSeperator.backgroundColor = AppColors.pinkColor
            self.confirmPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        }else{
            self.oldPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
            self.newPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
            self.confirmPasswordSeperator.backgroundColor = AppColors.pinkColor
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.oldPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        self.newPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
        self.confirmPasswordSeperator.backgroundColor = AppColors.seperatorGreyColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        if string == " " && range.location == 0{
            return false
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.text?.characters.count)! == 25 && isBackSpace != -92{
            return false
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == self.newPasswordtextField{
            
        }else{
            
        }
        return true
    }
}


//MARK:- Webservice
//=====================
extension ChangepasswordVC{
    
    func changepasswordService(){
    
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "oldPassword" : self.oldPasswordTextField.text as AnyObject , "password" : self.newPasswordtextField.text as AnyObject ]
    
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.changePasswordApi(params: params) { (success) in
    
            if success{
                CommonFunction.hideLoader(vc: self)
                CommonFunction.showTsMessageSuccess(message: "Password changed successfully.")
                _ = self.navigationController?.popViewController(animated: true)
            }else{
                
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    
    
}




