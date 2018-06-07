

import UIKit

enum LikeListtype : String{
    case FeedsLikeList
    case ImageLikeList
    case FeedsViews
    case ImageViews
    case None
}

class LikeAndViewsListVC: UIViewController {

    
    var likeList : [FollowersFollowingData] = []
    var selectedFollowers : StringArray = []
    var mediaId : String!
    var type = LikeListtype.None
    var index : Int! 
    var getDataBackDelegate : GetDataBack!
    var refreshControl = UIRefreshControl()
    
    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var likeAndViiewsTableView: UITableView!
    @IBOutlet weak var vcHeadingLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }


}


private extension LikeAndViewsListVC{
    
    func setUpSubView(){
         self.searchTextField.attributedPlaceholder = CommonFunction.setPlaceHolderWithColor(text: "Search",color:UIColor.white)
        let cellNib = UINib(nibName: "FollowingFollowersCell", bundle: nil)
       self.likeAndViiewsTableView.register(cellNib, forCellReuseIdentifier: "followingFollowersCell")
         self.likeAndViiewsTableView.delegate = self
        self.likeAndViiewsTableView.dataSource = self
        self.searchTextField.delegate = self
        self.noDataLabel.isHidden = true
        
        self.refreshControl.attributedTitle = NSAttributedString(string:"")
        self.refreshControl.addTarget(self, action: #selector(LikeAndViewsListVC.getUpdatedData), for: UIControlEvents.valueChanged)
        self.likeAndViiewsTableView!.addSubview(refreshControl)
        self.refreshControl.tintColor = AppColors.pinkColor
        
        self.getDataOfType()
    
    }
    
    @objc func getUpdatedData(){
        if self.type == .FeedsLikeList{
            self.getLikeListApi(type: "1")
        }else if self.type == .ImageLikeList{
            self.getLikeListApi(type: "0")
        }else if self.type == .FeedsViews{
            self.getViewListApi(type: "1")
        }else if self.type == .ImageViews{
            self.getViewListApi(type: "0")
        }
    }
    
    func getDataOfType(){
        if self.type == .FeedsLikeList{
            self.getLikeListApi(type: "1")
            self.vcHeadingLabel.text = "Likes"
            self.noDataLabel.text = "No Likes Found"
        }else if self.type == .ImageLikeList{
            self.getLikeListApi(type: "0")
            self.vcHeadingLabel.text = "Likes"
            self.noDataLabel.text = "No Likes Found"
        }else if self.type == .FeedsViews{
            self.getViewListApi(type: "1")
            self.vcHeadingLabel.text = "Views"
            self.noDataLabel.text = "No Views Found"
        }else if self.type == .ImageViews{
            self.getViewListApi(type: "0")
            self.vcHeadingLabel.text = "Views"
            self.noDataLabel.text = "No views found"
        }
    }
}


//MARK:- Tableview datasource and delegate methods
//===================================================
extension LikeAndViewsListVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.likeList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "followingFollowersCell") as! FollowingFollowersCell
        
        cell.liveStreamButton.isHidden = true
        cell.tickImageView.isHidden = true
        
        
        
        cell.followUnfollowBitton.addTarget(self, action: #selector(FollowersVC.followButtonTapped), for: UIControlEvents.touchUpInside)
        
        cell.followerNamelabel.text = self.likeList[indexPath.row].userName
        
        cell.setFollowButtonImage(isFollow: self.likeList[indexPath.row].isfollowed!)
        
        
        if self.likeList[indexPath.row].userImage! != URLName.demoUrl{
            cell.profileImageView.setImageWithStringURL(URL: self.likeList[indexPath.row].userImage!, placeholder: UIImage(named: "userPlaceholder")!)
        }else{
            cell.profileImageView.image = UIImage(named : "userPlaceholder")
        }
        
        if self.likeList[indexPath.row].userId == CurentUser.userId{
            cell.followUnfollowBitton.isHidden = true
        }else{
            
            cell.followUnfollowBitton.isHidden = false

        }

        return cell
    }
    
    func tableView(_ taleView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }

}


extension LikeAndViewsListVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        CommonFunction.delayy(delay: 0.1) {
            
            if Networking.isConnectedToNetwork{

                if self.type == .FeedsViews{
                   
                    if (textField.text?.isEmpty)!{
                        self.getViewListApi(type: "1")

                    }else{
                        self.searchViews(txt: textField.text!, type: "1")
                    }
                    
                }else if self.type == .FeedsLikeList{
                    
                    if (textField.text?.isEmpty)!{
                         self.getLikeListApi(type: "1")
                    }else{
                        self.searchLike(txt: textField.text!, type: "1")
                    }
                    
                    
                }else if self.type == .ImageViews{
                    
                    if (textField.text?.isEmpty)!{
                        self.getViewListApi(type: "1")

                    }else{
                         self.searchViews(txt: textField.text!, type: "0")
                    }
                    
                    
                }else if self.type == .ImageLikeList{
                    
                    if (textField.text?.isEmpty)!{
                         self.getLikeListApi(type: "0")
                    }else{
                        self.searchLike(txt: textField.text!, type: "1")

                    }
                    
                    
                }
                
                
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
                
            }
        }
        
        return true
    }
    
}


