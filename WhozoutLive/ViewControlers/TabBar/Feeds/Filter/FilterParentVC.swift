
import UIKit

//protocol Filters

class FilterParentVC: UIViewController {

    //MARK:- Variables
    //====================
    var featuredChannels : FeaturedChannelsVC!
    var preferences : PreferencesVC!
    var filterDelegate : FilterData!

    //MARK:- IBOutlets
    //================

    @IBOutlet weak var preferencesButton: UIButton!
    @IBOutlet weak var featuredChannelsButton: UIButton!
    @IBOutlet weak var filterScrollView: UIScrollView!
    @IBOutlet weak var featuredChannelsHighLightView: UIView!
    @IBOutlet weak var preferencesHignlightView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var applyButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func featuredCjannelsButtontapped(_ sender: UIButton) {

        self.filterScrollView.setContentOffset(CGPoint.zero, animated: true)
    }
    
    
    @IBAction func preferencesButtontapped(_ sender: UIButton){
        self.filterScrollView.setContentOffset(        CGPoint(x: screenWidth, y: 0), animated: true)

    }
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetButtontapped(_ sender: UIButton) {
        if Networking.isConnectedToNetwork{
        VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "" as AnyObject?
        VKCTabBarControllar.sharedInstance.filterDict["gender"] = "both" as AnyObject
        VKCTabBarControllar.sharedInstance.filterTags.removeAll()
        
        self.featuredChannels.selectedTags.removeAll()
        self.featuredChannels.tagTableView.reloadData()
        self.filterDelegate.resetFilter()
        self.preferences.setUpSubView()
        //self.dismiss(animated: true, completion: nil)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    @IBAction func applyButtontapped(_ sender: UIButton) {
        if Networking.isConnectedToNetwork{
        VKCTabBarControllar.sharedInstance.filterDict["gender"] = self.preferences.gender as AnyObject?
        VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = self.preferences.sortBy as AnyObject?
        VKCTabBarControllar.sharedInstance.filterTags = self.featuredChannels.selectedTags
        self.filterDelegate.applyFilter()
        self.dismiss(animated: true, completion: nil)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
}


//MARK:- Private functions
//======================
private extension FilterParentVC{
    
    func setUpSubView(){
        self.filterScrollView.contentSize = CGSize(width: screenWidth * 2, height: self.view.frame.height - 195)
        self.featuredChannelsHighLightView.isHidden = false
        self.preferencesHignlightView.isHidden = true
        self.featuredChannelsButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
        self.preferencesButton.setTitleColor(
            AppColors.lightGrey, for: UIControlState.normal)
        self.filterScrollView.delegate = self
        self.filterScrollView.isPagingEnabled = true
        self.addFeaturedVC()
        self.addPreferences()
    }
    
//add featured channels vc
//==========================
    func addFeaturedVC(){
        self.featuredChannels = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FeaturedChannelsID") as! FeaturedChannelsVC
        self.filterScrollView.frame = self.featuredChannels.view.frame
        self.filterScrollView.addSubview(self.featuredChannels.view)
        self.featuredChannels.willMove(toParentViewController: self)
        self.addChildViewController(self.featuredChannels)
        self.featuredChannels.view.frame.size.height = self.filterScrollView.frame.height
        self.featuredChannels.view.frame.origin = CGPoint.zero
    }
    
    
//add preferences vc
//=======================
    func addPreferences(){
        self.preferences = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "PreferencesID") as! PreferencesVC
        self.filterScrollView.frame = self.preferences.view.frame
        self.filterScrollView.addSubview(self.preferences.view)
        self.preferences.willMove(toParentViewController: self)
        self.addChildViewController(self.preferences)
        self.preferences.view.frame.size.height = self.filterScrollView.frame.height
        self.preferences.view.frame.origin = CGPoint(x: screenWidth, y: 0)
    }
}


//MARK:- scrollview delegate
//==============================
extension FilterParentVC : UIScrollViewDelegate{
 
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if scrollView.contentOffset == CGPoint.zero{
            self.featuredChannelsHighLightView.isHidden = false
            self.preferencesHignlightView.isHidden = true
            self.featuredChannelsButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            
            self.preferencesButton.setTitleColor(
                AppColors.lightGrey, for: UIControlState.normal)
            
        }else{
            self.featuredChannelsHighLightView.isHidden = true
            self.preferencesHignlightView.isHidden = false
            self.featuredChannelsButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            
            self.preferencesButton.setTitleColor(
                AppColors.pinkColor, for: UIControlState.normal)
        }
        
    }
    
}

