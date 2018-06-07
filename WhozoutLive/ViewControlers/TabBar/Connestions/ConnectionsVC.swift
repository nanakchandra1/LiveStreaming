
import UIKit



class ConnectionsVC: UIViewController {

    //MARK:- Variables
    
    var followersVC : FollowersVC!
    var followingVC : FollowingVC!
    var othersVC : OthersVC!
    var selectedFollowers : StringArray = []
    var selectedFollowing : StringArray = []

    
    //MARK:- IBOutlets
    //=================
    //@IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var notificationCountLabel: UILabel!
    @IBOutlet weak var notificationButton: UIButton!
   // @IBOutlet weak var tokenLeftLabel: UILabel!
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    @IBOutlet weak var connectionsScrollView: UIScrollView!
   // @IBOutlet weak var followingHighLightView: UIView!
    @IBOutlet weak var followersHighLigntView: UIView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
   // @IBOutlet weak var otherHighLightView: UIView!
    @IBOutlet weak var othersButton: UIButton!
    
    @IBOutlet weak var tokenLeftButton: UIButton!
    
    @IBOutlet weak var highLightViewLeading: NSLayoutConstraint!
    
    //MARK:- view life cycke
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        printDebug(object: "connections will appear")
        self.setHeader()
    self.setCount()
        sharedAppdelegate.notificationDelegate = self
    }

 
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
 
    
    override func viewDidLayoutSubviews() {
        
        self.notificationCountLabel.text = "\(CommonWebService.sharedInstance.pushCount)"
        
        if CommonWebService.sharedInstance.pushCount == 0{
            
            self.notificationCountLabel.isHidden = true
        }else{
            
            self.notificationCountLabel.isHidden = false
        }
        
        
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
    
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        
        if self.followersVC.selectedFollowers.count > 0 || self.followingVC.selectedFollowing.count > 0{
          
            ConnectionsFrom.connectFrom = .TabBar

            self.dismiss(animated: true, completion: nil)
        }else{
            CommonFunction.showTsMessageErrorInViewControler(message: "Please select a friend.", vc: self)
        }
    }
   
    
    @IBAction func cancelButtontapped(_ sender: UIButton) {
        ConnectionsFrom.connectFrom = .TabBar
        self.dismiss(animated: true, completion: nil)
    }
    
  
    @IBAction func tokenleftButtontapped(_ sender: UIButton) {
        
        if Networking.isConnectedToNetwork{
            CommonWebService.sharedInstance.pushPurchaseToken(from: PurchaseFrom.TokenLessButton)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }

    }
}

//MARK:- IBActions
//=====================
extension ConnectionsVC{
    @IBAction func followingButtonTapped(_ sender: UIButton) {
        self.followingVC.followingTableView.reloadData()
        self.followersVC.followersTableView.reloadData()

        self.connectionsScrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
     
    }
    
    
    @IBAction func followersButtonTapped(_ sender: UIButton) {
        self.followingVC.followingTableView.reloadData()
        self.followersVC.followersTableView.reloadData()
       
        self.connectionsScrollView.setContentOffset(CGPoint.zero, animated: true)
        
    }
    
    
    @IBAction func othersButtontapped(_ sender: UIButton) {
        
         self.connectionsScrollView.setContentOffset(CGPoint(x: screenWidth * 2, y: 0), animated: true)
        
    }

}

private extension ConnectionsVC{
    
    //set up view
    //=============
    func setUpSubView(){
        self.connectionsScrollView.delegate = self
        sharedAppdelegate.notificationDelegate = self
         self.connectionsScrollView.contentSize = CGSize(width: screenWidth * 3, height: self.view.frame.height - 195)
        self.addFollowersVC()
        self.addFollowingVC()
        self.addOtherVC()
        self.followersButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
        self.followingButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
        self.othersButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)

//        self.followingHighLightView.isHidden = true
//        self.otherHighLightView.isHidden = true
        self.connectionsScrollView.isPagingEnabled = true
        
        self.notificationCountLabel.layer.cornerRadius = 3.0
        self.notificationCountLabel.clipsToBounds = true
        