extension LikeAndViewsListVC{
    
    
    func getLikeListApi(type:String){
        
        printDebug(object: "----->>like list api \(type)")
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"mediaId" : self.mediaId as AnyObject,"mediaType" : type as AnyObject]
        
        UserService.getlikelistApi(params: params) { (success, data) in
            self.refreshControl.endRefreshing()
            self.searchTextField.text = ""

            CommonFunction.showLoader(vc: self)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                if let data = data {
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.likeAndViiewsTableView.isHidden = false
                    }else{
                        self.noDataLabel.isHidden = false
                        self.likeAndViiewsTableView.isHidden = true
                    }
                    
                    
                    self.likeList = data
                    
                    self.likeAndViiewsTableView.reloadData()
                }else{
                    
                    
                }
                
                
            }else{
                self.noDataLabel.isHidden = false
                self.likeAndViiewsTableView.isHidden = true
                CommonFunction.hideLoader(vc: self)
            }
          
        }
        
    }
    
    
    
    
    func getViewListApi(type:String){
        
printDebug(object: "----->>view list api \(type)")
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"mediaId" : self.mediaId as AnyObject,"mediaType" : type as AnyObject]
        
        UserService.getViewslistApi(params: params) { (success, data) in
            self.refreshControl.endRefreshing()
            self.searchTextField.text = ""

            CommonFunction.showLoader(vc: self)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                if let data = data {
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.likeAndViiewsTableView.isHidden = false
                    }else{
                        self.noDataLabel.isHidden = false
                        self.likeAndViiewsTableView.isHidden = true
                    }
                    
                    
                    self.likeList = data
                    
                    self.likeAndViiewsTableView.reloadData()
                }else{
                    
                    
                }
                
                
            }else{
                self.noDataLabel.isHidden = false
                self.likeAndViiewsTableView.isHidden = true
                CommonFunction.hideLoader(vc: self)
            }
            
        }
        
    }
    

    
    
    func followButtonTapped(sender : UIButton){
        
        let index = sender.tableViewIndexPath(tableView: self.likeAndViiewsTableView)
        CommonWebService.sharedInstance.userIdToFollow = self.likeList[(index?.row)!].userId!
        if self.likeList[(index?.row)!].isfollowed == "0"{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId:   self.likeList[(index?.row)!].userId!,followType: "1", name : self.likeList[(index?.row)!].userName! , vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.likeList[(index?.row)!].isfollowed = "1"
                    self.likeAndViiewsTableView.reloadData()
                }else{
                    
                }
                
            }
        }else{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId: self.likeList[(index?.row)!].userId!, followType: "0",name : self.likeList[(index?.row)!].userName! ,  vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.likeList[(index?.row)!].isfollowed = "0"
                    self.likeAndViiewsTableView.reloadData()
                }else{
                    
                }
                
            }
        }
        
        
    }

    func searchLike(txt : String,type:String){
        
       // mediaId,search,mediaType,(0 for image ans 1 for feed)
        
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"mediaId" : self.mediaId as AnyObject,"search" : txt as AnyObject,"mediaType":type as AnyObject,"limit" : "0" as AnyObject]
        
        UserService.searchLikeApi(params: params) { (success, data) in
            self.refreshControl.endRefreshing()
            self.searchTextField.text = ""

            if success{
                
                if let data = data{
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.likeAndViiewsTableView.isHidden = false
                    }else{
                        self.noDataLabel.isHidden = false
                        self.likeAndViiewsTableView.isHidden = true
                    }
                    
                    self.likeList = data
                    self.likeAndViiewsTableView.reloadData()
                }
                
            }else{
                self.noDataLabel.isHidden = false
                self.likeAndViiewsTableView.isHidden = true
            }
            
        }
        
    }
    
  
    func searchViews(txt : String,type:String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"search" : txt as AnyObject,"limit" : "0" as AnyObject,"mediaType," : type as AnyObject]
        
        print(params)
        
        UserService.searchViewsApi(params: params) { (success, data) in
            self.refreshControl.endRefreshing()
self.searchTextField.text = ""
            if success{
                
                if let data = data{
                    
                    if data.count > 0{
                        self.noDataLabel.isHidden = true
                        self.likeAndViiewsTableView.isHidden = false
                    }else{
                        self.noDataLabel.isHidden = false
                        self.likeAndViiewsTableView.isHidden = true

                    }
                    
                    self.likeList = data
                    self.likeAndViiewsTableView.reloadData()
                }
                
            }else{
                self.noDataLabel.isHidden = false
                self.likeAndViiewsTableView.isHidden = true
            }
            
        }
        
    }
    

    
}
