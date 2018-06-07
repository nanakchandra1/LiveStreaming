

import UIKit
import MessageUI

class SettingsVC: UIViewController {
    
    //MARK:- Variables
    //=======================
    
    let settings  = ["My Account","Payment","Blocked Contacts","Notification","Change password","About us","Terms of Uses","Faq's","Privacy Policy","Feedback","Share App","Rate App","Logout"]
    
    var documentController: UIDocumentInteractionController!

    
    
    //MARK:- IBOutlets
    //======================
    @IBOutlet weak var settingsTableView: UITableView!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var tokenLeftButton: UIButton!
   // @IBOutlet weak var bellButton: FaveButton!
    
   
 //MARK:- View life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
         printDebug(object: "settings did load")
        self.setUpSubView()
    
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.setPushCount()
        if let tokens = CurentUser.tokenCount{
            
             let tokenInPoints = "\(CommonFunction.formatPoints(num: Double(tokens)!))"
            
            self.tokenLeftButton.setTitle("\(tokenInPoints) Tokens Left", for: UIControlState.normal)
        }
        
        sharedAppdelegate.notificationDelegate = self
    }
    
  

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//MARK:- IBActions
    //====================
    @IBAction func notificationButtonTapped(_ sender: UIButton) {
      
//        let rect = CGRect(x: self.notificationButton.frame.origin.x, y: self.notificationButton.frame.origin.y, width: 30, height: 30)
//        let emogie = FaveButton(
//            frame: rect ,
//            faveIconNormal: #imageLiteral(resourceName: "bell"))
//        
//        self.view.addSubview(emogie)
//        
//        emogie.toggle(emogie)
//        emogie.isHidden = true
//
//        CommonFunction.delayy(delay: 0.5) {
//            emogie.removeFromSuperview()
//        }
        
        
        if Networking.isConnectedToNetwork{
            
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "NotificationID") as! NotificationVC
            
            CommonWebService.sharedInstance.pushCount = 0
            
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
    }

    @IBAction func tokenLeftButtontapped(_ sender: UIButton) {
        if Networking.isConnectedToNetwork{
            CommonWebService.sharedInstance.pushPurchaseToken(from: PurchaseFrom.TokenLessButton)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }

    }
}

//MARK:- Private functions
//===========================
private extension SettingsVC{

    func setUpSubView(){
        self.settingsTableView.delegate = self
        self.settingsTableView.dataSource = self
        sharedAppdelegate.notificationDelegate = self
        self.notificationCountLabel.layer.cornerRadius = 3.0
        self.notificationCountLabel.clipsToBounds = true
        self.tokenLeftButton.layer.borderWidth = 1.0
        self.tokenLeftButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.tokenLeftButton.layer.cornerRadius = 3.0

    }
    
    func openMailCoposer(){
        let mailComposeVC = self.configuredMailComposeViewController(email: "ambrish1.appinventiv@gmail.com")
        if  MFMailComposeViewController.canSendMail(){
            self.present(mailComposeVC, animated: true, completion: nil)
        }else{
            self.showMailErrorAlert()
        }
    }
    
    func setPushCount(){
        self.notificationCountLabel.text = "\(CommonWebService.sharedInstance.pushCount)"
        
        if CommonWebService.sharedInstance.pushCount == 0{
            
            self.notificationCountLabel.isHidden = true
        }else{
            
            self.notificationCountLabel.isHidden = false
        }
    }
}


