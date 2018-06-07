

import UIKit
import CoreLocation


protocol GetBackFromMap{
    func getBack()
}

protocol GetBackCountry{
    func getCountry(countryCode:String,country:String)
    func getLocationBack(lat:Double,long:Double,address:String)
}

class SignUpVC: BaseViewControler {
    
    
    //MARK:- variables
    //=================
    
    var dateFormater = DateFormatter()
    var dataDict = ["name" : "" ,"screenNAme" : "","email" : "","confirmEmail" : "","password" : "","age" : "","dob" :"","bio" : "","country" : "","countrycode" : ""]
    
    let placeHolderArray = ["NAME*","SCREEN NAME*","EMAIL ADDRESS*","CONFIRM EMAIL ADDRESS*","PASSWORD*","AGE* (should be 18 years or above from current date)","BIO"]
    let datePicker = UIDatePicker()
    
    
    //MARK:- IBOutlets
    //=================
    @IBOutlet weak var signUpTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    @IBOutlet weak var allowLocationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var termsAndCondirionsLabel: TTTAttributedLabel!
    
    //MARK:- view life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
    
        self.view.endEditing(true)
        if self.isAllFieldsVarified(){
             self.signUp()
        }
      
        
    }
    
    @IBAction func allowLocationButtontapped(_ sender: UIButton) {
        
        if Networking.isConnectedToNetwork{
        
        if sender.isSelected{
           
            self.allowLocationButton.setImage(UIImage(named:"unckecked"), for: UIControlState.normal)
            self.dataDict["country"] = ""
             self.dataDict["countryCode"] = ""
            
        }else{
            
            sharedAppdelegate.startLocationManager()
            
            if self.isLocationEnabled(){
                let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "SelectLocationID") as! SelectLocationVC
                vc.getCountryDelegate = self
                vc.getBack = self
                vc.commingFrom = .SignUp
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
          
        self.allowLocationButton.setImage(UIImage(named:"checked"), for: UIControlState.normal)
            printDebug(object: "open")
            
        }
        
        sender.isSelected = !sender.isSelected
        }else{
            
             CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            
        }
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginID") as! LoginVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    func handleDate(sender: UIDatePicker){
        
        guard let cell = self.signUpTableView.cellForRow(at:  NSIndexPath(row: 5, section: 0) as IndexPath) as? SignUpTableViewCell else{
            return
        }
                self.dateFormater.dateFormat = "yyyy-MM-dd"
        printDebug(object: Date().yearsFrom(date: sender.date))
        self.dataDict["age"] = "\(Date().yearsFrom(date: sender.date))"
        cell.signUpTextField.text = self.dataDict["age"]
        self.dataDict["dob"] = self.dateFormater.string(from: sender.date)
        
           }
}

