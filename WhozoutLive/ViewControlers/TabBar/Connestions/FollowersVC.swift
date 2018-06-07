

import UIKit

class FollowersVC: UIViewController {

    //MARK:- Variables
    //===================
    var followers : [FollowersFollowingData] = []
    var refreshControl = UIRefreshControl()
    var selectedFollowers : StringArray = []
  //  var followersCountDelegate : FollowersFollowingCount!
    var page : Int = 0
    //var tapNameAndImage : UITapGestureRecognizer!
   var getFriendsDelegate : GetFriendsBack!
    
    //MARK:- IBOutlets
    //=====================
    @IBOutlet weak var followersTableView: UITableView!
    @IBOutlet weak var noDataImageView: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var followersSearchTextField: UITextField!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet weak var allTickImageView: UIImageView!
    
    @IBOutlet weak var selectAllView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }


    override func viewWillAppear(_ animated: Bool) {
      
        
    }
    
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
         if self.selectedFollowers.isEmpty || CommonWebService.sharedInstance.selectedPrivateFriend == ""{
        self.getFriendsDelegate.closeButtonTapped()
        }
          self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func tickButtonTapped(_ sender: UIButton) {
        
        if self.selectedFollowers.count > 0 || CommonWebService.sharedInstance.selectedPrivateFriend != ""{
            self.getFriendsDelegate.getFriendsBack(followers: self.selectedFollowers)
            ConnectionsFrom.connectFrom = .TabBar
            self.dismiss(animated: true, completion: nil)
        }else{
            CommonFunction.showTsMessageErrorInViewControler(message: "Please select a friend.", vc: self)
        }
    }
    
    
    
    @IBAction func selectAllButtonTapped(_ sender: UIButton) {

        
        self.selectAllTapped(isRunAll: true)
        
    }
}


private extension FollowersVC{
    
