


import UIKit
import CoreLocation

class PaymentVC: UIViewController {
    
    
    var paymentModeArray =
        ["onlyUs","paxm","payoner","paypal"]
    
    var paymentData : [String:String] = ["holderName":"","holderPhone":"","accountNumber":"","verifyAccountNumber":"","bankName":"","bankLocation":"","country":"","state":"","city":"","email":""]
    
    
    var PlaceholderArray = ["ACCOUNT HOLDER NAME*","PHONE NUMBER*","ACCOUNT NUMBER*","VERIFY ACCOUNT NUMBER*","BANK NAME*","BANK LOCATION*","COUNTRY*","SATAE*","CITY*"]
  
    var selectedIndex : Int = 0
    var askBeforeSelection : Int = 0
    
    var lat : Double?
    var long : Double?
    
    var status : String?
    
    @IBOutlet weak var authoriseButton: UIButton!
    @IBOutlet weak var payPalButton: UIButton!
    @IBOutlet weak var paxmButton: UIButton!
    @IBOutlet weak var poyeneorButton: UIButton!
    @IBOutlet weak var onlyUsButton: UIButton!
    @IBOutlet weak var paymentCollectionView: UICollectionView!
    @IBOutlet weak var paymentInformationTableView: UITableView!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func paxumButtontapped(_ sender: UIButton) {
        
    }
    
    @IBAction func poyeneorButtonTapped(_ sender: Any) {
        
    }
    
    
    @IBAction func paxmButtonTapped(_ sender: UIButton) {
        
    }
    
    
    @IBAction func onlyUsButtonTapped(_ sender: UIButton) {
        
        
    }
    