//MARK:- Private functions extensions
//=====================================
 extension SignUpVC{
    //MARK:- setup your view
    //========================
    func setUpSubView(){
        self.signUpTableView.delegate = self
        self.signUpTableView.dataSource = self
        self.dateFormater.dateFormat = "yyyy-MM-dd"
        let maxDate = Date().xYears(-18)
        self.datePicker.maximumDate = maxDate
        self.datePicker.date = maxDate
        self.dataDict["dob"] = self.dateFormater.string(from: maxDate)
        self.datePicker.datePickerMode = .date
        self.datePicker.addTarget(self, action: #selector(SignUpVC.handleDate(sender:)), for: UIControlEvents.valueChanged)
        self.allowLocationButton.setImage(UIImage(named:"unckecked"), for: UIControlState.normal)
        self.allowLocationButton.isSelected = false
        self.createAccountButton.layer.cornerRadius = 2.0
        self.createAccountButton.clipsToBounds = true
        self.setAttributedLabels()
        self.termsAndCondirionsLabel.isUserInteractionEnabled = true
        
    }
    
    func setAttributedLabels(){
        
        self.termsAndCondirionsLabel.delegate = self
        
        let str:NSString = self.termsAndCondirionsLabel.text! as NSString
        
        let tandCAttrString = NSAttributedString(string:str as String, attributes: [NSFontAttributeName: UIFont.systemFont(ofSize: 12)])
            self.termsAndCondirionsLabel.setText(tandCAttrString)
        
         let linkAttributes = [NSForegroundColorAttributeName:  AppColors.pinkColor,NSUnderlineStyleAttributeName: NSNumber(value:false),]
        
        self.termsAndCondirionsLabel.linkAttributes = linkAttributes
        
        //self.termsAndCondirionsLabel.inactiveLinkAttributes
        
        let activeLinkAttributes = [
            NSForegroundColorAttributeName: AppColors.pinkColor,
            NSUnderlineStyleAttributeName: NSNumber(value:false)
            ]
 
        self.termsAndCondirionsLabel.activeLinkAttributes = activeLinkAttributes
       // By Signing up, you agree to the Terms of use & Privacy Policy
        let range1 : NSRange = str.range(of: "Terms of use")
        
        let range2 : NSRange = str.range(of: "Privacy Policy")

        self.termsAndCondirionsLabel.addLink(to: URL(string: PolicyUrl.terms)! as URL!, with: range1)
        
        self.termsAndCondirionsLabel.addLink(to: URL(string: PolicyUrl.about)! as URL!, with: range2)
        
    }
    
    
    
    //MARK:- validate all fields
    //===========================
    func isAllFieldsVarified() -> Bool{
    
        if (self.dataDict["name"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("name Empty", comment: ""))
            return false
        }else if (self.dataDict["name"]?.characters.count)! < 3{
            CommonFunction.showTsMessageError(message: NSLocalizedString("name minimum length", comment: ""))
            return false
            
        }else if (self.dataDict["screenNAme"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("screen name Empty", comment: ""))
            return false
            
        }else if (self.dataDict["screenNAme"]?.characters.count)! < 3{
            CommonFunction.showTsMessageError(message: NSLocalizedString("screen name minimum length", comment: ""))
            return false
            
        }else if (self.dataDict["email"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("email empty", comment: ""))
            return false
        }else if !CommonFunction.isValidEmail(testStr: self.dataDict["email"]!){
            CommonFunction.showTsMessageError(message: NSLocalizedString("invalid email", comment: ""))
            return false
        }else if (self.dataDict["confirmEmail"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("confirm email empty", comment:""))
            return false
        }else if self.dataDict["email"] != self.dataDict["confirmEmail"]{
            CommonFunction.showTsMessageError(message: NSLocalizedString("email confirm email does not match", comment:""))
            return false
        }else if (self.dataDict["password"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password empty", comment: ""))
            return false
        }else if (self.dataDict["password"]?.characters.count)! < 6{
            CommonFunction.showTsMessageError(message: NSLocalizedString("password length", comment: ""))
            return false
        }else if (self.dataDict["age"]?.isEmpty)!{
            CommonFunction.showTsMessageError(message: NSLocalizedString("empty date", comment: ""))
            return false
            
        }else if (self.dataDict["country"]?.isEmpty)!{
             CommonFunction.showTsMessageError(message: NSLocalizedString("allow location", comment: ""))
            return false

        }
        
        return true
    }
    
    
    //MARK:- is location enabled
    //=============================
    func isLocationEnabled() -> Bool{
        if CLLocationManager.locationServicesEnabled()
        {
            if !( CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways)
            {
                let alert = UIAlertController(title: "Alert", message: "Please enable your location service", preferredStyle: UIAlertControllerStyle.alert)
                
                alert.addAction(UIAlertAction(title: "Enable Location", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    
                    UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                        
                        
                    })
                    

                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
                return false
            }
                
            else
            {

                return true
                
                
            }
        }else{
            let alert = UIAlertController(title: "Alert", message: "Please enable your location service", preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Enable Location", style: UIAlertActionStyle.default, handler: { (UIAlertAction) -> Void in
                UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                    
                    
                })
                

            }))
            
            self.present(alert, animated: true, completion: nil)
            return false
        }
        
    }
    
}