    func setUpSubView(){
        
        let cellNib = UINib(nibName: "FollowingFollowersCell", bundle: nil)
        self.followersTableView.register(cellNib, forCellReuseIdentifier: "followingFollowersCell")
        self.noDataImageView.isHidden = true
        self.noDataLabel.isHidden = true
        
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(FollowersVC.getFollowers), for: UIControlEvents.valueChanged)
        self.followersTableView!.addSubview(self.refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor
        self.followersSearchTextField.delegate = self
        
        self.followersSearchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
            self.setHeader()
        
        self.selectAllView.isHidden = true
        
        if self.selectedFollowers.contains("all"){
            self.allTickImageView.image = #imageLiteral(resourceName: "checked")

        }else{
            self.allTickImageView.image = #imageLiteral(resourceName: "unckecked")

        }
        
        if Networking.isConnectedToNetwork{
            self.followersService(isFirst: true)
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    func setHeader(){
        
        if ConnectionsFrom.connectFrom == .SharingInformation{

            self.topViewHeight.constant = 64
            
            if ShareWith.shareWith == .Friends{
                self.selectAllView.frame.size.height = 50
                self.selectAllView.isHidden = false

            }else{
                
            }
        }else{
            self.topViewHeight.constant = 0
            self.selectAllView.frame.size.height = 0
            self.selectAllView.isHidden = true
        }
    }
    
    @objc func getFollowers(){
        if Networking.isConnectedToNetwork{
           // self.followers.removeAll()
            self.page = 0
            self.followersSearchTextField.text = ""
            self.followersService(isFirst: false)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    
    func selectAllTapped(isRunAll:Bool){
    
        if self.selectedFollowers.contains("all"){
            self.selectedFollowers.removeAll()
            self.allTickImageView.image = #imageLiteral(resourceName: "unckecked")
            self.followersTableView.reloadData()
        }else{
            
            if isRunAll{
            _ = self.followers.map { (obj) in
                if !self.selectedFollowers.contains(obj.followingId!){
                    self.selectedFollowers.append(obj.followingId!)
                }
                
               }
            }
            self.followersTableView.reloadData()
           self.selectedFollowers.append("all")
            self.allTickImageView.image = #imageLiteral(resourceName: "checked")
        }

    
    }
    
}

extension FollowersVC : UITableViewDelegate , UITableViewDataSource{
 
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.followers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        printDebug(object: "followers cell for row")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingFollowersCell") as! FollowingFollowersCell
        
        cell.followerNamelabel.text = self.followers[indexPath.row].userName
    
         cell.profileImageView.setImageWithStringURL(URL: self.followers[indexPath.row].userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        
       cell.setButtonHiddenStatus(live:self.followers[indexPath.row].live!,from: ConnectionsFrom.connectFrom)
        
        
        cell.followUnfollowBitton.addTarget(self, action: #selector(FollowersVC.followButtonTapped), for: UIControlEvents.touchUpInside)
        cell.setFollowButtonImage(isFollow: self.followers[indexPath.row].isfollowed!)
        
        
    if ShareWith.shareWith == .Friends{
            if self.selectedFollowers.contains(self.followers[indexPath.row].followingId!){
            cell.tickImageView.image = UIImage(named: "checked")
        }else{
             cell.tickImageView.image = UIImage(named: "unckecked")
        }
    }else  if ShareWith.shareWith == .Private{
            if CommonWebService.sharedInstance.selectedPrivateFriend == self.followers[indexPath.row].followingId{
                 cell.tickImageView.image = UIImage(named: "checked")
            }else{
                 cell.tickImageView.image = UIImage(named: "unckecked")
            }
        }
        return cell
    }
    
  
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    if ConnectionsFrom.connectFrom == .SharingInformation{
            
        if ShareWith.shareWith == .Friends{
        if self.selectedFollowers.contains(self.followers[indexPath.row].followingId!){
        let ind = self.selectedFollowers.index(of: self.followers[indexPath.row].followingId!)
            self.selectedFollowers.remove(at: ind!)
        }else{
            self.selectedFollowers.append(self.followers[indexPath.row].followingId!)
        }
        
 
            if self.selectedFollowers.contains("all"){
                
                 self.allTickImageView.image = #imageLiteral(resourceName: "unckecked")
               
                 self.selectedFollowers.remove(at: self.selectedFollowers.index(of: "all")!)

            }else{
                if self.selectedFollowers.count == self.followers.count{
                    self.selectedFollowers.append("all")
                   self.allTickImageView.image = #imageLiteral(resourceName: "checked")
                }
            }

            self.followersTableView.reloadData()
        }else if ShareWith.shareWith == .Private{
            if CommonWebService.sharedInstance.selectedPrivateFriend == self.followers[indexPath.row].followingId{
                CommonWebService.sharedInstance.selectedPrivateFriend = ""
            }else{
                CommonWebService.sharedInstance.selectedPrivateFriend = self.followers[indexPath.row].followingId!
            }
            self.followersTableView.reloadData()
        }
            
    }else{
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
        vc.userId = self.followers[(indexPath.row)].followingId
        vc.followBackDelegate = self
        vc.index = indexPath.row
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.followersSearchTextField.text?.isEmpty)!{
            
            if self.followers.count >= 9  {
                if indexPath.row == self.followers.count - 1{
                    
                    self.page += 9
                    
                    self.followersService(isFirst: false)
            }
        }
            
        }
    }
    
    func followButtonTapped(sender : UIButton){
        
        let index = sender.tableViewIndexPath(tableView: self.followersTableView)
        
        if self.followers[(index?.row)!].isfollowed == "0"{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId:   self.followers[(index?.row)!].followingId!,followType: "1", name : self.followers[(index?.row)!].userName! , vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.followers[(index?.row)!].isfollowed = "1"
                    self.followersTableView.reloadData()
                }else{
                    
                }
                
            }
        }else{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId: self.followers[(index?.row)!].followingId!, followType: "0",name : self.followers[(index?.row)!].userName! ,  vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.followers[(index?.row)!].isfollowed = "0"
                    self.followersTableView.reloadData()
                }else{
                    
                }
            }
        }
    }
}



extension FollowersVC : GetDataBack{
    
    func getFollowUnFollowBack(isFollow: String, index: Int) {
        self.followers[index].isfollowed = isFollow
        self.followersTableView.reloadData()
    }
    
    func removeBlockedUserStream(index: Int) {
        
        printDebug(object: "removeBlockedUserStream called")
        
        self.followers.remove(at: index)
        
        if self.followers.isEmpty{
            self.noDataLabel.isHidden = false
            self.noDataImageView.isHidden = false
            self.noDataLabel.text = "No Followers"
            self.followers.removeAll()
        }
        CommonWebService.sharedInstance.followersCount =  CommonWebService.sharedInstance.followersCount - 1
        self.parent?.viewWillAppear(true)
        self.followersTableView.reloadData()

    }
    
}



