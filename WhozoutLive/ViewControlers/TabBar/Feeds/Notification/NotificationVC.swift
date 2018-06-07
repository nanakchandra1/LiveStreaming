
import UIKit


class NotificationVC: UIViewController {

    //MARK:- IBOutlets
    //===================
    @IBOutlet weak var notificationTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var noDataImage: UIImageView!
    //MARK:- Variables
    //==================
    
    var notifications : [NotificationData] = []
     var refreshControl = UIRefreshControl()
    var page : Int = 0
    var index : Int = 0
    var message : String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        // Do any additional setup after loading the view.
    }
   
    override func viewWillAppear(_ animated: Bool) {
       
       // CommonFunction.hideLoader(vc: self)

    }
    

    func setUpSubView(){
        self.noDataImage.isHidden = true
        self.noDataLabel.isHidden = true
       // self.notificationTableView.isHidden = true
        self.notificationTableView.backgroundColor = UIColor.clear
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(NotificationVC.getUpdatedData), for: UIControlEvents.valueChanged)
        self.notificationTableView!.addSubview(refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor
        
    if Networking.isConnectedToNetwork{
    
        self.getNotifications(isFirst: true)
        }else{
             CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
        
        if self.message != ""{
         
         let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AccountApprovedOrRejectedPopUpID") as! AccountApprovedOrRejectedPopUpVC
            vc.message = self.message
            CommonFunction.addChildVC(childVC: vc, parentVC: self)
            
        }
        
    }

    
    func getUpdatedData(){
        self.page = 0
        self.getNotifications(isFirst:false)
    }
    
    
    
    func joinStreamPopUp(){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "JoinStreamID") as! JoinStreamVC
        vc.price = "0"
        vc.joinDelegate = self
        CommonFunction.addChildVC(childVC: vc,parentVC: self)
    }
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
      //  self.dismiss(animated: true, completion: nil)
       _ = self.navigationController?.popViewController(animated: true)
    }
}

//MARK:- join stream delegate//
//=================================
extension NotificationVC : JoinStream{
    
    //MARK:- join stream
    //======================
    func join(){
        
        CommonWebService.sharedInstance.addPopUpDelegate = self
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "VideoPlayerID") as! VideoPlayerVC
        
        CommonWebService.sharedInstance.videoVC = vc
        
        CommonWebService.sharedInstance.getUrl(feedId:    self.notifications[self.index].relationId!,vcObj: self,description: "hgj ghg j")
        
    }
    
    
    func joining(feedid: String, vcObj: UIViewController) {
        
    }
    
}



//MARk:- Tableview delegate data source
//==================================
extension NotificationVC : UITableViewDelegate ,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.notifications.count
    }
    

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "notificationCell") as! NotificationCell
        cell.notificationMessahe.text = self.notifications[indexPath.row].message
        
        cell.notificationMessahe.attributedText = cell.showMessage(type: self.notifications[indexPath.row].notificationType!, main: "\(self.notifications[indexPath.row].message!)", stringToColor: self.notifications[indexPath.row].name!)
        
        cell.showReadUnread(statis: self.notifications[indexPath.row].status!)
        let timeStampValue = Double(self.notifications[indexPath.row].timeStamp ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        cell.timeLabel.text = Date().offsetFrom(date:date as Date)
        
//        if self.notifications[indexPath.row].userImage! != URLName.demoUrl{
//            cell.profileImageView.setImageWithStringURL(URL : self.notifications[indexPath.row].userImage!,placeholder : UIImage(named : "userPlaceholder")!,imageTransition:false)
//
//        }else{
//            cell.profileImageView.image = UIImage(named : "userPlaceholder")
//        }
        
         cell.profileImageView.setImageWithStringURL(URL : self.notifications[indexPath.row].userImage!,placeholder : UIImage(named : "userPlaceholder")!,imageTransition:false)
        
        return cell
      
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if Networking.isConnectedToNetwork{
        
        if self.notifications[indexPath.row].status == "1"{
            self.readNotification(row: indexPath.row)

        }
          
        CommonWebService.sharedInstance.addPopUpDelegate = self
            self.index = indexPath.row

        self.notifiationTapped(type: self.notifications[indexPath.row].notificationType!,row: indexPath.row)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if self.notifications.count >= 9  {
            if indexPath.row == self.notifications.count - 1{
               
                self.page += 10
                
                self.getNotifications(isFirst: false)
            }
        }

    }
    
    func notifiationTapped(type:String,row:Int){
        
        if type == "1"{
            
//            if self.notifications[row].shareType == "Public"{
//                self.join()
//            }else{
//                self.joinStreamPopUp()
//
//            }
            
            
            self.join()
            
            }else if type == "2"{
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
            vc.userId = self.notifications[row].relationId
        self.navigationController?.pushViewController(vc, animated: true)
            
        }else if type == "3" || type == "4" || type == "5"{
            
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as? ImagecommentVC
            vc?.ImgId = self.notifications[row].relationId

            self.navigationController?.pushViewController(vc!, animated: true)
            
        }else if type == "7"{
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ProfileID") as! ProfileVC
            vc.profileFrom = .Notification
            self.navigationController?.pushViewController(vc, animated: true)
        }else if type == "6"{
        
        }else if type == "9"{
         
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AccountApprovedOrRejectedPopUpID") as! AccountApprovedOrRejectedPopUpVC
            vc.message = self.notifications[row].message!
            CommonFunction.addChildVC(childVC: vc, parentVC: self)
            
        }else{
            CommonFunction.showTsMessageErrorInViewControler(message:  NSLocalizedString("under development", comment: ""), vc: self)
        }
    }
}