extension SignUpVC : TTTAttributedLabelDelegate{
    
    
    func attributedLabel(_ label: TTTAttributedLabel!, didSelectLinkWith url: URL!) {
        


        printDebug(object: url)
        printDebug(object: url.absoluteString)
        
        if #available(iOS 10.0, *) {
            
            if url.absoluteString == "http://eolith.live/appcontent/terms"{
                        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
                        vc.urlToLoad = PolicyUrl.terms
                        vc.heading = "TERMS OF USE"
                
                self.navigationController?.pushViewController(vc, animated: true)
                
            }else{
                let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
                vc.urlToLoad = PolicyUrl.privacy
                vc.heading = "PRIVACY POLICY"
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
            //UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url as URL)
        }
    }
    
}


extension SignUpVC : GetBackFromMap{
    func getBack() {
        
        if self.dataDict["country"] == ""{
            self.allowLocationButton.setImage(UIImage(named:"unckecked"), for: UIControlState.normal)
            
            self.allowLocationButton.isSelected = false
        }
    }
}

extension SignUpVC : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.placeHolderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "signUpTableViewCell") as! SignUpTableViewCell
        
        //cell.signUpTextField.attributedPlaceholder = //CommonFunction.getPlaceHolderColor(text: self.placeHolderArray[indexPath.row])
            
        let str = CommonFunction.attributeStringColor(main_string: self.placeHolderArray[indexPath.row], string_to_color: "*", color: UIColor(colorLiteralRed: 223/255, green: 27 / 255, blue: 27/255, alpha: 1.0))
    cell.signUpTextField.attributedPlaceholder = str
        
        cell.seperatorView.backgroundColor = AppColors.seperatorGreyColor

        cell.signUpTextField.delegate = self
        
        cell.signUpTextField.autocorrectionType = .no
        
        cell.setsecureTextField(index: indexPath.row)
        
        cell.setReturnKeyType(index: indexPath.row)
        
        if indexPath.row == 5{
            cell.signUpTextField.inputView = self.datePicker
            
        }else{
            
        }
    
        return cell
    }
}

//MARK:- Textfield delegates

extension SignUpVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField){
        
        let index = textField.tableViewIndexPath(tableView: self.signUpTableView)
        
        guard let cell = self.signUpTableView.cellForRow(at:index! as IndexPath) as? SignUpTableViewCell else{
            return
        }
        
        cell.seperatorView.backgroundColor = AppColors.pinkColor
        
     
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
       // let placeHolderArray = ["NAME*","SCREEN NAME*","EMAIL ADDRESS*","CONFIRM EMAIL ADDRESS*","PASSWORD*","AGE* (should be 18 years or above from curent date)","BIO"]

        
        
        let index = textField.tableViewIndexPath(tableView: self.signUpTableView)
        
        if string == " " && range.location == 0{
            return false
        }
        
        if index?.row == 0{
            print(CommonFunction.isValidName(value: string))
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (textField.text?.characters.count)! == 50 && isBackSpace != -92{
                return false
            }
            
            if CommonFunction.isValidName(value: string){
                return true
            }else{
                return false
            }
            
        }else if index?.row == 1{
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")

            if (textField.text?.characters.count)! == 50 && isBackSpace != -92{
                return false
            }else{
                return true
            }
            
            
        }else if index?.row == 2 || index?.row == 3 || index?.row == 6{
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
            
            if (textField.text?.characters.count)! == 50 && isBackSpace != -92{
                return false
            }else{
                return true
            }

        }else if index?.row == 4{
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")

            if (textField.text?.characters.count)! == 25 && isBackSpace != -92{
                return false
            }else{
                return true
            }
        }
        else{
            return true
        }
        
        
    }
  
    func textFieldDidEndEditing(_ textField: UITextField) {
        let index = textField.tableViewIndexPath(tableView: self.signUpTableView)
        
        guard let cell = self.signUpTableView.cellForRow(at:index! as IndexPath) as? SignUpTableViewCell else{
            return
        }
        
        cell.seperatorView.backgroundColor = AppColors.seperatorGreyColor
        
        
        if index?.row == 0{
            
            self.dataDict["name"] = textField.text
        }else if index?.row == 1{
            self.dataDict["screenNAme"] = textField.text
            
        }else if index?.row == 2{
            self.dataDict["email"] = textField.text
            
        }else if index?.row == 3{
            self.dataDict["confirmEmail"] = textField.text
            
        }else if index?.row == 4{
            self.dataDict["password"] = textField.text
            
        }else if index?.row == 5{
            
            if textField.text == ""{
                
                guard let cell = self.signUpTableView.cellForRow(at:  NSIndexPath(row: 5, section: 0) as IndexPath) as? SignUpTableViewCell else{
                    return
                }
                 self.dataDict["age"] = "18"
                cell.signUpTextField.text = self.dataDict["age"]
            }else{
                self.dataDict["age"] = textField.text

            }
            
        }else if index?.row == 6{
            self.dataDict["bio"] = textField.text
            
        }
        
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let index = textField.tableViewIndexPath(tableView: self.signUpTableView)
        
        guard let cell = self.signUpTableView.cellForRow(at:NSIndexPath(item: (index?.row)! + 1, section: 0) as IndexPath) as? SignUpTableViewCell else{
            return true
        }
        if index?.row == 6{
            if self.isAllFieldsVarified(){
                self.signUp()
            }
        }else{
             cell.signUpTextField.becomeFirstResponder()
        }
       
        
        return true
    }
}

