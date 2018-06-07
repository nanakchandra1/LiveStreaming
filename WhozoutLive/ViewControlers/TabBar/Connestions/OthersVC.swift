

import UIKit

class OthersVC: UIViewController {

    var refreshControl = UIRefreshControl()
    var others : [FollowersFollowingData] = []
    var page : Int = 0
    var getFriendsDelegate : GetFriendsBack!
    var selectedFollowers : StringArray = []

    
    //MARK:- IBOutlets
    //===================
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var otherTableview: UITableView!
    @IBOutlet weak var noDataImageView: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var topViewHeight: NSLayoutConstraint!
    
    
    
    //MARK:- View life cycle
    //============================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
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
    
}

private extension OthersVC{
    
//MARK:- set up your view
//==================
    func setUpSubView(){
        
        let cellNib = UINib(nibName: "FollowingFollowersCell", bundle: nil)
        self.otherTableview.register(cellNib, forCellReuseIdentifier: "followingFollowersCell")
         self.setHeader()
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(OthersVC.getOthers), for: UIControlEvents.valueChanged)
        
        self.otherTableview!.addSubview(self.refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor
        self.searchTextField.delegate = self
        
        self.searchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
        if Networking.isConnectedToNetwork{
            self.otherUsersService(text: "",isFirst:true)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    
    @objc func getOthers(){
        if Networking.isConnectedToNetwork{
            self.searchTextField.text = ""
            self.page = 0
            self.otherTableview.delegate = nil
            self.otherTableview.dataSource = nil
            self.otherUsersService(text: "",isFirst:false)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    func setHeader(){
        
        if ConnectionsFrom.connectFrom == .SharingInformation{
            
            self.topViewHeight.constant = 64
            
        }else{
            self.topViewHeight.constant = 0
            
        }
        
    }

    
}


//MARK:- Tableview delegate and data source
//============================================
extension OthersVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        printDebug(object: "cout is \(self.others.count)")
        
        return self.others.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        printDebug(object: "others row is \(indexPath.row)")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingFollowersCell") as! FollowingFollowersCell
        
        cell.followUnfollowBitton.isHidden = true
        cell.liveStreamButton.isHidden = true
        
        if ConnectionsFrom.connectFrom == .SharingInformation{
        cell.tickImageView.isHidden = false
        }else{
            
            cell.tickImageView.isHidden = true

        }
        
        
       // cell.tickImageView.isHidden = true
        
        printDebug(object: "row is \(indexPath.row)")
        
        printDebug(object: "username.......\(String(describing: self.others[indexPath.row].userName))")
        
        cell.followerNamelabel.text = self.others[indexPath.row].userName
        cell.profileImageView.setImageWithStringURL(URL: self.others[indexPath.row].userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        
      
        
        
        if ShareWith.shareWith == .Group{
            if self.selectedFollowers.contains(self.others[indexPath.row].userId!){
                cell.tickImageView.image = UIImage(named: "checked")
            }else{
                cell.tickImageView.image = UIImage(named: "unckecked")
            }
        }else  if ShareWith.shareWith == .Private{
            if CommonWebService.sharedInstance.selectedPrivateFriend == self.others[indexPath.row].userId{
                cell.tickImageView.image = UIImage(named: "checked")
            }else{
                cell.tickImageView.image = UIImage(named: "unckecked")
            }
        }
        
        
        return cell
}

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if ConnectionsFrom.connectFrom == .SharingInformation{
            
            if ShareWith.shareWith == .Group{
                if self.selectedFollowers.contains(self.others[indexPath.row].userId!){
                    let ind = self.selectedFollowers.index(of: self.others[indexPath.row].userId!)
                    
                    self.selectedFollowers.remove(at: ind!)
                }else{
                    self.selectedFollowers.append(self.others[indexPath.row].userId!)
                }
                
                self.otherTableview.reloadRows(at: [NSIndexPath(row: indexPath.row, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
            }else if ShareWith.shareWith == .Private{
                if CommonWebService.sharedInstance.selectedPrivateFriend == self.others[indexPath.row].userId{
                    CommonWebService.sharedInstance.selectedPrivateFriend = ""
                }else{
                    CommonWebService.sharedInstance.selectedPrivateFriend = self.others[indexPath.row].userId!
                }
                self.otherTableview.reloadData()
            }
            
        }else{
        
        if ConnectionsFrom.connectFrom != .SharingInformation{
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
        vc.userId = self.others[(indexPath.row)].userId
            vc.followBackDelegate = self
            vc.index = indexPath.row
            sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            
            }
        }
}
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.searchTextField.text?.isEmpty)!{
            
            if self.others.count >= 10  {
                if indexPath.row == self.others.count - 1{
                    
                    self.page += 10
                    
                    self.otherUsersService(text: "",isFirst: false)
                    
                   // self.feedService()
                }
            }
        }
    }
    
}


//MARK:- Text firld delegate
//=================================
extension OthersVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{
                if (textField.text?.isEmpty)!{
                    self.page = 0
                    self.otherUsersService(text:"",isFirst:true)
                }else{
                    self.page = 0
                    self.otherUsersService(text:textField.text!,isFirst:false)
                }
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
                
            }
        }
        
        return true
    }
    
}



extension OthersVC : GetDataBack{
    
    func getFollowUnFollowBack(isFollow: String, index: Int) {

    }
    
    func removeBlockedUserStream(index: Int) {
        self.others.remove(at: index)
        self.otherTableview.reloadData()
    }
}


extension OthersVC{
    
    
    //MARK:- followers service
    //==========================
    func otherUsersService(text:String,isFirst:Bool){
        
            printDebug(object: "other user service called")
        
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
         params["limit"] = "\(self.page)" as AnyObject
        self.refreshControl.endRefreshing()

        if text != ""{
         
            params["search"] = text as AnyObject?
      
        }
        
        if self.page == 0{
            
            self.others.removeAll()
        }
        
        printDebug(object: "params....\(params)")
        
       // self.refreshControl.endRefreshing()
        
       if isFirst{
        CommonFunction.showLoader(vc: self)
        }
        
    UserService.otherUsersApi(params: params) { (success, data) in
        
            printDebug(object: data)
        printDebug(object: "other user service called 2")

        CommonFunction.hideLoader(vc: self)

            if success{
                CommonFunction.hideLoader(vc: self)
                
           //     self.parent?.viewWillAppear(true)
                
                
                if self.page == 0{
                    self.others.removeAll()
                }
                
                if let data = data{
                    
                    if data.count > 0{
                     
                        self.noDataImageView.isHidden = true
                        self.otherTableview.isHidden = false

                    }else{
                        self.noDataImageView.isHidden = false
                        self.otherTableview.isHidden = true
                        self.others.removeAll()

                  }
                    self.others.append(contentsOf: data)
                    
                   
                    self.others.sort {
                        return $0.userName!.caseInsensitiveCompare($1.userName!) == .orderedAscending
                    }
                    
                    self.otherTableview.delegate = self
                    self.otherTableview.dataSource = self
                    self.otherTableview.reloadData()
                }
            }else{
                CommonFunction.hideLoader(vc: self)

                if self.others.isEmpty{
                self.noDataImageView.isHidden = false
                   // self.otherTableview.isHidden = true
                self.others.removeAll()
                self.otherTableview.reloadData()
            }
          }
        }
    }
}


