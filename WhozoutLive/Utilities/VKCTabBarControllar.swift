

import UIKit

//protocol TabBarDelegate {
//    func tabBarPush()
//}


enum FilterAppliedOrNot{
    
    case Applied
    case NotApplied
    
}

class VKCTabBarControllar: UITabBarController {
    
    private var count:Int=0
    //private var topSeparaterView:UIView!
    var EYTabbarView:UIView!
    private var tabBarImages:NSArray = []
    private var tabBarButtons:NSMutableArray = []
    private var tabBarLabels:NSMutableArray = []
    private var tabBarBadgeLabel:NSMutableArray = []
    
    var barHeight:CGFloat = 0
    var AnimationDuration:TimeInterval = 0.38
    var SpringDamping:CGFloat = 0.7
    var SpringVelocity:CGFloat = 0.6
    private var unitWidth:CGFloat!
    let height:CGFloat = UIScreen.main.bounds.height
    var currentBtnTag = 0
    
    var viewController1: UIViewController!
    var viewController2: UIViewController!
    var viewController3: UIViewController!
    var viewController4: UIViewController!
    var viewController5: UIViewController!
    
    var streamingNavigation : UINavigationController?
    
    var filterDict : jsonDictionary = ["sortBy" : "" as AnyObject,"gender" : "both" as AnyObject]
    
    var filterTags : StringArray = []
    
    
    var button1 : UIButton?
    var button2 : UIButton?
    var button3 : UIButton?
    var button4 : UIButton?
    var button5 : UIButton?
    
    var isFilterApplied = FilterAppliedOrNot.NotApplied
    
    var streamingVC : StreamingVC?
    
    class var sharedInstance : VKCTabBarControllar {
        
        if let tabBar = sharedAppdelegate.tabBar {
            return tabBar
        }
        struct Static {
            static let instance : VKCTabBarControllar = VKCTabBarControllar()
        }
        return Static.instance
    }
    
    override  init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    init(icons:NSArray) {
        super.init(nibName: nil, bundle: nil)
        tabBarImages = ["feed","connections","goLive2","settings","profile"]
        count = 5
        initCustomTabBar()
        initViews()
    }
    
    func initTabbar(){
        tabBarImages = ["feed","connections","goLive2","settings","profile"]
        count = 5
        initCustomTabBar()
        initViews()
    }
    
    func initCustomTabBar()
    {
        barHeight = 50
        
        EYTabbarView = UIView(frame: CGRect(x: 0, y: height - barHeight, width: self.view.frame.width, height: barHeight))
    
        self.tabBar.isUserInteractionEnabled = false
        self.view.addSubview(EYTabbarView)
    }
    