//MARK:- Webservices
//=====================
extension SignUpVC{
    
    func signUp(){
        
       // name username email password countrycode country dob(1985-09-22) bio
        let token =  AppUserDefaults.value(forKey: AppUserDefaults.Key.DevideToken)
        let params : [String:AnyObject] =
            ["name": self.dataDict["name"] as AnyObject ,
        "username" : self.dataDict["screenNAme"] as AnyObject ,
        "email" : self.dataDict["email"]  as AnyObject ,
        "password" : self.dataDict["password"] as AnyObject,
        "countrycode" : self.dataDict["countrycode"] as AnyObject ,
        "country"  : self.dataDict["country"] as AnyObject ,
        "dob" : self.dataDict["dob"] as AnyObject ,
        "bio" :  self.dataDict["bio"] as AnyObject,
         "deviceToken" : token.stringValue as AnyObject]
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.signupApi(params: params) { (success,data) in
        
            if success{
                 CommonFunction.hideLoader(vc: self)
                //SocketHelper.sharedInstance.connectSocket()

                printDebug(object: data)
                let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "ProfileSetUpID") as! ProfileSetUpVC
                self.navigationController?.pushViewController(vc, animated: true)
                
               // CommonFunction.pushToHome()

                
            }else{
                 CommonFunction.hideLoader(vc: self)
            }
            
            
        }
    }

}


extension SignUpVC : GetBackCountry{
    
    func getCountry(countryCode: String, country: String) {
        printDebug(object: countryCode)
        printDebug(object: country)
        self.dataDict["countrycode"] = countryCode
       self.dataDict["country"] = country
    }
    
    func getLocationBack(lat:Double,long:Double,address: String) {
        
        
    }
    
}

class SignUpTableViewCell : UITableViewCell{
    @IBOutlet weak var signUpTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        
    }
    
    func setsecureTextField(index:Int){
        if index == 4{
            self.signUpTextField.isSecureTextEntry = true
        }else{
            self.signUpTextField.isSecureTextEntry = false
            
        }
    }
    
    func setReturnKeyType(index:Int){
        
        switch index{
        case 0,1:
            self.signUpTextField.keyboardType = .default
            self.signUpTextField.returnKeyType = .next
            self.signUpTextField.autocapitalizationType = .sentences
        case 2,3:
            self.signUpTextField.keyboardType = .emailAddress
            self.signUpTextField.returnKeyType = .next
            self.signUpTextField.autocapitalizationType = .none

        case 4:
            self.signUpTextField.returnKeyType = .next
            self.signUpTextField.keyboardType = .default
            self.signUpTextField.autocapitalizationType = .none

        case 5:
            self.signUpTextField.returnKeyType = .next
            self.signUpTextField.keyboardType = .default
            self.signUpTextField.autocapitalizationType = .none

        case 6:
            self.signUpTextField.returnKeyType = .done
            self.signUpTextField.keyboardType = .default
            self.signUpTextField.autocapitalizationType = .sentences
        default:
            fatalError("invalid")
        }
        
    }
}


