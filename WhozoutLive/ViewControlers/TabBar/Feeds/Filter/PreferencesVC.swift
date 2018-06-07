

import UIKit

enum Sorting : String{
    case Distance = "distance"
    case Likes = "likes"
    case Chats = "chats"
    case Followers = "followers"
    case Viewers = "viewers"
    case Date = "date"
    case None = "none"
}


class PreferencesVC: UIViewController  {

  
    //MARK:- Variables
    //=================
    var sortBy = ""
    var gender = ""
    
    //IBOutlets
    //===========
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    @IBOutlet weak var distanceButton: UIButton!
    @IBOutlet weak var chatsButton: UIButton!
    @IBOutlet weak var likesButton: UIButton!
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var viewesButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    override func viewDidLayoutSubviews() {

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func maleButtontapped(_ sender: UIButton) {
        
        self.setGenderState(gender:"male")
        
    }
    
    
    @IBAction func femaleButtontapped(_ sender: UIButton) {
        
        self.setGenderState(gender: "female")
   
    }

    @IBAction func bothButtontapped(_ sender: UIButton) {

        self.setGenderState(gender: "both")

    }
    
    @IBAction func distanceButtontapped(_ sender: UIButton) {
        
        if sender.isSelected{

            self.deselectRestOfTheSortingButtons(tappedButton: sender)

        }else{

            printDebug(object: "Deselected")
            
        self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

            
        }
    }
    
    @IBAction func likesButtonTapped(_ sender: UIButton) {
     
        if sender.isSelected{
            printDebug(object: "selected")
        
            self.deselectRestOfTheSortingButtons(tappedButton: sender)

        }else{
          
            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())
            
            printDebug(object: "Deselected")
            
        }
    }
    
