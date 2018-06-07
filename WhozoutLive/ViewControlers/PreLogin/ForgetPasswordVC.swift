
import UIKit

protocol GetBackEmail {
    func getEmailBack(email:String)
}

class ForgetPasswordVC : BaseViewControler {
    
    //IBOutlet
    //==============
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var seperatorView: UIView!
    
    //MARK:- View life cycle
    //=======================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func nextButtontappd(_ sender: UIButton) {
        self.view.endEditing(true)
        self.view.endEditing(true)
        if self.isAllFieldsVarified(){
            self.requestotp()
        }
    }
    
    @IBAction func backbuttonTapped(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}


//MARK:= Private functions
//==============================
private extension ForgetPasswordVC{
    
    //MARK:- Set up your view
    //===========================
    func setUpSubView(){
        self.emailTextField.delegate = self
        self.emailTextField.autocorrectionType = .no
        self.emailTextField.keyboardType = .emailAddress
        self.emailTextField.attributedPlaceholder = CommonFunction.getPlaceHolderColor(text: "EMAIL ADDRESS")
        self.nextButton.layer.cornerRadius = 2.0
        self.nextButton.clipsToBounds = true
    }
    
    //MARK:- Is all fields verified
    //=================================
    func isAllFieldsVarified() -> Bool{
        if (self.emailTextField.text?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("email empty", comment: ""))
            return false
        }else if !CommonFunction.isValidEmail(testStr: self.emailTextField.text!){
            CommonFunction.showTsMessageError(message: NSLocalizedString("invalid email", comment: ""))
            return false
        }
        return true
    }
}

//MARK:- Textfield delegate
//============================
extension ForgetPasswordVC : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.seperatorView.backgroundColor = AppColors.pinkColor
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.seperatorView.backgroundColor = AppColors.seperatorGreyColor
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
    
}

//MARK:- webservices
//=====================
extension ForgetPasswordVC{
    
    //MARK:- Request otp Api
    //==========================
    func requestotp(){
        let params : [String : AnyObject] = ["email" : self.emailTextField.text! as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.requestOtpApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
                let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "OtpID") as! OtpVC
                vc.email = self.emailTextField.text
                vc.del = self
                self.emailTextField.text = ""
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
    }
}

//MARK:- Get email back 
//======================
extension ForgetPasswordVC : GetBackEmail{
    
    func getEmailBack(email: String) {
        self.emailTextField.text = email
    }
}