    @IBAction func checkButtonTapped(_ sender: UIButton) {
        if sender.isSelected{
        self.checkButton.setImage(UIImage(named:"unckecked"), for: UIControlState.normal)
       
        }else{
            self.checkButton.setImage(UIImage(named:"checked"), for: UIControlState.normal)
        }
        
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func saveButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if Networking.isConnectedToNetwork{
        
        if isAllFieldsVerified(){
            
            if CurentUser.countryCode == "US"{
            self.addAccountService(residency: "1")
            }else{
                self.addAccountService(residency: "0")
            }
        }
    }else{
            
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
}


extension PaymentVC{
    
    func setUpSubView(){
        self.paymentCollectionView.delegate = self
        self.paymentCollectionView.dataSource = self
        self.paymentInformationTableView.delegate = self
        self.paymentInformationTableView.dataSource = self
        
        //self.paymentCollectionView.backgroundColor = UIColor.green
        
        if CurentUser.countryCode == "US"{
            self.selectedIndex = 0
            self.askBeforeSelection = 0
            self.paymentModeArray =  ["onlyUs","paypal"]

        }else{
            self.selectedIndex = 1
            self.askBeforeSelection = 1

            self.paymentModeArray =  ["onlyUs","paypal"]

        }
        
        self.setPlaceholderArray()
        
        
    self.checkButton.isSelected = false
    self.checkButton.setImage(UIImage(named:"unckecked"), for: UIControlState.normal)
        
        self.paymentInformationTableView.isHidden = true
        self.paymentCollectionView.isHidden = true
        //self.checkButton.isSelected = false
        
        printDebug(object: self.checkButton.isSelected)
        
        self.getAccountData()

    }
    
    func setPlaceholderArray(){
        if self.selectedIndex == 0{
            self.PlaceholderArray = ["ACCOUNT HOLDER NAME*","PHONE NUMBER*","ACCOUNT NUMBER*","VERIFY ACCOUNT NUMBER*","BANK NAME*","BANK LOCATION*","COUNTRY*","SATAE*","CITY*"]

        }else{
            self.PlaceholderArray = ["EMAIL*"]
        }
        self.paymentInformationTableView.reloadData()
    }
    
    
    
    func isAllFieldsVerified() -> Bool{
        
        //["holderName":"","holderPhone":"","accountNumber":"","verifyAccountNumber":"","bankName":"","bankLocation":"","email":""]
        
        if self.selectedIndex == 0{
        if self.paymentData["holderName"] == ""{
        
            CommonFunction.showTsMessageError(message: NSLocalizedString("name emptyy",comment: ""))

         return false
        }else if self.paymentData["holderPhone"] == ""{
            
            CommonFunction.showTsMessageError(message: NSLocalizedString("phone empty", comment: ""))
            
            return false

        }else if self.paymentData["accountNumber"] == ""{
            
             CommonFunction.showTsMessageError(message: NSLocalizedString("accounr number empty", comment: ""))
            
            return false

        }else if self.paymentData["verifyAccountNumber"] == ""{
            
             CommonFunction.showTsMessageError(message: NSLocalizedString("empty verify account number empty", comment: ""))
            
            return false

        }else if self.paymentData["bankName"] == ""{
            
             CommonFunction.showTsMessageError(message: NSLocalizedString("empty bank name", comment: ""))
            
            return false

        }else if self.paymentData["bankLocation"] == ""{
            
             CommonFunction.showTsMessageError(message: NSLocalizedString("empty bank location", comment: ""))
            
            return false

        }else if self.paymentData["country"] == ""{
            CommonFunction.showTsMessageError(message: NSLocalizedString("empty country", comment: ""))
            return false
        }else if self.paymentData["state"] == ""{
            CommonFunction.showTsMessageError(message: NSLocalizedString("empty state", comment: ""))
            return false
        }else if self.paymentData["city"] == ""{
            CommonFunction.showTsMessageError(message: NSLocalizedString("empty city", comment: ""))
            return false
        }else if !self.checkButton.isSelected{
        
            CommonFunction.showTsMessageError(message: NSLocalizedString("authorize whozout", comment: ""))
        
            return false
        }
        else{
            return true
            }
        }else{
            printDebug(object: self.paymentData["email"] )
            if self.paymentData["email"] == ""{
                  CommonFunction.showTsMessageError(message: NSLocalizedString("email empty", comment: ""))
                return false
            }else if !CommonFunction.isValidEmail(testStr: self.paymentData["email"]!){
                CommonFunction.showTsMessageError(message: NSLocalizedString("invalid email", comment: ""))
                return false
            }else if !self.checkButton.isSelected{
                
                CommonFunction.showTsMessageError(message: NSLocalizedString("authorize whozout", comment: ""))
                
                return false
            }else{
                return true
                
            }
        }
        
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

//MARK:- get location back delegate
//====================================
extension PaymentVC : GetBackCountry{
    
    func getCountry(countryCode: String, country: String) {
        
    }
    
    func getLocationBack(lat:Double,long:Double,address: String) {
        
        printDebug(object: "address is \(address)")
        
        self.paymentData["bankLocation"] = address
        
        self.lat = lat
        self.long = long
        self.paymentInformationTableView.reloadData()
    }
    
}


extension PaymentVC : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if CurentUser.countryCode == "US"{
         
        return CGSize(width: (self.paymentCollectionView.frame.size.width / 2) - 10, height: self.paymentCollectionView.frame.height)

        }else{
            if indexPath.row == 0{
                return CGSize(width: 0, height: self.paymentCollectionView.frame.height)
            }else{
                return CGSize(width: (self.paymentCollectionView.frame.size.width / 2) - 10, height: self.paymentCollectionView.frame.height)
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "paymentCollectionViewCell", for: indexPath) as! PaymentCollectionViewCell
        
        cell.paymentModeImageView.image = UIImage(named: self.paymentModeArray[indexPath.row])
        
        cell.showTickOrNot(index: indexPath.row, selectedIndex: self.selectedIndex)
        
        return cell
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        printDebug(object: "index...\(indexPath.row)")
        
        //printDebug(object: self.paymentData["status"])
        
    if self.status != nil{
        self.askBeforeSelection = indexPath.row
        _ = VKCAlertController.alert(title: "Pending Approval", message: "If you will change your payment method, your information will again be approved by the admin.", buttons: ["PROCEED","CANCEL"], tapBlock: { (_, index) in
            
            if index == 0{
                self.selectedIndex = self.askBeforeSelection
                self.paymentCollectionView.reloadData()
                self.setPlaceholderArray()
            }
            
        })
    }else{
        self.askBeforeSelection = indexPath.row
        self.selectedIndex = self.askBeforeSelection
        self.paymentCollectionView.reloadData()
        self.setPlaceholderArray()

        }
    }
}


//MARK:- Payment Tableview
//===========================
extension PaymentVC : UITableViewDataSource,UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.PlaceholderArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "paymentTableViewCell") as! PaymentTableViewCell
        
        let str = CommonFunction.attributeStringColor(main_string: self.PlaceholderArray[indexPath.row], string_to_color: "*", color: UIColor(colorLiteralRed: 223/255, green: 27 / 255, blue: 27/255, alpha: 1.0))
        cell.paymentTextField.attributedPlaceholder = str
        cell.paymentTextField.delegate = self
        cell.setUserInteraction(row:indexPath.row)
        
        cell.setKeyBoardType(row: indexPath.row)
        
        if self.selectedIndex == 0{
        cell.setDataInFields(row: indexPath.row, dataDict: self.paymentData)
        }else{
            
            cell.paymentTextField.text = self.paymentData["email"]
            
        }

        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 5{
        sharedAppdelegate.startLocationManager()
        
        if self.isLocationEnabled(){
            let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "SelectLocationID") as! SelectLocationVC
            vc.getCountryDelegate = self
            vc.commingFrom = .Payment
            vc.searchlatitude = self.lat
            vc.searchLongitude = self.long
            self.navigationController?.present(vc, animated: true, completion: nil)
        }
     }
        
    }
}