    func initViews()
    {
        unitWidth = EYTabbarView.frame.width/CGFloat(count)
        for i in 0..<count
        {
            let imgName:String = tabBarImages[i] as! String
            let img:UIImage = UIImage(named: String(NSString(format: "%@.png",imgName)))!
            let selImg:UIImage = UIImage(named: String(NSString(format: "%@_selected.png",imgName)))!
            let x:CGFloat = CGFloat(i)*unitWidth
            let button:UIButton = UIButton(frame:  CGRect(x: (x + unitWidth / 2 ) - 10 , y: 10, width: 20, height: 20))
        
            button.setImage(img, for: UIControlState.normal)
            button.setImage(selImg, for: UIControlState.selected)
            button.tag = i
            button.imageView?.contentMode = .scaleToFill
            
            button.addTarget(self, action: #selector(VKCTabBarControllar.selectTab), for: UIControlEvents.touchUpInside)
            
            let label = UILabel()
            label.textColor = AppColors.placeHolderColor
            label.backgroundColor = UIColor.clear
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.textAlignment = NSTextAlignment.center
            
            
            
            if(i == 0)
            {
                label.text = "Feeds"
                label.frame = CGRect(x: x , y: 30, width: unitWidth, height: 15)
                label.font = AppFonts.lotoRegular.withSize(11)
                
            }
            else if (i == 1)
            {
                label.text = "Connections"
                label.frame = CGRect(x: x  , y: 30, width: unitWidth, height: 15)
                label.font = AppFonts.lotoRegular.withSize(11)
                
            }
            else if (i == 2)
            {
               button.frame = CGRect(x: (x + unitWidth / 2 ) - 20 , y: 0, width: 40, height: 30)
                label.text = "Go Live"
                label.frame = CGRect(x: x , y: 30, width: unitWidth, height: 15)
                label.font = AppFonts.lotoRegular.withSize(15)
                  button.imageView?.contentMode = .top
            }
            else if (i == 3)
            {
                label.text = "Settings"
                label.frame = CGRect(x: x , y: 30, width: unitWidth, height: 15)
                label.font = AppFonts.lotoRegular.withSize(11)
                
                
            }
            else if (i == 4)
            {
                label.text = "Profile"
                label.frame = CGRect(x: x , y: 30, width: unitWidth, height: 15)
                label.font = AppFonts.lotoRegular.withSize(11)
    
            }
            
            tabBarLabels.add(label)
            tabBarButtons.add(button)
            
            let tabButton: UIButton = UIButton(type: UIButtonType.custom)
            
            tabButton.tag = i
            tabButton.frame = CGRect(x:unitWidth * CGFloat(i),y: -10, width:unitWidth, height:barHeight + 10)
            
            tabButton.addTarget(self, action: #selector(VKCTabBarControllar.selectTab), for: UIControlEvents.touchUpInside)
            
            
            tabButton.addTarget(self, action: #selector(VKCTabBarControllar.selectTab), for: UIControlEvents.touchUpInside)
            
            let backView = UIView()
            let topSeperator = UIView()
            
            backView.frame = CGRect(x:unitWidth * CGFloat(i),y: -7, width:unitWidth, height:barHeight + 7)
            backView.backgroundColor = UIColor.clear
           // backView.layer.cornerRadius = 5.0
            
            let maskPath = UIBezierPath(roundedRect: backView.bounds, byRoundingCorners: [UIRectCorner.topLeft,UIRectCorner.topRight], cornerRadii: CGSize(width: 6.0, height: 6.0))
            
            let maskLayer = CAShapeLayer()
            maskLayer.frame = backView.bounds
            maskLayer.path = maskPath.cgPath
            backView.layer.mask = maskLayer
            backView.clipsToBounds = true
            topSeperator.frame = CGRect(x: unitWidth * CGFloat(i), y: 7, width: unitWidth, height: 10)
            topSeperator.backgroundColor = AppColors.seperatorGreyColor
            
            if i == 2{
                backView.backgroundColor = AppColors.pinkColor
                label.textColor = UIColor.white
                backView.layer.borderColor = AppColors.goLiveBorderColor.cgColor
                backView.layer.borderWidth = 1.0
                
                
                topSeperator.backgroundColor = UIColor.clear
            }
            
            
            // backView.addSubview(topSeperator)
            
            
            self.EYTabbarView.addSubview(backView)
            self.EYTabbarView.addSubview(button)
            self.EYTabbarView.addSubview(label)
            self.EYTabbarView.addSubview(tabButton)
            
        }
        self.setCurrentTab(index: 0)
    }
    
    func setCurrentTab(index:Int)
    {
        
         self.button1 = (tabBarButtons.object(at: 0) as? UIButton)!
         self.button2 = (tabBarButtons.object(at: 1) as? UIButton)!
         self.button3 = (tabBarButtons.object(at: 2) as? UIButton)!
         self.button4 = (tabBarButtons.object(at: 3) as? UIButton)!
         self.button5 = (tabBarButtons.object(at: 4) as? UIButton)!
        
        
        let label1:UILabel = (tabBarLabels.object(at: 0) as? UILabel)!
        let label2:UILabel = (tabBarLabels.object(at: 1) as? UILabel)!
        let label3:UILabel = (tabBarLabels.object(at: 2) as? UILabel)!
        let label4:UILabel = (tabBarLabels.object(at: 3) as? UILabel)!
        let label5:UILabel = (tabBarLabels.object(at: 4) as? UILabel)!
        
        button1?.isSelected = false
        button2?.isSelected = false
        
        button3?.isSelected = false
        button4?.isSelected = false
        button5?.isSelected = false
        label1.textColor = AppColors.placeHolderColor
        label2.textColor = AppColors.placeHolderColor
        label3.textColor = UIColor.white
        label4.textColor = AppColors.placeHolderColor
        label5.textColor = AppColors.placeHolderColor
        
        if(index == 0)
        {
            button1?.isSelected = true
            label1.textColor = AppColors.pinkColor
        }
        else if (index == 1)
        {
            button2?.isSelected = true
            label2.textColor = AppColors.pinkColor
        }
        else if (index == 2)
        {
            button3?.isSelected = true
            label3.textColor = AppColors.pinkColor
        }
        else if (index == 3)
        {
            button4?.isSelected = true
            label4.textColor = AppColors.pinkColor
        }
        else if (index == 4)
        {
            button5?.isSelected = true
            label5.textColor = AppColors.pinkColor
        }
    }
    
    
    func showTabBar() {
        EYTabbarView.frame.origin.y = height-barHeight
    }
    
    func hideTabBar() {
        EYTabbarView.frame.origin.y += barHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.viewController1 = self.viewControllers![0]
        self.viewController2 = self.viewControllers![1]
        self.viewController3 = self.viewControllers![2]
        self.viewController4 = self.viewControllers![3]
        //self.viewController5 = self.viewControllers![4]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func statusBarHeightChanged(notification: NSNotification) {
        var frame: CGRect = self.EYTabbarView.frame
       
        if UIApplication.shared.statusBarFrame.height == 20{
            frame.origin.y = self.height - self.barHeight

        }else{
            frame.origin.y = self.height - self.barHeight - 20

        }
        
        UIView.animate(withDuration: 0.35) { () -> Void in
            self.EYTabbarView.frame = frame;
        }
        self.view.layoutIfNeeded()
    }
    
    
    func selectTab(button:UIButton)
    {
        
        if !SocketHelper.sharedInstance.socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
            
        }
        
        ConnectionsFrom.connectFrom = .TabBar

        printDebug(object: button.tag)
        
        self.currentBtnTag = button.tag
        
        if(button.tag == 2) {
            printDebug(object: "present")
            
            DispatchQueue.main.async {
                
            if Networking.isConnectedToNetwork{
                
                self.checkPermissions()
            
        }else{
                    CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("internet connection", comment: ""), vc: self)
                    
                }
            }
            
            return
            return
        }
        
        self.selectedIndex = button.tag
        self.setCurrentTab(index: self.selectedIndex)
        if(self.selectedIndex == 0) {
            
            let feedsNavigation = self.viewControllers![0] as! UINavigationController
            let newVcObj =  StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LandingID") as! LandingVC
            feedsNavigation.viewControllers[0] = newVcObj
            feedsNavigation.popToRootViewController(animated: false)
        }
        if(self.selectedIndex == 1) {
            let connectionNavigation = self.viewControllers![1] as! UINavigationController
            if !connectionNavigation.viewControllers[0].isKind(of: ConnectionsVC.self)
            {
                let newVcObj =  StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ConnectionsID") as! ConnectionsVC
                
                
                ConnectionsFrom.connectFrom = .TabBar

            
                connectionNavigation.viewControllers[0] = newVcObj
            }
            connectionNavigation.popToRootViewController(animated: false)
        }
        if(self.selectedIndex == 3) {
            let settingsNavigation = self.viewControllers![3] as! UINavigationController
            if !settingsNavigation.viewControllers[0].isKind(of: SettingsVC.self)
            {
                let newVcObj =  StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SettingsID") as! SettingsVC
                settingsNavigation.viewControllers[0] = newVcObj
            }
            settingsNavigation.popToRootViewController(animated: false)
        }
        if(self.selectedIndex == 4) {
            let profileNavigation = self.viewControllers![4] as! UINavigationController
            if !profileNavigation.viewControllers[0].isKind(of: ProfileVC.self)
            {
                let newVcObj =  StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ProfileVC") as! ProfileVC
                newVcObj.profileFrom = .FromOther
                profileNavigation.viewControllers[0] = newVcObj
            }
            profileNavigation.popToRootViewController(animated: false)
        }
    }
    
    func checkPermissions(){
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
  AVAudioSession.sharedInstance().recordPermission()
        
        AVAudioSession.sharedInstance().requestRecordPermission({ (success) in
            if success{
                
                // self.navigationController?.present(self.streamingNavigation, animated: true, completion: nil)
                
                if authStatus == AVAuthorizationStatus.authorized {
                    //let //streamingNavigation = UINavigationController()

                 let streamingVC =  StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "StreamingID") as! StreamingVC
                   let streamingNavigation = UINavigationController(rootViewController: streamingVC)
                    streamingNavigation.isNavigationBarHidden = true
                self.navigationController?.present(streamingNavigation, animated: true, completion: nil)
                }else{
                    
                    if authStatus == AVAuthorizationStatus.notDetermined {
                        
                        AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) in
                            
                            
                                if granted {
                                    
                    // self.navigationController?.present(self.streamingNavigation, animated: true, completion: nil)
                                    
                                }else{
                                    
                                }
                                
    
                        })
                        
                    }else{
                        
                        _ = VKCAlertController.alert(title: "Camera Accessability", message: "Whozout would like to access your Camera.", buttons: ["Go To Settings","Cancel"], tapBlock: { (_, index) in
                            
                            if index == 0{
                                UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                    
                                    
                                })

                            }
                            
                        })
                    }
                }
            }else{
               
                _ = VKCAlertController.alert(title: "Microphone Accessability", message: "Whozout would like to access your Microphone.", buttons: ["Go To Settings","Cancel"], tapBlock: { (_, index) in
                    
                    if index == 0{
                        UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                            
                            
                        })

                    }
                    
                })
            }
        })

    }
    
}
