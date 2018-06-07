

import UIKit

class OtpVC: BaseViewControler {
    
    //Variables
    //===============
    var email : String!
    var del : GetBackEmail!
    
    //MARK:- IBOutlets
    //===================
    @IBOutlet weak var otpTextField: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    @IBOutlet weak var otpSeperatorview: UIView!
    @IBOutlet weak var editEmailButton: UIButton!
    @IBOutlet weak var resendOtpButton: UIButton!
    

    
    //MARK:- view life cycle
    //================================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    

    
}

//MARK:- private functions
//==========================

private extension OtpVC{
    
    //MARK:- Set up view
    //======================
    func setUpSubView(){
        self.otpTextField.delegate = self
        self.otpTextField.autocorrectionType = .no
        self.otpTextField.autocorrectionType = .no
        self.otpTextField.keyboardType = .numberPad
        self.verifyButton.isUserInteractionEnabled = false
        self.verifyButton.backgroundColor = AppColors.placeHolderColor
        self.otpTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "OTP/Code")
        self.verifyButton.layer.cornerRadius = 2.0
        self.verifyButton.clipsToBounds = true

    }
    
    //MARK:- Validations
    //========================
    func isAllFieldsVarified() -> Bool{
        
        if (self.otpTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("otp empty", comment: ""))
            return false
        }
        return true
    }
    
}

//IBActions
//==============
extension OtpVC{
    
    
    @IBAction func verifyButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.isAllFieldsVarified(){
            self.confirmOtpService()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editEmailbuttonTapped(_ sender: UIButton) {
        self.del.getEmailBack(email: self.email)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func resendOtpButtonTapped(_ sender: UIButton) {
        self.requestotp()
    }
}

//MARK:- Textfield delegate
//============================

extension OtpVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.otpSeperatorview.backgroundColor = AppColors.pinkColor
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.otpSeperatorview.backgroundColor = AppColors.seperatorGreyColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == " " && range.location == 0{
            return false
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if (textField.text?.characters.count)! == 6 && isBackSpace != -92{
            return false
        }
        
    CommonFunction.delayy(delay: 0.1) {
    
        
        if textField.text?.characters.count == 6{
            self.verifyButton.isUserInteractionEnabled = true
            self.verifyButton.backgroundColor = AppColors.pinkColor
        }else{
            self.verifyButton.isUserInteractionEnabled = false
            self.verifyButton.backgroundColor = AppColors.placeHolderColor
            
        }
        }
 
        
        return true
    }
    
}

//Webservices
//==================
extension OtpVC{
    
    //MARK:- Confirm otp Api
    //===========================
    func confirmOtpService(){
        let params : [String : AnyObject] = ["otp" : self.otpTextField.text! as AnyObject , "email" : self.email as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.confirmotpApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
                let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "ResetPasswordID") as! ResetPasswordVC
                vc.email = self.email
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
    }
    
    
    func requestotp(){
        let params : [String : AnyObject] = ["email" : self.email as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.requestOtpApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
    }
}