extension PaymentVC:UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        let index = textField.tableViewIndexPath(tableView: self.paymentInformationTableView)
        
        guard let cell = self.paymentInformationTableView.cellForRow(at:index! as IndexPath) as? PaymentTableViewCell else{
            return
        }
        
        cell.seperatorView.backgroundColor = AppColors.pinkColor
        
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        
        let index = textField.tableViewIndexPath(tableView: self.paymentInformationTableView)

        if string == " " && range.location == 0{
            return false
        }
        
        let  char = string.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
    
        if self.selectedIndex == 0{
        
        if index?.row == 0{
            print(CommonFunction.isValidName(value: string))
            
            if (textField.text?.characters.count)! == 50 && isBackSpace != -92{
                return false
            }else if CommonFunction.isValidName(value: string){
                self.paymentData["holderName"] = textField.text

                return true
            }else{
                return false
            }
            
        }else if index?.row == 1{
            
            if (textField.text?.characters.count)! == 12 && isBackSpace != -92{
                return false
            }else{
                self.paymentData["holderPhone"] = textField.text

                return true
            }

        }else if index?.row == 2 {
            
            if (textField.text?.characters.count)! == 20 && isBackSpace != -92{
                return false
            }else{
                self.paymentData["accountNumber"] = textField.text

                return true
            }
            
        }else if index?.row == 3 {
            
            if (textField.text?.characters.count)! == 20 && isBackSpace != -92{
                return false
            }else{
                self.paymentData["verifyAccountNumber"] = textField.text
                
                return true
            }
            
        }else if index?.row == 4{
            
            if (textField.text?.characters.count)! == 40 && isBackSpace != -92{
                return false
            }else if CommonFunction.isValidName(value: string){
                self.paymentData["bankName"] = textField.text

                return true
            }else{
                return true
            }
            
            
            
        }else if index?.row == 6{
            if (textField.text?.characters.count)! == 30 && isBackSpace != -92{
                return false
            }else if CommonFunction.isValidName(value: string){
                self.paymentData["country"] = textField.text

                return true
            }else{
                return true
            }

        }else if index?.row == 7{
            if (textField.text?.characters.count)! == 30 && isBackSpace != -92{
                return false
            }else if CommonFunction.isValidName(value: string){
                return true
            }else{
                self.paymentData["state"] = textField.text

                return true
            }
            
            }
        else if index?.row == 8{
            if (textField.text?.characters.count)! == 30 && isBackSpace != -92{
                return false
            }else if CommonFunction.isValidName(value: string){
                return true
            }else{
                self.paymentData["city"] = textField.text

                return true
            }
            
            }

        }else{
            
            self.paymentData["email"] = textField.text

            return true
        }
        return true
    }
    
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        
//        let index = textField.tableViewIndexPath(tableView: self.paymentInformationTableView)
//        
//        guard let cell = self.paymentInformationTableView.cellForRow(at:index! as IndexPath) as? PaymentTableViewCell else{
//            return
//        }
//        
//        cell.seperatorView.backgroundmy bank nameColor = AppColors.seperatorGreyColor
//        
//        if index?.row == 0{
//            if self.selectedIndex == 0{
//            self.paymentData["holderName"] = textField.text
//            }else{
//                self.paymentData["email"] = textField.text
//
//            }
//        }else if index?.row == 1{
//            self.paymentData["holderPhone"] = textField.text
//            
//        }else if index?.row == 2{
//            self.paymentData["accountNumber"] = textField.text
//            
//        }else if index?.row == 3{
//            self.paymentData["verifyAccountNumber"] = textField.text
//
//        }else if index?.row == 4{
//            self.paymentData["bankName"] = textField.text
//            
//        }else if index?.row == 5{
//            self.paymentData["bankLocation"] = textField.text
//        }else if index?.row == 6{
//            self.paymentData["country"] = textField.text
//        }else if index?.row == 7{
//            self.paymentData["state"] = textField.text
//        }else if index?.row == 8{
//            self.paymentData["city"] = textField.text
//        }
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let index = textField.tableViewIndexPath(tableView: self.paymentInformationTableView)
        
        guard let cell = self.paymentInformationTableView.cellForRow(at:NSIndexPath(item: (index?.row)! + 1, section: 0) as IndexPath) as? SignUpTableViewCell else{
            return true
        }
        
        if index?.row == 6{
            //            if self.isAllFieldsVarified(){
            //                self.signUp()
            //            }
        }else{
            cell.signUpTextField.becomeFirstResponder()
        }
        
        return true
    }
}




