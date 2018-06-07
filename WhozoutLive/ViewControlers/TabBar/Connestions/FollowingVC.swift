//
//  FollowingVC.swift


import UIKit

class FollowingVC: UIViewController {

    var following : [FollowersFollowingData] = []
    var refreshControl = UIRefreshControl()
    var selectedFollowing : StringArray = []
    //var followingCountDelegate : FollowersFollowingCount!
    var page : Int = 0
   // var tapNameAndImage : UITapGestureRecognizer!
    var removed : Bool? = false
    
    @IBOutlet weak var followingTableView: UITableView!
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var nodataImageView: UIImageView!
    @IBOutlet weak var followingSearchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        
    }
}


private extension FollowingVC{
    
    func setUpSubView(){
        
        let cellNib = UINib(nibName: "FollowingFollowersCell", bundle: nil)
        self.followingTableView.register(cellNib, forCellReuseIdentifier: "followingFollowersCell")
       self.nodataImageView.isHidden = true
        self.noDataLabel.isHidden = true
        
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(FollowingVC.getFollowing), for: UIControlEvents.valueChanged)
        self.followingTableView!.addSubview(self.refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor

        self.followingSearchTextField.delegate = self
        self.followingSearchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
        
        if Networking.isConnectedToNetwork{
            self.followingService(isFirst: true)
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    
    @objc func getFollowing(){
        if Networking.isConnectedToNetwork{
          //  self.following.removeAll()
            self.followingSearchTextField.text = ""
            self.page = 0
            self.followingService(isFirst: false)
            
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
}


extension FollowingVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.following.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingFollowersCell") as! FollowingFollowersCell
       
        printDebug(object: "following cell for row\(indexPath.row)")

        cell.followerNamelabel.text = self.following[indexPath.row].userName
    
        cell.profileImageView.setImageWithStringURL(URL: self.following[indexPath.row].userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        
          cell.followUnfollowBitton.addTarget(self, action: #selector(FollowingVC.followButtonTapped), for: UIControlEvents.touchUpInside)
        
          cell.setButtonHiddenStatus(live:self.following[indexPath.row].live!,from: ConnectionsFrom.connectFrom)
        
            cell.liveStreamButton.isHidden = true
        
        
        
//         if ShareWith.shareWith == .Group{
//        if self.selectedFollowing.contains(self.following[indexPath.row].followingId!){
//            cell.tickImageView.image = UIImage(named: "checked")
//        }else{
//            cell.tickImageView.image = UIImage(named: "unckecked")
//        }
//         }else  if ShareWith.shareWith == .Private{
//            if CommonWebService.sharedInstance.selectedPrivateFriend == self.following[indexPath.row].followingId{
//                cell.tickImageView.image = UIImage(named: "checked")
//            }else{
//                cell.tickImageView.image = UIImage(named: "unckecked")
//            }
//        }
        
        return cell
}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
//    if ConnectionsFrom.connectFrom == .SharingInformation{
//
//        if ShareWith.shareWith == .Group{
//
//        if self.selectedFollowing.contains(self.following[indexPath.row].followingId!){
//            let ind = self.selectedFollowing.index(of: self.following[indexPath.row].followingId!)
//            
//            self.selectedFollowing.remove(at: ind!)
//        }else{
//            self.selectedFollowing.append(self.following[indexPath.row].followingId!)
//        }
//        
//        self.followingTableView
//            
//            .reloadRows(at: [NSIndexPath(row: indexPath.row, section: 0) as IndexPath], with: UITableViewRowAnimation.none)
//        }else if ShareWith.shareWith == .Private{
//            if CommonWebService.sharedInstance.selectedPrivateFriend == self.following[indexPath.row].followingId{
//                CommonWebService.sharedInstance.selectedPrivateFriend = ""
//            }else{
//                CommonWebService.sharedInstance.selectedPrivateFriend = self.following[indexPath.row].followingId!            }
//            self.followingTableView.reloadData()
//        }
//        }else{
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as! OtherProfileVC
            vc.userId = self.following[(indexPath.row)].followingId
            vc.followBackDelegate = self
            vc.index = indexPath.row
            self.removed = false
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
       // }
}

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if (self.followingSearchTextField.text?.isEmpty)!{
            
            if self.following.count >= 9  {
                if indexPath.row == self.following.count - 1{
                    
                    self.page += 9
                    
                    self.followingService(isFirst: false)                }
            }
        }
    }
    
    
    func followButtonTapped(sender : UIButton){
        
        let index = sender.tableViewIndexPath(tableView: self.followingTableView)
        
        CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId: self.following[(index?.row)!].followingId!, followType: "0",name : self.following[(index?.row)!].userName! ,  vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.following[(index?.row)!].isfollowed = "0"
                    self.following.remove(at: (index?.row)!)
                    
                    if self.following.count > 0{
                        self.noDataLabel.isHidden = true
                        self.nodataImageView.isHidden = true
                    }else{
                        self.noDataLabel.isHidden = false
                        self.nodataImageView.isHidden = false
                        self.following.removeAll()
                    }
                    self.followingTableView.reloadData()
                    
                    CommonWebService.sharedInstance.followingCount =    CommonWebService.sharedInstance.followingCount - 1
                    self.parent?.viewWillAppear(true)
                    
                }else{
        
                }
        }
    }
}