//MARK:- Tableview datasource and deleate
//==========================================
extension SettingsVC : UITableViewDelegate , UITableViewDataSource{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.count
    }
    
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
     return 70
    }
    
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingsCell") as! SettingsCell
        cell.settingsLabel.text = self.settings[indexPath.row]
        cell.hideShowSwitch(row:intmax_t(indexPath.row))
        cell.setNotificationButtonStatus(status: CurentUser.notificationSettings!)
        
        cell.notificationSwitch.addTarget(self, action: #selector(SettingsVC.notificationToggleChanged), for: .valueChanged)

        return cell
    }
    
    
     func aesEncrypt(params : AnyObject) -> String {
        
        func encrypt(params: AnyObject) -> String {
            
            func JSONStringify(value: AnyObject, prettyPrinted: Bool = false) -> String {
                let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : []
                if JSONSerialization.isValidJSONObject(value) {
                    if let data = try? JSONSerialization.data(withJSONObject: value, options: options) {
                        if let string = String(data: data, encoding: String.Encoding.utf8){
                            return string
                        }
                    }
                }
                return ""
            }
            
            let dataString = JSONStringify(value: params).aesEncrypt!
            
            return dataString
        }
        
        return encrypt(params: params)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.row {
        case 0:
            
            let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "MyAccountID") as! MyAccountVC
            
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
            
        case 1:
            printDebug(object: "under")
        
            if Networking.isConnectedToNetwork{
             
                if CurentUser.docUpload == "4" || CurentUser.docUpload != "1"{
                    
                    guard let url : URL = URL(string: CurentUser.encryptionUrl ?? "") else { return }
                    
                    UIApplication.shared.open( url , options: [:], completionHandler: nil)
                    
                }else if CurentUser.docUpload == "5" {
                    CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("documents not submited", comment: ""), vc: self)
                }else if CurentUser.docUpload == "4" {
                    CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("pending approval", comment: ""), vc: self)
                }else{
                    CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("verification incomplete", comment: ""), vc: self)
                }
            }else{
                CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("internet connection", comment: ""), vc: self)
                
            }
            
//
        case 2:
            printDebug(object: indexPath.row)

            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "BlockedUsersID") as! BlockedUsersVC
            self.navigationController?.pushViewController(vc, animated: true)
//            
//            let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
//
//            vc.purchaseFrom = .EmogieKeyBoard
//            
//            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
        case 3:
            printDebug(object: indexPath.row)

        case 4:
            printDebug(object: indexPath.row)

            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ChangepasswordID") as! ChangepasswordVC
            self.navigationController?.pushViewController(vc, animated: true)
            
        case 5:
            printDebug(object: indexPath.row)

            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
            vc.urlToLoad = PolicyUrl.about
            vc.heading = "ABOUT US"
            
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
        case 6:
            printDebug(object: indexPath.row)
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
            vc.urlToLoad = PolicyUrl.terms
            vc.heading = "TERMS OF USE"

            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        case 7:
            printDebug(object: indexPath.row)
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
            vc.urlToLoad = PolicyUrl.faq
            vc.heading = "FAQ'S"
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
        case 8:
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AboutAndpolicyID") as! AboutAndpolicyVC
            vc.urlToLoad = PolicyUrl.privacy
            vc.heading = "PRIVACY POLICY"

            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
        case 9:
            printDebug(object: indexPath.row)
            
            self.openMailCoposer()

        case 10:
            printDebug(object: indexPath.row)
//           
//            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SharingID") as! SharingVC
//            vc.sharing = self
//            CommonFunction.addChildVC(childVC: vc,parentVC:sharedAppdelegate.tabBar)
            
            
             CommonFunction.shareWithSocialMedia(message: "https://tinyurl.com/lt428vx", vcObj: self)
            
        case 11:
            printDebug(object: indexPath.row)

            CommonFunction.rateApp()
            
        case 12:
            
            _ = VKCAlertController.alert(title: "Logout", message: "Are you sure you want to Logout?", buttons: ["No","Yes"], tapBlock: { (_, index) in
                
                if index == 1{
                   
                  // self.logOutService()
                    CommonFunction.showLoader(vc: self)

                    CommonWebService.sharedInstance.logoutService(complition: { (success) in

                        if success{
                            CommonFunction.hideLoader(vc: self)

                        }else{
                            CommonFunction.hideLoader(vc: self)
                        }
                    })
                    
                }
                
            })
            
            
         
        default:
            
            printDebug(object: "")
        
        }
    
    }
    
    
       
    func notificationToggleChanged(sender:UISwitch){
        
        if CurentUser.notificationSettings == "1"{
            self.notificationSettingsService(onStatus: "0")
        }else{
            self.notificationSettingsService(onStatus: "1")
        }
   }
    
}