extension PaymentVC{
    
    func getAccountData(){
        
        let params : jsonDictionary = ["userId":CurentUser.userId as AnyObject]
        printDebug(object: params)
        CommonFunction.showLoader(vc: self)
         UserService.getAccountApi(params: params) { (success, data, message) in
            
            self.paymentInformationTableView.isHidden = false
            self.paymentCollectionView.isHidden = false

            if success{
                
                CommonFunction.hideLoader(vc: self)
                self.selectedIndex = Int((data?.accountType)!)! - 1
                
                self.setPlaceholderArray()
                self.paymentData["holderName"] = data?.accountHolderName
                self.paymentData["holderPhone"] = data?.phoneNumber
                self.paymentData["accountNumber"] = data?.accountNumber
                 self.paymentData["bankLocation"] = data?.bankLocation
                self.paymentData["bankName"] = data?.bankName
                self.paymentData["country"] = data?.country
                self.paymentData["state"] = data?.state
                self.paymentData["city"] = data?.city

                
                self.status = data?.status
                
                if data?.status == "0"{
                 
                    _ = VKCAlertController.alert(title: "Pending Approval", message: "Your information is under approval. You will be notified once it is approved. ", buttons: ["Ok"], tapBlock: { (_, index) in
                        
                        if index == 0{
                        _ = self.navigationController?.popViewController(animated: true)

                        }
                        
                    })
                }
                
             self.paymentData["email"] = data?.email
             self.paymentCollectionView.reloadData()
             self.paymentInformationTableView.reloadData()
                
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    func addAccountService(residency:String){
    
        var params : jsonDictionary = [
            "userId" : CurentUser.userId as AnyObject ,
            "isUsaResidency" : residency as AnyObject,"accountType" : "\(self.selectedIndex + 1)" as AnyObject,
            "lat" : "\(self.lat ?? 0.0)" as AnyObject,
            "lng" : "\(self.long ?? 0.0)" as AnyObject
            ]
        
        params["phoneNumber"] = self.paymentData["holderPhone"] as AnyObject
        
        params["accountHolderName"] = self.paymentData["holderName"] as AnyObject
        
        params["accountNumber"] = self.paymentData["accountNumber"] as AnyObject

        params["bankName"] = self.paymentData["bankName"] as AnyObject

        params["bankLocation"] = self.paymentData["bankLocation"] as AnyObject

        params["email"] = self.paymentData["email"] as AnyObject
        
        params["country"] = self.paymentData["country"] as AnyObject
        
        params["state"] = self.paymentData["state"] as AnyObject
        
        params["city"] = self.paymentData["city"] as AnyObject
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
       UserService.addAccountApi(params: params) { (success) in
        CommonFunction.hideLoader(vc: self)
        if success{
            _ = self.navigationController?.popViewController(animated: true)
            CommonFunction.hideLoader(vc: self)
            CommonFunction.showTsMessageSuccess(message: "Thanks, your account information is sent for approval.")
        }else{
            
            CommonFunction.hideLoader(vc: self)
            
        }
        
        }
        
    }
    
}


class PaymentTableViewCell : UITableViewCell{
    @IBOutlet weak var paymentTextField: UITextField!
    @IBOutlet weak var seperatorView: UIView!
    
    func setKeyBoardType(row:Int){
        
        switch row {
        case 0,4,5,6,7,8:
            self.paymentTextField.keyboardType = .default
        case 1,2,3:
            self.paymentTextField.keyboardType = .numberPad

        default:
            fatalError("invalid row")
        }
        
    }
    
    func setUserInteraction(row:Int){
        
        if row == 5{
            self.paymentTextField.isUserInteractionEnabled = false
        }else{
            self.paymentTextField.isUserInteractionEnabled = true

        }
    }
    
    
    func setDataInFields(row:Int,dataDict:[String:String]){
     

        
        switch row {
        case 0:
            if dataDict["holderName"] != ""{
             self.paymentTextField.text = dataDict["holderName"]
            }else{
                self.paymentTextField.text = ""
            }
            
        case 1:
            
            if dataDict["holderPhone"] != ""{
                self.paymentTextField.text = dataDict["holderPhone"]
            }else{
                self.paymentTextField.text = ""
            }
        case 2:
            if dataDict["accountNumber"] != ""{
                self.paymentTextField.text = dataDict["accountNumber"]
            }else{
                self.paymentTextField.text = ""
            }
            
        case 3:
            if dataDict["verifyAccountNumber"] != ""{
                self.paymentTextField.text = dataDict["verifyAccountNumber"]
            }else{
                self.paymentTextField.text = ""
            }
        case 4:
            if dataDict["bankName"] != ""{
                self.paymentTextField.text = dataDict["bankName"]
            }else{
                self.paymentTextField.text = ""
            }
        case 5:
            
            if dataDict["bankLocation"] != ""{
                self.paymentTextField.text = dataDict["bankLocation"]
            }else{
                self.paymentTextField.text = ""
            }
            
        case 6:
            if dataDict["country"] != ""{
                self.paymentTextField.text = dataDict["country"]
            }else{
                self.paymentTextField.text = ""
            }
        case 7:
            if dataDict["state"] != ""{
                self.paymentTextField.text = dataDict["state"]
            }else{
                self.paymentTextField.text = ""
            }
        case 8:
            if dataDict["city"] != ""{
                self.paymentTextField.text = dataDict["city"]
            }else{
                self.paymentTextField.text = ""
            }
            
            
            
        default:
            fatalError("invalid row")
        }
    }
    
}

class PaymentCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var paymentModeImageView: UIImageView!
    @IBOutlet weak var paymentTickImageView: UIImageView!
    
    
    func showTickOrNot(index:Int,selectedIndex:Int){
        
        if index == selectedIndex{
            
            self.paymentTickImageView.isHidden = false
        }else{
            
            self.paymentTickImageView.isHidden = true
            
        }
        
    }
    
}