//MARK:- Text firld delegate
//=================================
extension FollowersVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{
                if (textField.text?.isEmpty)!{
                    self.followersService(isFirst: true)
                }else{
                    self.searchFollowers(txt: textField.text!)
                }
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            }
        }
    
        return true
    }
}

//MARK:- Webservices
//=======================
extension FollowersVC{
    
    
    
    func setSelectAllHeight(){
    
        
        if ConnectionsFrom.connectFrom == .SharingInformation{
            
            if !self.followers.isEmpty {
                
                self.selectAllView.frame.size.height = 50
                self.selectAllView.isHidden = false
                
            }else{
                
                self.selectAllView.frame.size.height = 0
                self.selectAllView.isHidden = true
                
            }
            
        }
        

    
    }
    
    
    //MARK:- followers service
    //==========================
    func followersService(isFirst:Bool){
        
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
        
        params["limit"] = "\(self.page)" as AnyObject
        
        self.refreshControl.endRefreshing()
        
        if isFirst{
            CommonFunction.showLoader(vc: self)
        }
        
        UserService.followersApi(params: params) { (success, data, message) in
            
            
            printDebug(object: data)
            
            self.noDataLabel.text = message
            
            if success{
                
                self.parent?.viewWillAppear(true)
                
                CommonFunction.hideLoader(vc: self)
                printDebug(object: data)
                
                self.followersSearchTextField.text = ""
                
                if self.page == 0{
                    self.followers.removeAll()
                }
                
                if let data = data{
                  
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.noDataImageView.isHidden = true
                        self.followers.append(contentsOf: data)
                        self.followers.sort {
                            return $0.userName!.caseInsensitiveCompare($1.userName!) == .orderedAscending
                        }
                        
                        self.setSelectAllHeight()
                        
                        if self.selectedFollowers.contains("all"){
                        
                           _ = self.followers.map({ (obj) in
                            
                                if !self.selectedFollowers.contains(obj.followingId!){
                                
                                    self.selectedFollowers.append(obj.followingId!)
                                    
                                }
                                
                            })
                        
                        }
                        
                        
                    }else{
                        self.noDataLabel.isHidden = false
                        self.noDataImageView.isHidden = false
                        self.followers.removeAll()
                    }
                  
                    self.self.followersTableView.delegate = self
                    self.self.followersTableView.dataSource = self
                    self.followersTableView.reloadData()
                }
            }else{
                
                CommonFunction.hideLoader(vc: self)

                self.setSelectAllHeight()
                
                if self.followers.isEmpty{
                self.noDataLabel.isHidden = false
                self.noDataImageView.isHidden = false
                self.followers.removeAll()
                self.followersTableView.reloadData()

             }
           }
        }
    }
    
    //MARK:- Search followers service
    //==================================
    func searchFollowers(txt : String){
        
           let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"search" : txt as AnyObject,"limit" : "0" as AnyObject]
        
        UserService.searchFollowersApi(params: params) { (success, data,nessage) in
            self.noDataLabel.text = nessage

            if success{
                
                printDebug(object: data)
                if let data = data{
                    
                    if data.count > 0{
                        self.followers.removeAll()
                        self.noDataLabel.isHidden = true
                        self.noDataImageView.isHidden = true
                        self.setSelectAllHeight()

                    }else{
                        self.noDataLabel.isHidden = false
                        self.noDataImageView.isHidden = false
                        self.followers.removeAll()
                        self.setSelectAllHeight()

                    }
                    
                    self.followers.append(contentsOf: data)
                    
                    self.followers.sort {
                        return $0.userName!.caseInsensitiveCompare($1.userName!) == .orderedAscending
                    }
                    
                    self.self.followersTableView.delegate = self
                    self.self.followersTableView.dataSource = self
                    self.followersTableView.reloadData()
                }
            }else{
                self.noDataLabel.isHidden = false
                self.noDataImageView.isHidden = false
                self.followers.removeAll()
                self.followersTableView.reloadData()

            }
            
        }
        
    }
    
}