extension NotificationVC : StreamNotAvailable{
     func tokenLess(dict: jsonDictionary) {
        
    }

    

    func tokenLess() {
        
        
    }
    
    func noStreamFound(feedId:String){
        
        printDebug(object: feedId)
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "StreamNotAvailableID") as! StreamNotAvailableVC
        CommonFunction.addChildVC(childVC: vc, parentVC: self)
    }
    
    func getFollowStatusBack(useridToFollow:String){
        
        
    }
    
}


//MARK;- Webservices
//=======================
extension NotificationVC{
    
    func readNotification(row:Int){
       // userId , notificationId
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "notificationId" : self.notifications[row].notificationId as AnyObject]
        
       
    CommonFunction.showLoader(vc: self)
        UserService.notificationStatus(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                //if self.notifications[row].status == "1"{
                    
                
                self.notifications[row].status = "0"
                    
                self.notificationTableView.reloadRows(at: [NSIndexPath(row: row, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
                //}
                
            }else{
                
                self.notifications[row].status = "0"
                
                self.notificationTableView.reloadRows(at: [NSIndexPath(row: row, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
                
                CommonFunction.hideLoader(vc: self)

            }
            CommonFunction.hideLoader(vc: self)

        }
        
    }


    func getNotifications(isFirst:Bool){
        
      //  userId , limit
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "limit" : "\(self.page)" as AnyObject]
       
        if isFirst{
        CommonFunction.showLoader(vc: self)
        }
        
        self.refreshControl.endRefreshing()

        UserService.notificationListApi(params: params) { (success, data) in
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if self.page == 0{
                    self.notifications.removeAll()
                }
                
                if let data = data{
                    printDebug(object: data)
                    
                    if data.count > 0{
                        self.noDataImage.isHidden = true
                        self.noDataLabel.isHidden = true
                        //self.notificationTableView.isHidden = false
                    }else{
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                       // self.notificationTableView.isHidden = true
                    }
                    
                    self.notifications.append(contentsOf: data)
                    self.notificationTableView.delegate = self
                    self.notificationTableView.dataSource = self
                    self.notificationTableView.reloadData()
                }
            }else{
                
                if self.page == 0{
                    self.notifications.removeAll()
                }
                
                self.noDataImage.isHidden = false
                self.noDataLabel.isHidden = false
               // self.notificationTableView.isHidden = true
                CommonFunction.hideLoader(vc: self)

            }
         
            
        }
        
    }
    
}


class NotificationCell : UITableViewCell{
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notificationMessahe: UILabel!
    @IBOutlet weak var readUnreadImageView: UIImageView!
    
    
    override func awakeFromNib() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.layer.borderColor = AppColors.seperatorGreyColor.cgColor
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.clipsToBounds = true
    }
    
    override func layoutIfNeeded() {
        
    }
    
    func showReadUnread(statis:String){
        
        if statis == "1"{
            self.readUnreadImageView.isHidden = false
        }else{
             self.readUnreadImageView.isHidden = true
        }
    }
    
    
    func showMessage(type:String,main:String,stringToColor:String) -> NSAttributedString{
        
        if type == "1"{
            
            return CommonFunction.notificationAttributedString(main_string: main, stringToColor: stringToColor, attributedColor: UIColor.black, mainStringColor: AppColors.placeHolderColor, withFont: AppFonts.lotoRegular.withSize(14))

        }else if type == "4"{
        
        return CommonFunction.notificationAttributedString(main_string: main, stringToColor: stringToColor, attributedColor: UIColor.black, mainStringColor: AppColors.placeHolderColor, withFont: AppFonts.lotoRegular.withSize(14))
        
        }else{
            
            
            return CommonFunction.notificationAttributedString(main_string: main, stringToColor: stringToColor, attributedColor: UIColor.black, mainStringColor: AppColors.placeHolderColor, withFont: AppFonts.lotoRegular.withSize(14))

            
        }
        
        
    }
    
}