extension FollowingVC : GetDataBack{
    
    func getFollowUnFollowBack(isFollow: String, index: Int) {
        printDebug(object: "index is \(index)")
      
        if self.removed!{
            return
        }
        self.removed = true
        self.following.remove(at: index)

        if self.following.isEmpty{
            self.noDataLabel.isHidden = false
            self.nodataImageView.isHidden = false
            self.noDataLabel.text = "No Following"
        }
        CommonWebService.sharedInstance.followingCount =  CommonWebService.sharedInstance.followingCount - 1
        self.parent?.viewWillAppear(true)
        self.followingTableView.reloadData()
    }
 
    
    func removeBlockedUserStream(index: Int) {
      
        if self.removed!{
            return
        }
        
        self.removed = true
        self.following.remove(at: index)

        if self.following.isEmpty{
            self.noDataLabel.isHidden = false
            self.nodataImageView.isHidden = false
            self.noDataLabel.text = "No Following"
        }
        CommonWebService.sharedInstance.followingCount =  CommonWebService.sharedInstance.followingCount - 1
        self.parent?.viewWillAppear(true)
        self.followingTableView.reloadData()
    }
    
}

extension FollowingVC : UIScrollViewDelegate{
     func scrollViewDidScroll(_ scrollView: UIScrollView) {
         self.view.endEditing(true)
    }
}

extension FollowingVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{
                if (textField.text?.isEmpty)!{
                    self.page = 0
                    self.followingService(isFirst: true)
                }else{
                    self.searchFollowingService(txt: textField.text!)
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
extension FollowingVC{
    
    func followingService(isFirst:Bool){
        
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
        
        params["limit"] = "\(self.page)" as AnyObject
        
        printDebug(object:params)
        
        if isFirst{
        CommonFunction.showLoader(vc: self)
        }
        
        UserService.followingApi(params: params) { (success, data,message) in
            
            self.refreshControl.endRefreshing()
            self.noDataLabel.text = message
            
            if success{
                self.parent?.viewWillAppear(true)
                CommonFunction.hideLoader(vc: self)

                if self.page == 0{
                    self.following.removeAll()
                }
                
                self.followingSearchTextField.text = ""
                printDebug(object: data)
                if let data = data{
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.nodataImageView.isHidden = true
                        
                    }else{
                        self.noDataLabel.isHidden = false
                        self.nodataImageView.isHidden = false
                        self.following.removeAll()
                    }
                    
                    self.following.append(contentsOf: data)
                    
                    self.following.sort {
                        return $0.userName!.caseInsensitiveCompare($1.userName!) == .orderedAscending
                    }
                    
                    self.followingTableView.delegate = self
                    self.followingTableView.dataSource = self
                    self.followingTableView.reloadData()
                }
            }else{
                CommonFunction.hideLoader(vc: self)

                if self.following.isEmpty{
                self.noDataLabel.isHidden = false
                self.nodataImageView.isHidden = false
                self.following.removeAll()
                    self.followingTableView.reloadData()
                    
                }
            }

        }
        
    }
 
    
    func searchFollowingService(txt : String){
        self.refreshControl.endRefreshing()

        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"search" : txt as AnyObject,"limit" : "0" as AnyObject]
        

        UserService.searchFollowingApi(params: params) { (success, data,message) in
            
            self.noDataLabel.text = message
            
            if success{
                self.parent?.viewWillAppear(true)
                printDebug(object: data)
                if let data = data{
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.nodataImageView.isHidden = true
                    }else{
                        self.noDataLabel.isHidden = false
                        self.nodataImageView.isHidden = false
                        self.following.removeAll()
                    }
                    
                    self.following = data
                    
                    self.following.sort {
                        return $0.userName!.caseInsensitiveCompare($1.userName!) == .orderedAscending
                    }
                    
                    self.followingTableView.delegate = self
                    self.followingTableView.dataSource = self
                    self.followingTableView.reloadData()
                }
            }else{
                
                self.noDataLabel.isHidden = false
                self.nodataImageView.isHidden = false
                self.following.removeAll()
                self.followingTableView.reloadData()

            }
            
        }
        
    }
    
}
