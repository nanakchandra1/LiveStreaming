

import UIKit
import WowzaGoCoderSDK
import Starscream

protocol FilterData{
    func applyFilter()
    func resetFilter()
}

protocol SyncEmogies {
    
    func sync()
}

protocol ShowDisConnectionMessage {
    
    func disconnected()
}

@objc protocol GetDataBack{
    
    @objc optional func getFollowUnFollowBack(isFollow:String,index:Int)
    @objc optional func getLikesBack(isLiked : String , totalLikes:String,totalViews : String)
    @objc optional func removeBlockedUserStream(index :Int)
    
}

protocol GetLikeBack {
    
}

class LandingVC: UIViewController {
    
    //MARK:- Variables
    //===================
    var feeds : [FeedsData] = []
    var refreshControl = UIRefreshControl()
    var tapNameAndImage : UITapGestureRecognizer!
    var index : Int!
    var page : Int = 0
    // var useridToFollow : String?
    
    var connection:NSURLConnection!
    var length:Int!
    var startTime:NSDate!
    let loaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight))
    
    //MARK:- IBOutlets
    //====================
    @IBOutlet weak var notificationButton: UIButton!
    @IBOutlet weak var searchTextField: UITextField!
 //   @IBOutlet weak var tokenLeftLabel: UILabel!
    @IBOutlet weak var logOutButton: UIButton!
    @IBOutlet weak var feedTableView: UITableView!
    @IBOutlet weak var noDataImageView: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var pushCountLabel: UILabel!
    @IBOutlet weak var tokenLeftButton: UIButton!
    @IBOutlet weak var filterAppliedView: UIView!
    //@IBOutlet weak var notificationtoggleButton: FaveButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        
       // self.testDownloadSpeed()
        self.setUpSubView()
        if Networking.isConnectedToNetwork{
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
       // printDebug(object: "value in k is \(CommonFunction.formatPoints(num: 10345))")

        printDebug(object: "network type....\(CommonFunction.getNetworkType())")
        
        CommonFunction.hideLoader(vc: self)
        
        CommonWebService.sharedInstance.videoVC = nil
        
        if let tokens = CurentUser.tokenCount{
            
            
          let tokenInPoints = "\(CommonFunction.formatPoints(num: Double(tokens)!))"
            
            self.tokenLeftButton.setTitle("\(tokenInPoints) Tokens Left", for: UIControlState.normal)
        }
        
        self.hideShowFilterView()
        self.setPushCount()
        
        if !SocketHelper.sharedInstance.socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
            
        }
        
        sharedAppdelegate.fromLogout = false
    }
    
    
    override func viewDidLayoutSubviews() {
        
        self.setPushCount()
    }
    
    override func viewDidAppear(_ animated: Bool) {

    }
    
    
    override func viewWillDisappear(_ animated: Bool) {

    }
    
    
    
    @IBAction func notificationButtontapped(_ sender: UIButton) {

        if Networking.isConnectedToNetwork{
            
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "NotificationID") as! NotificationVC
            CommonWebService.sharedInstance.pushCount = 0
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)

        }else{
             CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    
    @IBAction func filterButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FilterParentID") as! FilterParentVC
        vc.filterDelegate = self
        self.navigationController?.present(vc, animated: true, completion: nil)
    }
    
    

    @IBAction func tokenLeftButtontapped(_ sender: UIButton) {
        
        if Networking.isConnectedToNetwork{
        CommonWebService.sharedInstance.pushPurchaseToken(from: PurchaseFrom.TokenLessButton)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
}

private extension LandingVC{
    
    func setUpSubView(){
              // CommonFunction.deleteDirectory(pathName: "NewYear-5904357cda283dbc99932e90")
        self.searchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
        self.tokenLeftButton.layer.borderWidth = 1.0
        self.tokenLeftButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.tokenLeftButton.layer.cornerRadius = 3.0
        
        self.filterAppliedView.layer.cornerRadius = 3.0
        
        self.feedTableView.dataSource = self
        self.feedTableView.delegate = self
        self.searchTextField.delegate = self
        
        self.feedTableView.backgroundColor = UIColor.clear
        self.noDataLabel.isHidden = true
        self.noDataImageView.isHidden = true
        
        self.pushCountLabel.layer.cornerRadius = 3.0
        
        self.pushCountLabel.clipsToBounds = true
        
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(LandingVC.getUpdatedData), for: UIControlEvents.valueChanged)
        self.feedTableView!.addSubview(refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor
        
        CommonWebService.sharedInstance.addPopUpDelegate = self
        
        self.tapNameAndImage = UITapGestureRecognizer(target: self, action: #selector(LandingVC.tapOnNameAndImage))
    
        SocketHelper.sharedInstance.socket.delegate = self
        sharedAppdelegate.notificationDelegate = self
//      
//        self.notificationtoggleButton = FaveButton(
//            frame:CGRect(x: 10, y: 10, width: 30, height: 30),
//            faveIconNormal: UIImage(named: "femaleSelected"))
//        
       // self.notificationtoggleButton.setImage( UIImage(named: "femaleSelected"), for: UIControlState.normal)
       
    
        
        if Networking.isConnectedToNetwork{
            self.feedService(isFirst: true)
            self.updateDeviceToken()
            self.getcatagoryList()
        }else{
            self.noDataLabel.isHidden = false
            self.noDataImageView.isHidden = false
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
        if !sharedAppdelegate.agePopUpShown{
            
            self.addAgePopUp()
        }
    }
    
    
    //MARK:- Add age pop up
    //=======================
    func addAgePopUp(){
        
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "AgePopUpID") as! AgePopUpVC
        vc.syncDelegate = self
        CommonFunction.addChildVC(childVC: vc,parentVC: sharedAppdelegate.parentNavigationController)
    }
    
    
    //MARK:- Referesh control target
    //=================================
    @objc func getUpdatedData(){
        if Networking.isConnectedToNetwork{
            self.page = 0
            self.searchTextField.text = ""
            self.feedService(isFirst: false)
            
        }else{
            self.refreshControl.endRefreshing()
            self.noDataLabel.isHidden = false
            self.noDataImageView.isHidden = false
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    //MARK:- set prameters value for service
    //==========================================
    func setParametersValue() -> jsonDictionary{
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
        
        let gender : String = VKCTabBarControllar.sharedInstance.filterDict["gender"] as! String
        
        if gender == "male"{
            params["gender"] = "1" as AnyObject?
        }else if gender == "female"{
            params["gender"] = "0" as AnyObject?
        }
        
        let sort : String = VKCTabBarControllar.sharedInstance.filterDict["sortBy"] as! String
        
        if sort != ""{
            params[sort] = "1" as AnyObject?
        }
        
        let tags = VKCTabBarControllar.sharedInstance.filterTags
        
        if tags.count > 0{
            
            params["tags"] = tags.joined(separator: ",") as AnyObject?
        }
        return params
    }
    
    
    func hideShowFilterView(){
        
        if VKCTabBarControllar.sharedInstance.isFilterApplied == .Applied{
            self.filterAppliedView.isHidden = false
            
        }else{
            self.filterAppliedView.isHidden = true

        }
        
    }
    
    
    func setPushCount(){
        self.pushCountLabel.text = "\(CommonWebService.sharedInstance.pushCount)"
        if CommonWebService.sharedInstance.pushCount == 0{
            self.pushCountLabel.isHidden = true
        }else{
            self.pushCountLabel.isHidden = false
        }
    }
}

extension LandingVC : SyncEmogies{
    
    func sync() {
        
        self.getEmogiesOrNot()
    }
}

//MARK:- tableview datasource and delegate
//===========================================
extension LandingVC : UITableViewDataSource , UITableViewDelegate{
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.feeds.count
        
        // return 2
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let desc =  CommonFunction.removeBlankCharacters(text: self.feeds[indexPath.row].videoDiscription ?? "")
        
        let height = CommonFunction.getTextHeight(text: desc, font: AppFonts.lotoMedium.withSize(11), width: screenWidth - 120)
        
        return height + 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "feedTableViewCell") as! FeedTableViewCell
        
        cell.nameLabel.text = self.feeds[indexPath.row].userName ?? ""
        cell.locationLabel.text = self.feeds[indexPath.row].country ?? ""
        let timeStampValue = Double(self.feeds[indexPath.row].dateCreated ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        cell.timeLabel.text = Date().offsetFrom(date:date as Date)
        
        cell.descriptionLabel.text = self.feeds[indexPath.row].videoDiscription ?? ""
        
      //  cell.thumbNillImageView.sd_setImage(with: URL(string: self.feeds[indexPath.row].thumbnilUrl ?? ""), placeholderImage: UIImage(named : "Icon")!)
    
    
        
        cell.thumbNillImageView.setImageWithStringURL(URL : self.feeds[indexPath.row].thumbnilUrl ?? "" ,placeholder : UIImage(named : "Icon")!,imageTransition:false)
        
//        if self.feeds[indexPath.row].userImage! != URLName.demoUrl{
//            cell.profileImageView.setImageWithStringURL(URL : self.feeds[indexPath.row].userImage ?? "" ,placeholder : UIImage(named : "userPlaceholder")!,imageTransition:false)
//        }else{
//            cell.profileImageView.image = UIImage(named : "userPlaceholder")
//        }
//        

        cell.profileImageView.setImageWithStringURL(URL : self.feeds[indexPath.row].userImage ?? "" ,placeholder : UIImage(named : "userPlaceholder")!,imageTransition:false)
        
        let desc =  CommonFunction.removeBlankCharacters(text: self.feeds[indexPath.row].videoDiscription ?? "")
        
        cell.descriptionLabel.attributedText = CommonFunction.attributedHashTagString(main_string: desc, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.black,withFont: AppFonts.lotoMedium.withSize(11))
        
        cell.setFollowButtonImage(isFollow: self.feeds[indexPath.row].isfollowed ?? "")
        
        cell.nameLabel.addGestureRecognizer(self.tapNameAndImage)
        //cell.profileImageView.addGestureRecognizer(self.tapNameAndImage)
        
        cell.likesCountButton.setTitle(self.feeds[indexPath.row].likes ?? "", for: UIControlState.normal)
        
        cell.setLikeButtonImage(isLiked: self.feeds[indexPath.row].isliked ?? "0")
        
        cell.viewsCountLabel.text = self.feeds[indexPath.row].views ?? ""
        
        cell.commentCountLabel.text = self.feeds[indexPath.row].commentCount ?? ""
        
        cell.likeButton.addTarget(self, action: #selector(LandingVC.likeButtonTapped), for: UIControlEvents.touchUpInside)
        cell.transparentButton.addTarget(self, action: #selector(LandingVC.transparentButtontapped), for: UIControlEvents.touchUpInside)
        cell.followButton.addTarget(self, action: #selector(LandingVC.followButtonTapped), for: UIControlEvents.touchUpInside)
        
        cell.likesCountButton.addTarget(self, action: #selector(LandingVC.likeCountButtontapped), for: UIControlEvents.touchUpInside)
        
        cell.commentLestButton.addTarget(self, action: #selector(LandingVC.commentsButtonTapped), for: UIControlEvents.touchUpInside)
        
        cell.viewsListButton.addTarget(self, action: #selector(LandingVC.viewListButtontapped), for: UIControlEvents.touchUpInside)
        cell.moreBtn.addTarget(self, action: #selector(LandingVC.moreBtnTapped), for: UIControlEvents.touchUpInside)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if Networking.isConnectedToNetwork{
            
            self.index = indexPath.row
//           if self.feeds[indexPath.row].shareType == "Public"{
//            
//            self.join()
//            
//           }else{
//            
//                self.joinStreamPopUp()
//
//            }
            
            self.join()
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.searchTextField.text?.isEmpty)!{
            
            if self.feeds.count >= 9  {
                if indexPath.row == self.feeds.count - 1{
                    
                    self.page += 9
                    
                    self.feedService(isFirst: false)
                }
            }
        }
    }
    
    
    //MARK:- Like button tapped
    //===============================
    func likeButtonTapped(sender:UIButton){
        let indx = sender.tableViewIndexPath(tableView: self.feedTableView)
        
        guard let row = indx?.row else {
            return
        }
        
        guard let like = self.feeds[row].isliked else{
            return
        }
        
        if like == "1"{
            self.feeds[(indx?.row)!].isliked = "0"
            
            
            self.feeds[(indx?.row)!].likes! = "\(Int(self.feeds[(indx?.row)!].likes!)! - 1)"
            
            //self.likeDisLikeFeed(index: (indx?.row)!,broadcastId:self.feeds[(indx?.row)!].feedId!,like: "0")
            
            self.likeFeed(broadcastId: self.feeds[(indx?.row)!].feedId!, like: "0")
            
            
        }else{
            self.feeds[(indx?.row)!].isliked = "1"
            
            
            self.feeds[(indx?.row)!].likes! = "\(Int(self.feeds[(indx?.row)!].likes!)! + 1)"
            //self.likeDisLikeFeed(index: (indx?.row)!,broadcastId:self.feeds[(indx?.row)!].feedId!,like: "1")
              self.likeFeed(broadcastId: self.feeds[(indx?.row)!].feedId!, like: "1")
            
        }
        
        self.feedTableView.reloadRows(at:[IndexPath(row: (indx?.row)!, section: 0)], with:UITableViewRowAnimation.none)
    }
    
    //MARK:- Like count tapped
    //=================
    func likeCountButtontapped(sender:UIButton){
        let indx = sender.tableViewIndexPath(tableView: self.feedTableView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId =  self.feeds[(indx?.row)!].feedId
        vc.index = indx?.row
        vc.type = .FeedsLikeList
        vc.getDataBackDelegate = self
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        
    }
    
    func moreBtnTapped(sender:UIButton){
        let indexpath = sender.tableViewIndexPath(tableView: self.feedTableView)
        
        self.index = indexpath?.row
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let report = UIAlertAction(title: "Report", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.reportAbuseUser(sender:sender)
            
        })
        
        let block = UIAlertAction(title: "Block", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.blockUser(sender:sender)
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(report)
        optionMenu.addAction(block)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    func reportAbuseUser(sender:UIButton) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ReportAbuseID") as! ReportAbuseVC
        vc.reportDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func blockUser(sender:UIButton) {
        
        
        self.showAlert(blockType:1, title: "Block User", message: "Are you sure you wan't to block this user?")

    }
    
    func showAlert(blockType:Int,title : String,message : String ){
        
        _ = VKCAlertController.alert(title: title, message: message, buttons: ["No","Yes"], tapBlock: { (_, index) in
            
            if index == 1{
                
                printDebug(object: blockType)
                
                self.blockUser(type: "\(blockType)",reason: "")
            }else{
                
            }
            
        })
    }
    
    func viewListButtontapped(sender:UIButton){
        let indx = sender.tableViewIndexPath(tableView: self.feedTableView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId =  self.feeds[(indx?.row)!].feedId
        vc.type = .FeedsViews
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    func transparentButtontapped(sender : UIButton){
        let ind = sender.tableViewIndexPath(tableView: self.feedTableView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
        vc.userId = self.feeds[(ind?.row)!].broadcaorId
        vc.index = ind?.row
        vc.followBackDelegate = self
        
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    func tapOnNameAndImage(sender:UITapGestureRecognizer){
        
        let location = sender.location(in: self.feedTableView)
        let index = self.feedTableView.indexPathForRow(at: location)!
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
        vc.userId = self.feeds[(index.row)].broadcaorId
        vc.index = index.row
        vc.followBackDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func followButtonTapped(sender : UIButton){
        
        let index = sender.tableViewIndexPath(tableView: self.feedTableView)
        
        if self.feeds[(index?.row)!].isfollowed == "0"{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId:   self.feeds[(index?.row)!].broadcaorId!, followType: "1",name : self.feeds[(index?.row)!].userName! , vcObj: self,isFollowFromFeed: true){ (success) in
                
                if success{
                    self.feeds[(index?.row)!].isfollowed = "1"
                    self.feedTableView.reloadData()
                }else{
                    
                }
                
            }
        }else{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId: self.feeds[(index?.row)!].broadcaorId!, followType: "0",name : self.feeds[(index?.row)!].userName! ,  vcObj: self,isFollowFromFeed: true){ (success) in
                
                if success{
                    self.feeds[(index?.row)!].isfollowed = "0"
                    self.feedTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
    
    func commentsButtonTapped(sender:UIButton){
        
        let index = sender.tableViewIndexPath(tableView: self.feedTableView)
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AllCommentsID") as! AllCommentsVC
        vc.ImgId = self.feeds[(index?.row)!].feedId
        vc.from = .Feed
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        
    }
    
    func joinStreamPopUp(){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "JoinStreamID") as! JoinStreamVC
        vc.price = self.feeds[self.index].broadcastPrice
        vc.streamType = self.feeds[self.index].broadcastType ?? "1"
        vc.joinDelegate = self
        
        CommonFunction.addChildVC(childVC: vc,parentVC: self)
    }
}


//MARK:- join stream delegate//
//=================================
extension LandingVC : JoinStream{
    
    //MARK:- join stream
    //======================
    func join(){
        
        CommonWebService.sharedInstance.addPopUpDelegate = self
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "VideoPlayerID") as! VideoPlayerVC
        
        vc.likeBackDelegate = self
    
        CommonWebService.sharedInstance.videoVC = vc
        
        CommonWebService.sharedInstance.getUrl(feedId: self.feeds[self.index].feedId!,vcObj: self,description: "hgj ghg j")
        
    }
    
    func joining(feedid: String, vcObj: UIViewController) {
        
    }
    
}



extension LandingVC : StreamNotAvailable{
    
    //MARK:- Stream not avail
    //=============================
    func noStreamFound(feedId:String){
        
        for (ind,item) in self.feeds.enumerated(){
            if item.feedId == feedId{
                self.feeds.remove(at: ind)
            }
        }
        
        self.feedTableView.reloadData()
        
        printDebug(object: feedId)
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "StreamNotAvailableID") as! StreamNotAvailableVC
        
        CommonFunction.addChildVC(childVC: vc, parentVC: self)
    }
    
    
    func getFollowStatusBack(useridToFollow:String){
        
        printDebug(object: "getFollowStatusBack....")
        
        
        for item in self.feeds{
            
            if item.broadcaorId == useridToFollow{
                if item.isfollowed == "1"{
                    item.isfollowed = "0"
                }else{
                    item.isfollowed = "1"

                }
            }
            
        }
        self.feedTableView.reloadData()
    }
    
}


//mARK:- filter delegate implementation
//=======================================
extension LandingVC : FilterData{
    
    func applyFilter() {
        self.feeds.removeAll()
        VKCTabBarControllar.sharedInstance.isFilterApplied = .Applied
        self.page = 0
        self.feedService(isFirst: true)
    }
    
    func resetFilter() {
        self.feeds.removeAll()
        VKCTabBarControllar.sharedInstance.isFilterApplied = .NotApplied
        self.feedService(isFirst: true)
    }
}

extension LandingVC : GetDataBack{
    
    
    func getFollowUnFollowBack(isFollow: String, index: Int) {
        printDebug(object: "getFollowUnFollowBack called")
//        guard let _ = self.index else{
//            
//            return
//        }
        printDebug(object: "index is ")
        self.feeds[index].isfollowed = isFollow
        self.feedTableView.reloadData()
    }
    
    
    func getLikesBack(isLiked: String, totalLikes: String,totalViews : String) {
        
        guard let _ = self.index else{
            return
        }
        
        self.feeds[self.index].isliked = isLiked
        self.feeds[self.index].likes = totalLikes
        self.feeds[self.index].views = totalViews
       // self.feedTableView.reloadRows(at: [IndexPath(row: self.index, section: 0)], with: UITableViewRowAnimation.none)
        self.feedTableView.reloadData()
        CommonFunction.hideLoader(vc: self)
        
    }
    
    func removeBlockedUserStream(index: Int) {
        
        self.feeds.remove(at: index)
        
        self.feedTableView.reloadData()
    }
    
}




extension LandingVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{
                if (textField.text?.isEmpty)!{
                    self.page = 0
                    self.feedService(isFirst: true)
                }else{
                    self.searchFeedApi(txt: textField.text!)
                }
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            }
        }
        
        return true
    }
    
}


extension LandingVC : WebSocketDelegate {

    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
        
        printDebug(object: "socket is...\(socket)")
        
     //   print("error on Landing...\(String(describing: error?.localizedDescription))")
        
        if !socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
        }
        printDebug(object: "socket connected")
        
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
        
        if !sharedAppdelegate.fromLogout{
        
        if !socket.isConnected  {
            SocketHelper.sharedInstance.connectSocket()
        }
        
        }
    }

    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {

        
    }
    
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        
    }
    
    
    func likeFeed(broadcastId:String,like : String){
        
        let likeDict = ["socketType" : "likeFeed" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : broadcastId as AnyObject,"like" : like as AnyObject ] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: likeDict)
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
}


extension LandingVC : NotificationBellDelegate{


    func showCount(){
        
        
        self.setPushCount()
        
    }
    
}


//MARK:- Webservices
//====================
extension LandingVC {
    
    //MARK:- Get feed Api
    //=========================
    func feedService(isFirst:Bool){
        //   limit,userId
        
        var params = self.setParametersValue()
        
        params["limit"] = "\(self.page)" as AnyObject
        
        printDebug(object: "\\\\\\\\\\")
        printDebug(object : params)
        
        if isFirst{
            CommonFunction.showLoader(vc: self)
        }
        
        UserService.feedsApi(params: params) { (success, data, message) in
            
     
            self.refreshControl.endRefreshing()
            
            printDebug(object: data)
            
            self.noDataLabel.text = message
            
            if success{
                
                self.pushCountLabel.text = "\(CommonWebService.sharedInstance.pushCount)"
                
                CommonFunction.hideLoader(vc: self)
                if let data = data{
                    
                    if self.page == 0{
                        self.feeds.removeAll()
                    }
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.noDataImageView.isHidden = true
                    }else{
                        self.noDataLabel.isHidden = false
                        self.noDataImageView.isHidden = false
                        self.feeds.removeAll()
                    }
                    
                    self.feeds.append(contentsOf: data)
                    self.feedTableView.reloadData()
                }
            }else{
                CommonFunction.hideLoader(vc: self)
                if self.page == 0{
                    self.feeds.removeAll()
                }
                if self.feeds.isEmpty{
                    self.noDataLabel.isHidden = false
                    self.noDataImageView.isHidden = false
//                    self.view.bringSubview(toFront: self.noDataLabel)
//                    self.feedTableView.bringSubview(toFront: self.noDataLabel)
                    self.feeds.removeAll()
                    self.feedTableView.reloadData()
                }
            }
        }
    }
    
    //MARK:- Search feed api
    //==========================
    func searchFeedApi(txt : String){
        
        printDebug(object: txt)
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"search" : txt as AnyObject,"limit" : "0" as AnyObject]
        
        
        UserService.searchFeedsApi(params: params) { (success, data, meessage) in
            
            self.noDataLabel.text = meessage
            
            if success{
                
                self.feeds.removeAll()
                
                if let data = data{
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.noDataImageView.isHidden = true
                    }else{
                        self.noDataLabel.isHidden = false
                        self.noDataImageView.isHidden = false
                        self.feeds.removeAll()
                    }
                    
                    self.feeds = data
                    
                    self.feedTableView.reloadData()
                }
                
            }else{
                self.noDataLabel.isHidden = false
                self.noDataImageView.isHidden = false
                self.feeds.removeAll()
                self.feedTableView.reloadData()
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    func likeDisLikeFeed(index : Int , broadcastId:String,like:String){
        
        CommonWebService.sharedInstance.likeDislikeFeed(vcObj: self, broadcastId: broadcastId, like: like) { (success, totalKikes) in
            if success{
                
                printDebug(object: "my count---...>>>>\(String(describing: totalKikes))")
                
                guard let total = totalKikes else{
                    return
                }
                
                self.feeds[index].likes = total
                
                self.feedTableView.reloadRows(at:[IndexPath(row:index, section: 0)], with:UITableViewRowAnimation.none)
            
            }else{
                
            }
        }
    }
    
    //MARK:- Get emogies or not
    //========================
    func getEmogiesOrNot(){
        
        let params : jsonDictionary = [:]
        CommonFunction.showLoader(vc: self)

        UserService.getEmogiesOrNotApi(params: params) { (success, version, arrayStr) in
            CommonFunction.hideLoader(vc: self)

            if success{

                printDebug(object: "curent version........\(String(describing: version))")
                
                guard let ver = version else{
                    return
                }
                
                guard let arr = arrayStr else{
                    
                    return
                }
                
                CommonWebService.sharedInstance.emogiesSequenceArray = arr.components(separatedBy: ",")
                
                printDebug(object: "///////////")
                printDebug(object: ver)
                printDebug(object: CurentUser.emogieVersion)
                
                
               // sharedAppdelegate.persistentContainer.performBackgroundTask({ (context) in
                    
                    if let savedVersion = CurentUser.emogieVersion{
                        printDebug(object: "saved version \(savedVersion)")
                        
                        
                        if savedVersion != ""{

                            if savedVersion != "\(ver)"{
                        
                                
                                sharedAppdelegate.syncingPopUpShown = true
                                
            
                _ = VKCAlertController.alertOnVC(title: "Syncing", message: "New emogies are available are you sure you wan't to sync new emogies.", vcObj: self, buttons: ["No","Yes"], tapBlock: { (road, index) in
                    
                    
                    
            if index == 1{
                DispatchQueue.global(qos: .background).async {

                        if DataBaseControler.deleteAllData(modelName: "WLEmogies"){
                                            
                              self.getEmogies(ver: "\(ver)")
                                            
                            }
                    }
                        }})
                                
                    }
                            
                }else{
                DispatchQueue.global(qos: .background).async {
    
                    if DataBaseControler.deleteAllData(modelName: "WLEmogies"){
                                
                        self.getEmogies(ver: "\(ver)")
                        
                    }
                }
                }
            }
                    
              //  })
                
                CommonFunction.hideLoader(vc: self)
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    func getcatagoryList(){
        
        let params : jsonDictionary = [:]
        CommonFunction.showLoader(vc: self)
        
        UserService.getEmogiesOrNotApi(params: params) { (success, version, arrayStr) in
            CommonFunction.hideLoader(vc: self)
            
            if success{
                
                
                guard let arr = arrayStr else{
                    
                    return
                }
                
                printDebug(object: "arr is ......\(arr)")
                
                CommonWebService.sharedInstance.emogiesSequenceArray = arr.components(separatedBy: ",")
                
                CommonFunction.hideLoader(vc: self)
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }

    
    //MARK:- Get emogies
    //=======================
    func getEmogies(ver:String){
        
        let params : jsonDictionary = ["":"" as AnyObject]
        
        DispatchQueue.main.async {
            CommonFunction.showLoader(vc: self)
            
        }
        
    
        UserService.getEmogiesApi(params: params) { (success, data, deletedEmogies) in
            
        
            if success{
                DispatchQueue.main.async {
                    CommonFunction.hideLoader(vc: self)
                }
                if let data = data{
                    if let deleteEmogie = deletedEmogies{
                        
                      
                  //  self.addLoaderVC()
                        
                        
                    
                    for item in deleteEmogie{
                        
                        CommonFunction.deleteDirectory(pathName: "\(item.category ?? "")-\(item.emogiId ?? "")")
                    }
                    
                    DataBaseControler.insertEmogies(emogieArray: data,version:ver,vcObj: self)

                    
                    }
                        
                
                  
                    
                  //  self.loaderVC.removeFromParentViewController()
                    
                }else{
                    
                }
                
            }else{
                DispatchQueue.main.async {
                    CommonFunction.hideLoader(vc: self)
                    
                }
            }
            DispatchQueue.main.async {
                CommonFunction.hideLoader(vc: self)
            }
        }
        
    }
    
    

    
    func updateDeviceToken(){
        var token =  AppUserDefaults.value(forKey: AppUserDefaults.Key.DevideToken)

        printDebug(object: "token is......\(token)")
        
        if token == ""{
         token = "1234567900554e86f0e8c81154a30a8029ae514dbfb42ca4d4d6ff24026a3f8e"
        }
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"deviceToken":token as AnyObject]
        printDebug(object: params)
        UserService.updateDeviceTokenApi(params: params) { (success) in
          
            if success{
                printDebug(object: "success")
            }else{
                printDebug(object: "not success")
            }
        }
        
    }
    
    
}


//extension LandingVC : NSURLConnectionDataDelegate{
//    
//    func testDownloadSpeed() {
//        let url: NSURL = NSURL(string: "http://thewallpaperhost.com/wp-content/uploads/2014/12/wallpapers-hd-8000-8331-hd-wallpapers.jpg")!
//        let request: NSURLRequest = NSURLRequest(url: url as URL)
//        self.startTime = NSDate()
//        self.length = 0
//        self.connection = NSURLConnection(request: request as URLRequest, delegate: self)
//        self.connection.start()
//        let :Int64 =  1000000000  * 2
//        //var popTime:dispatch_time_t = DispatchTime.now(dispatch_time_t(DISPATCH_TIME_NOW), (Int64)(delayInSeconds ))
//     
//        DispatchQueue.main.async {
//            if (self.connection) != nil {
//                self.connection.cancel()
//                self.connection = nil
//                self.useOffline()
//            }
//        }
//        
//    }
//    
//    func determineMegabytesPerSecond() -> CGFloat {
//        var elapsed: TimeInterval
//        if (startTime != nil) {
//            elapsed = NSDate().timeIntervalSince(startTime as Date)
//            let d =  (Double(length) / elapsed)
//            var result = CGFloat( d/1024)
//            result = result * 0.0078125
//            result = result * 0.0009765625
//            printDebug(object: "result is...\(result)")
//            return result
//            
//        }
//        return -1
//    }
//    
//    func useOnline() {
//        NSLog("Successful")
//        NSLog("\(determineMegabytesPerSecond())")
//        
//    }
//    
//    func useOffline() {
//        
//        NSLog("UnSuccessful.........")
//        NSLog("\(determineMegabytesPerSecond())")
//    }
//    
//    func connection(_ connection: NSURLConnection, didReceive response: URLResponse) {
//        NSLog("data came")
//        self.startTime = NSDate()
//    }
//    
//    
//    func connection(_ connection: NSURLConnection, didFailWithError error: Error) {
//        if (self.connection) != nil {
//            self.connection = nil
//            useOffline()
//        }
//    }
//    
//    
//    func connectionDidFinishLoading(_ connection: NSURLConnection) {
//        self.connection = nil
//        
//        useOnline()
//    }
//    
//    private func connection(connection: NSURLConnection, didReceiveData data: NSData) {
//        self.length  = self.length +  data.length
//        NSLog("\(data.length)")
//    }
//
//}
//

class FeedTableViewCell : UITableViewCell{
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var thumbNillImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var commentCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var transparentButton: UIButton!
    @IBOutlet weak var viewsBackView: UIView!
    @IBOutlet weak var commentsBackView: UIView!
    @IBOutlet weak var likesBackView: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likesCountButton: UIButton!
    @IBOutlet weak var commentLestButton: UIButton!
    @IBOutlet weak var viewsListButton: UIButton!
    
    @IBOutlet weak var moreBtn: UIButton!
    
    override func awakeFromNib() {
        
    }
    
    override func layoutIfNeeded() {
        self.profileImageView.layer.cornerRadius =
            self.profileImageView.frame.size.height / 2
        self.profileImageView.clipsToBounds = true
        self.thumbNillImageView.layer.borderColor = AppColors.seperatorGreyColor.cgColor
        self.thumbNillImageView.layer.borderWidth = 1.0
        self.thumbNillImageView.clipsToBounds = true
        self.dotView.layer.cornerRadius = self.dotView.frame.size.height / 2
        self.dotView.clipsToBounds = true
        self.nameLabel.isUserInteractionEnabled = true
        self.profileImageView.isUserInteractionEnabled = true
    }
    
    
    func setFollowButtonImage(isFollow:String){
        
        if isFollow == "1"{
            self.followButton.setImage(UIImage(named : "followIcon"), for: UIControlState.normal)
        }else{
            self.followButton.setImage(UIImage(named : "unfollowIcon"), for: UIControlState.normal)
            
        }
    }
    
    func setLikeButtonImage(isLiked:String){
        if isLiked == "1"{
            self.likeButton.setImage(UIImage(named : "liked"), for: UIControlState.normal)
            
        }else{
            self.likeButton.setImage(UIImage(named : "like"), for: UIControlState.normal)
            
        }
    }
    
    
    override func prepareForReuse() {
        
    }
}
extension LandingVC : ReportAbuse{
    
    func report(reason:String){
        self.blockUser(type: "2",reason: reason)
        
    }
  
    func blockUser(type : String,reason:String){
        let obj = self.feeds[self.index] 
        
        var params : jsonDictionary = ["userId" : CurentUser.userId  as AnyObject , "blockUsersId" : obj.broadcaorId as AnyObject , "blockType" : type as AnyObject , "reason" : "Blocked" as AnyObject]
        
        if type == "2"{
            
            params["reason"] = reason as AnyObject?
        }
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.blockApi(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                        _ = self.navigationController?.popViewController(animated: true)
                if let _ = self.index{
                    //self.followBackDelegate.removeBlockedUserStream!(index: self.index)
                    
                    if type == "1" {
                        self.feeds.remove(at: self.index)
                        self.feedTableView.reloadData()
                    }
                    
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}