    @IBAction func chatsButtontapped(_ sender: UIButton) {
       
        if sender.isSelected{
            printDebug(object: "selected")

            self.deselectRestOfTheSortingButtons(tappedButton: sender)

        }else{
 
          
            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

        }
    }
    
    
    @IBAction func followersButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected{
            printDebug(object: "selected")

            self.deselectRestOfTheSortingButtons(tappedButton: sender)

        }else{

            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

            printDebug(object: "Deselected")
            
        }
    }
    
    
    @IBAction func viewersButtontapped(_ sender: UIButton) {
        
        if sender.isSelected{
            printDebug(object: "selected")

            self.deselectRestOfTheSortingButtons(tappedButton: sender)

        }else{

            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

            printDebug(object: "Deselected")
            
        }
        }
    
    
    @IBAction func dateButtontapped(_ sender: UIButton) {
        
        if sender.isSelected{
            printDebug(object: "selected")

            self.deselectRestOfTheSortingButtons(tappedButton: sender)
        }else{

            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

            printDebug(object: "Deselected")
            
        }
    }
}



 extension PreferencesVC{
    
    func setUpSubView(){
        self.setViewForSortingbutton()
        
        
    self.displaySortingFilterValues(sortingType: VKCTabBarControllar.sharedInstance.filterDict["sortBy"] as! String)
        
         self.setGenderState(gender : VKCTabBarControllar.sharedInstance.filterDict["gender"] as! String)
        
    }
    
    func setViewForSortingbutton(){
        self.distanceButton.layer.cornerRadius = 5.0
        self.likesButton.layer.cornerRadius = 5.0
        self.chatsButton.layer.cornerRadius = 5.0
        self.followersButton.layer.cornerRadius = 5.0
        self.viewesButton.layer.cornerRadius = 5.0
        self.dateButton.layer.cornerRadius = 5.0
        
        self.distanceButton.layer.borderWidth = 1.0
        self.likesButton.layer.borderWidth = 1.0
        self.chatsButton.layer.borderWidth = 1.0
        self.followersButton.layer.borderWidth = 1.0
        self.viewesButton.layer.borderWidth = 1.0
        self.dateButton.layer.borderWidth = 1.0
        
        self.distanceButton.layer.borderColor = AppColors.borderColor.cgColor
        self.likesButton.layer.borderColor = AppColors.borderColor.cgColor
        self.chatsButton.layer.borderColor = AppColors.borderColor.cgColor
        self.followersButton.layer.borderColor = AppColors.borderColor.cgColor
        self.viewesButton.layer.borderColor = AppColors.borderColor.cgColor
        self.dateButton.layer.borderColor = AppColors.borderColor.cgColor

        self.distanceButton.clipsToBounds = true
        self.likesButton.clipsToBounds = true
        self.chatsButton.clipsToBounds = true
        self.followersButton.clipsToBounds = true
        self.viewesButton.clipsToBounds = true
        self.dateButton.clipsToBounds = true
    }
    
    
    func displaySortingFilterValues(sortingType : String){
        
        
    switch sortingType{
        case "distance":
            printDebug(object: "")
            self.deselectRestOfTheSortingButtons(tappedButton: self.distanceButton)
        case "likes":
            printDebug(object: "likes")
            self.deselectRestOfTheSortingButtons(tappedButton: self.likesButton)
        case "chats":
                printDebug(object: "chats")
                self.deselectRestOfTheSortingButtons(tappedButton: self.chatsButton)
        case "followers":
                printDebug(object: "followers")
                self.deselectRestOfTheSortingButtons(tappedButton: self.followersButton)
        case "views":
            printDebug(object: "views")
            self.deselectRestOfTheSortingButtons(tappedButton: self.viewesButton)
        case "date":
            printDebug(object: "date")
            self.deselectRestOfTheSortingButtons(tappedButton: self.dateButton)
        default:
            printDebug(object: "wrong")
            self.deselectRestOfTheSortingButtons(tappedButton: UIButton())

        }
        
    }
    
    
    func setDefaultViewForGenderSelection(){
        self.maleButton.setImage(UIImage(named: "unchecked"), for: UIControlState.normal)
        self.femaleButton.setImage(UIImage(named: "unchecked"), for: UIControlState.normal)
        self.bothButton.setImage(UIImage(named: "checked"), for: UIControlState.normal)
    }
    
    
 
    func deselectRestOfTheSortingButtons(tappedButton : UIButton){
        
        switch tappedButton {
        case self.distanceButton:
            printDebug(object: "distance")
           
//        VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "distance" as AnyObject?

            self.sortBy = "distance"

            
            self.distanceButton.backgroundColor = AppColors.pinkColor;
            self.distanceButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.distanceButton.isSelected = false
            self.distanceButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)
            
            
            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.likesButton.isSelected = true
            
            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true
            
            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true
            
            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true
            
        case self.likesButton:
            printDebug(object: "like")
            
//            VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "likes" as AnyObject?

            
            self.sortBy = "likes"

            self.likesButton.backgroundColor = AppColors.pinkColor;
            self.likesButton.setTitleColor(UIColor.white, for: UIControlState.normal)
             self.likesButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)
            self.likesButton.isSelected = false
            
            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.distanceButton.isSelected = true
            
            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true
            
            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true
            
            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true
            
        case self.chatsButton:
            printDebug(object: "chats")
            
//            VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "chats" as AnyObject?

            self.sortBy = "chats"

            self.chatsButton.backgroundColor = AppColors.pinkColor;
            self.chatsButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = false
            
            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.likesButton.isSelected = true
            
            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.distanceButton.isSelected = true
            
            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true
            
            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true
            
        case self.followersButton:
            printDebug(object: "followers")
            
//            VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "followers" as AnyObject?

            self.sortBy = "followers"

            self.followersButton.backgroundColor = AppColors.pinkColor;
            self.followersButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = false
            
            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.likesButton.isSelected = true
            
            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true
            
            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.distanceButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true
            
            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true
            
        case self.viewesButton:
            printDebug(object: "views")
            
           // VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "views" as AnyObject?

            self.sortBy = "views"

            self.viewesButton.backgroundColor = AppColors.pinkColor;
            self.viewesButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = false
            
            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.likesButton.isSelected = true
            
            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true

            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true

            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.distanceButton.isSelected = true

            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true

        case self.dateButton:
            
        //VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "date" as AnyObject?

            self.sortBy = "date"

            self.dateButton.backgroundColor = AppColors.pinkColor;
            self.dateButton.setTitleColor(UIColor.white, for: UIControlState.normal)
            
            self.dateButton.setImage(UIImage(named: "whiteArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = false
            
            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.likesButton.isSelected = true

            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true

            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true

            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
             self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)
            self.distanceButton.isSelected = true

            
            printDebug(object: "date")
        default:
            printDebug(object: "wrong")
        
           // VKCTabBarControllar.sharedInstance.filterDict["sortBy"] = "" as AnyObject?
            
            self.sortBy = ""
            
            self.distanceButton.backgroundColor = UIColor.white
            self.distanceButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.distanceButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)
            self.distanceButton.isSelected = true

            self.likesButton.backgroundColor = UIColor.white
            self.likesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.likesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)
            self.likesButton.isSelected = true

            self.chatsButton.backgroundColor = UIColor.white
            self.chatsButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.chatsButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.chatsButton.isSelected = true
         
            self.followersButton.backgroundColor = UIColor.white
            self.followersButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.followersButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.followersButton.isSelected = true
            
            self.viewesButton.backgroundColor = UIColor.white
            self.viewesButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.viewesButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.viewesButton.isSelected = true
            
            self.dateButton.backgroundColor = UIColor.white
            self.dateButton.setTitleColor(AppColors.placeHolderColor, for: UIControlState.normal)
            self.dateButton.setImage(UIImage(named: "blackArrow"), for: UIControlState.normal)

            self.dateButton.isSelected = true
        }
    }
    
    
    func setGenderState(gender : String){
        switch gender {
        case "male":
            printDebug(object: "male")
            self.maleButton.setImage(   UIImage(named: "checked"), for: UIControlState.normal)
            self.femaleButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.bothButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.gender = "male"
        case "female":
            printDebug(object: "female")
            self.maleButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.femaleButton.setImage(   UIImage(named: "checked"), for: UIControlState.normal)
            self.bothButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.gender = "female"
        case "both":
            printDebug(object: "both")
            self.maleButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.femaleButton.setImage(   UIImage(named: "unckecked"), for: UIControlState.normal)
            self.bothButton.setImage(   UIImage(named: "checked"), for: UIControlState.normal)
            self.gender = "both"
        default:
            printDebug(object: "---")
        }
    }
    
}