extension SettingsVC : UIDocumentInteractionControllerDelegate{
    
     func shareOnInstaGram(image:UIImage){
        
        let imgData:Data = UIImageJPEGRepresentation(image,1)!
        
        let instagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(instagramURL!)) {
            
            let captionString = "caption"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            
            do {
                
                try imgData.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL)
                
                self.documentController.delegate = self
                
                self.documentController.uti = "com.instagram.exclusivegram"
                
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                
            self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                
            } catch {
                printDebug(object: "catch block")
            }
            
            
        } else {
            print(" Instagram is not installed ")
        }
    }
}

extension SettingsVC : SharingDelegate{
    
    
    func isInstagram(isInstagram:Bool){
        
        if isInstagram{
            printDebug(object: "share on instagram")
           // CommonFunction.shareOnInstaGram(image: UIImage(named:"emogie")!, vcObj: self)
            
            self.shareOnInstaGram(image: UIImage(named: "logo")!)
            
        }else{
            printDebug(object: "share on other")
             CommonFunction.shareWithSocialMedia(message: "https://tinyurl.com/lt428vx", vcObj: self)
        }
        
    }
    
}


// MARK: MFMailComposeViewControllerDelegate Method
//===================================================
extension SettingsVC : MFMailComposeViewControllerDelegate{
    func configuredMailComposeViewController(email : String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // set the mailComposeDelegate - property, NOT the --delegate-- property
      //  let email = "ambrish1.appinventiv@gmail.com"
        printDebug(object: email)
        mailComposerVC.setToRecipients([email])
        mailComposerVC.setSubject("App Feedback")
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] ?? ""
        
        let msgBody = "Hi Support Team \n  \n App version code : \(appVersion) \n OS version : ios \(UIDevice.current.systemVersion) \n product : \(UIDevice.current.modelName) \n Username : \(CurentUser.userName ?? "")"
        
        
        mailComposerVC.setMessageBody(msgBody, isHTML: false)
        return mailComposerVC
    }
    
    func showMailErrorAlert(){
//        let MailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
//        
//
//        
//        
//        MailErrorAlert.show()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismiss(animated: true, completion: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
}



extension SettingsVC : NotificationBellDelegate{
    
    func showCount(){
        
      self.setPushCount()
        
    }
}

//MARK:- Webservices
//=======================
extension SettingsVC {
    
    func notificationSettingsService(onStatus:String){
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "notificationSetting" : onStatus as AnyObject]
        printDebug(object: params)
        UserService.notifivationSettingsApi(params: params) { (success, status) in

            if success{
              
                printDebug(object: "//")
                printDebug(object: status)
                
                guard let status = status else{
                    return
                }
                
                 AppUserDefaults.save(value: status , forKey:AppUserDefaults.Key.Notification_Settings)
            }else{

            }
        }
        
    }
    
}


class SettingsCell : UITableViewCell{
 
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var arrowimageview: UIImageView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    
    override func awakeFromNib() {
            super.awakeFromNib()
    }
    
    func hideShowSwitch(row:intmax_t){
        if row == 3{
            self.notificationSwitch.isHidden = false
            self.arrowImageView.isHidden = true
        }else{
            self.notificationSwitch.isHidden = true
            self.arrowImageView.isHidden = false
        }
        
    }
    
    func setNotificationButtonStatus(status : String){
        printDebug(object: "status is \(status)")
        if status == "1"{
            self.notificationSwitch.isOn = true
        }else{
            self.notificationSwitch.isOn = false

        }
    }
    
}



extension SettingsVC{
    
    func logOutService(){
        printDebug(object: "logout called.....")
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
        
        printDebug(object: "params is \(params)")
        
        CommonFunction.showLoader(vc: self)
        UserService.logoutApi(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                AppUserDefaults.save(value: "", forKey: AppUserDefaults.Key.User_UserId)
                
                CommonFunction.setLoginToRoot()

            }else{
                AppUserDefaults.save(value: "", forKey: AppUserDefaults.Key.User_UserId)
                CommonFunction.setLoginToRoot()
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}