        self.tokenLeftButton.layer.borderWidth = 1.0
        self.tokenLeftButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.tokenLeftButton.layer.cornerRadius = 3.0
    }
    
    
    
    func setPushCount(){
        self.notificationCountLabel.text = "\(CommonWebService.sharedInstance.pushCount)"
        
        if CommonWebService.sharedInstance.pushCount == 0{
            
            self.notificationCountLabel.isHidden = true
        }else{
            self.notificationCountLabel.isHidden = false
        }
    }
    
    func setHeader(){
        if ConnectionsFrom.connectFrom == .SharingInformation{
            self.tokenLeftButton.isHidden = true
            self.notificationButton.isHidden = true
            self.notificationCountLabel.isHidden = true
            self.doneButton.isHidden = false
            self.cancelButton.isHidden = false
        }else{
            self.tokenLeftButton.isHidden = false
            self.notificationButton.isHidden = false
            self.notificationCountLabel.isHidden = false
            self.doneButton.isHidden = true
            self.cancelButton.isHidden = true
        }
    }
    
    
    func setCount(){
        
        self.followingButton.setTitle("Following(\(CommonWebService.sharedInstance.followingCount))", for: UIControlState.normal)
        
        self.followersButton.setTitle("Followers(\(CommonWebService.sharedInstance.followersCount))", for: UIControlState.normal)
        
        if let tokens = CurentUser.tokenCount{
            
            let tokenInPoints = "\(CommonFunction.formatPoints(num: Double(tokens)!))"
            
            self.tokenLeftButton.setTitle("\(tokenInPoints) Tokens Left", for: UIControlState.normal)
        }
        
      self.setPushCount()
    }
    
    
    
    //add followers vc
    //====================
    func addFollowersVC(){
        self.followersVC = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FollowersID") as! FollowersVC
             self.connectionsScrollView.frame = self.followersVC.view.frame
        self.connectionsScrollView.addSubview(self.followersVC.view)
        self.followersVC.willMove(toParentViewController: self)
        self.addChildViewController(self.followersVC)
        self.followersVC.view.frame.size.height = self.connectionsScrollView.frame.height
        self.followersVC.view.frame.origin = CGPoint.zero
    }
    
    //MARK:- add following vc
    //=====================
    func addFollowingVC(){
        self.followingVC = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FollowingID") as! FollowingVC
        
        self.connectionsScrollView.frame = self.followingVC.view.frame
        self.connectionsScrollView.addSubview(self.followingVC.view)
        self.followingVC.willMove(toParentViewController: self)
        self.addChildViewController(self.followingVC)
        self.followingVC.view.frame.size.height = self.connectionsScrollView.frame.height
        self.followingVC.view.frame.origin = CGPoint(x: screenWidth, y: 0)
    }
    
    
    //MARK:- add following vc
    //=====================
    func addOtherVC(){
        self.othersVC = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OthersID") as! OthersVC
        self.connectionsScrollView.frame = self.othersVC.view.frame
        self.connectionsScrollView.addSubview(self.othersVC.view)
        self.othersVC.willMove(toParentViewController: self)
        self.addChildViewController(self.othersVC)
        self.othersVC.view.frame.size.height = self.connectionsScrollView.frame.height
        self.othersVC.view.frame.origin = CGPoint(x: screenWidth * 2, y: 0)
    }

}

extension ConnectionsVC : NotificationBellDelegate{
    
    
    func showCount(){
        
        
        self.setPushCount()
        
    }
    
}


extension ConnectionsVC : UIScrollViewDelegate{
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
      
        self.highLightViewLeading.constant = scrollView.contentOffset.x / 3

        if scrollView.contentOffset == CGPoint.zero{
//            self.followingHighLightView.isHidden = true
//            self.followersHighLigntView.isHidden = false
//            self.otherHighLightView.isHidden = true

            self.followersButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            self.followingButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            self.othersButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            
           // if self.followersVC.followers.isEmpty{
            self.followersVC.page = 0
                self.followersVC.followersService(isFirst: true)

           // }
        }else if scrollView.contentOffset == CGPoint(x: screenWidth, y: 0){
            
            
//            self.followingHighLightView.isHidden = false
//            self.followersHighLigntView.isHidden = true
//            self.otherHighLightView.isHidden = true
            self.followersButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            self.followingButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            self.othersButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            
           // if self.followingVC.following.isEmpty{
                self.followingVC.page = 0

                   self.followingVC.followingService(isFirst: true)
           // }
        }
        
        else{
           
//            self.followingHighLightView.isHidden = true
//            self.followersHighLigntView.isHidden = true
//            self.otherHighLightView.isHidden = false
            self.followersButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            self.followingButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            self.othersButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            
            if self.othersVC.others.isEmpty{
                self.othersVC.page = 0
                self.othersVC.otherUsersService(text: "",isFirst:true)
           }
        }
    }
    
}



