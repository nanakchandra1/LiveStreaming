

import UIKit

class TutorialVC: BaseViewControler {
    
    //MARK:- Variables
    //===================
    var tutorial1:Tutorial1VC!
    var tutorial2:Tutorial2VC!
    var tutorial3:Tutorial3VC!
    
    //IBOutlets
    //===========
    @IBOutlet weak var tutorialPageControl: UIPageControl!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var tutorialScrollView: UIScrollView!
    @IBOutlet weak var scrollViewbackView: UIView!
    @IBOutlet weak var touchIdButton: UIButton!
    
    @IBOutlet weak var buttonBack: UIView!

    
    
    //MARK:- View life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupSubView()
        
    }
    
}

//MARK:- Private functions
//==========================
private extension TutorialVC {
//MARK:- set up your view
//=====================
    func setupSubView(){
        self.tutorialPageControl.currentPage = 0
        self.tutorialPageControl.numberOfPages = 3
        self.tutorialPageControl.isUserInteractionEnabled = false
        self.tutorialScrollView.delegate = self
        self.addTutorial1()
        self.addTutorial2()
        self.addTutorial3()
        self.tutorialScrollView.contentSize = CGSize(width: screenWidth * 3, height: self.view.frame.height - 195)
        printDebug(object: self.scrollViewbackView.frame.height)
        printDebug(object: self.view.frame.height)
        
        self.tutorialScrollView.setContentOffset( CGPoint(x: 0, y: 0), animated: true)
        self.tutorialScrollView.isPagingEnabled = true
        self.tutorialScrollView.showsVerticalScrollIndicator = false
        self.tutorialScrollView.showsHorizontalScrollIndicator = false
        self.tutorialScrollView.bounces = false
        self.tutorialPageControl.backgroundColor = UIColor.clear
        self.tutorialPageControl.currentPageIndicatorTintColor = AppColors.pinkColor
        self.tutorialPageControl.pageIndicatorTintColor = AppColors.seperatorGreyColor
        self.buttonBack.backgroundColor = UIColor.black.withAlphaComponent(0.6)
    }
    
//MARK:- Add first tutorial
//=========================
    func addTutorial1(){
        self.tutorial1 = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "Tutorial1ID") as! Tutorial1VC
        self.tutorialScrollView.frame = self.tutorial1.view.frame
        self.tutorialScrollView.addSubview(self.tutorial1.view)
        self.tutorial1.willMove(toParentViewController: self)
        self.addChildViewController(self.tutorial1)
        self.tutorial1.view.frame.size.height = self.tutorialScrollView.frame.height
        self.tutorial1.view.frame.origin = CGPoint.zero
    }
    
    //MARK:- Add second tutorial
    //=========================
    func addTutorial2(){
        
        self.tutorial2 = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "Tutorial2ID") as! Tutorial2VC
        self.tutorialScrollView.frame = self.tutorial2.view.frame
        self.tutorialScrollView.addSubview(self.tutorial2.view)
        self.tutorial2.willMove(toParentViewController: self)
        self.addChildViewController(self.tutorial2)
        self.tutorial2.view.frame.size.height = self.tutorialScrollView.frame.height
        self.tutorial2.view.frame.origin = CGPoint(x: screenWidth, y: 0)
        
    }
    
    //MARK:- Add third tutorial
    //=========================
    func addTutorial3(){
        self.tutorial3 = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "Tutorial3ID") as! Tutorial3VC
        self.tutorialScrollView.frame = self.tutorial3.view.frame
        self.tutorialScrollView.addSubview(self.tutorial3.view)
        self.tutorial3.willMove(toParentViewController: self)
        self.addChildViewController(self.tutorial3)
        self.tutorial3.view.frame.size.height = self.tutorialScrollView.frame.height
        self.tutorial3.view.frame.origin = CGPoint(x: screenWidth * 2, y: 0)
    }
}

//MARK:- Actions
//==============
extension TutorialVC{
    @IBAction func loginButtonTappped(_ sender: UIButton) {
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginID") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "SignUpID") as! SignUpVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func loginWithTouchIdTapped(_ sender: UIButton) {
        let vc =  StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginWithTouchIdID") as! LoginWithTouchIdVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- scroll view delegates
//==============================
extension TutorialVC : UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset == CGPoint(x: 0.0, y: 0.0){
            self.tutorialPageControl.currentPage = 0
        }else if scrollView.contentOffset == CGPoint(x: screenWidth, y: 0){
            self.tutorialPageControl.currentPage = 1
        }else if scrollView.contentOffset == CGPoint(x: screenWidth * 2, y: 0){
            self.tutorialPageControl.currentPage = 2
        }
    }
}



