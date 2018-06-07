

import UIKit

class MyAccountVC : UIViewController {
    
    //MARK:- Variables
    //===================
    var tokenReceived : TokenReceivedVC!
    var tokenPurchased : TokenPurchasedVC!
    
    
    //MARK:- IBOutlets
    //===========================
    @IBOutlet weak var accountScrollView: UIScrollView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var tokenPurchasedButton: UIButton!
    @IBOutlet weak var tokenReceivedButton: UIButton!
    @IBOutlet weak var tabBacView: UIView!
    @IBOutlet weak var tokenReceivedHighLightView: UIView!
    @IBOutlet weak var tokenPurchasedHighlightView: UIView!
    @IBOutlet weak var numberOfTokensLabel: UILabel!
    
    @IBOutlet weak var accountButton: UIButton!
    
    
    //View life cycle
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.numberOfTokensLabel.text = self.tokenReceived.remainingTokens
    }
    
//MARK:- IBAction
//============
    @IBAction func tokenReceivedButtonTapped(_ sender: UIButton){
   
        self.accountScrollView.setContentOffset(CGPoint.zero, animated: true)
    }

    
    @IBAction func tokenPurchasedButtontapped(_ sender: UIButton) {
   
        
         self.accountScrollView.setContentOffset(CGPoint(x: screenWidth, y: 0), animated: true)
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        _ =
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func accountButtonTapped(_ sender: UIButton) {
        
        let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "GetHistoryID") as! GetHistoryVC
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK:- Private functions
//=============================
private extension MyAccountVC{
    
    func setUpSubView(){
        self.accountScrollView.delegate = self
        self.addTokenReceivedVC()
        self.addTokenPurchasedVC()
        self.accountScrollView.contentSize = CGSize(width: screenWidth * 2, height: screenHeight - 300)
        self.accountScrollView.isPagingEnabled = true
        self.tokenReceivedHighLightView.isHidden = false
        self.tokenPurchasedHighlightView.isHidden = true
       self.tokenReceivedButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
        self.tokenPurchasedButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
        self.numberOfTokensLabel.text = ""
        
        self.accountButton.layer.cornerRadius = 3.0
        self.accountButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.accountButton.layer.borderWidth = 1.0
        self.accountButton.clipsToBounds = true
        
        
//        if let tokens = CurentUser.tokenCount{
//             self.numberOfTokensLabel.text = tokens
//        }
    }
    
    
    //add followers vc
    //====================
    func addTokenReceivedVC(){
        self.tokenReceived = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "TokenReceivedID") as! TokenReceivedVC
        self.accountScrollView.frame = self.tokenReceived.view.frame
        self.accountScrollView.addSubview(self.tokenReceived.view)
        self.tokenReceived.willMove(toParentViewController: self)
        self.addChildViewController(self.tokenReceived)
        self.tokenReceived.view.frame.size.height = self.accountScrollView.frame.height
        self.tokenReceived.view.frame.origin = CGPoint.zero
    }
    
    //MARK:- add following vc
    //=====================
    func addTokenPurchasedVC(){
        self.tokenPurchased = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "TokenPurchasedID") as! TokenPurchasedVC
        self.accountScrollView.frame = self.tokenPurchased.view.frame
        self.accountScrollView.addSubview(self.tokenPurchased.view)
        self.tokenPurchased.willMove(toParentViewController: self)
        self.addChildViewController(self.tokenPurchased)
        self.tokenPurchased.view.frame.size.height = self.accountScrollView.frame.height
        self.tokenPurchased.view.frame.origin = CGPoint(x: screenWidth, y: 0)
    }
}


extension MyAccountVC : UIScrollViewDelegate{

    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    
        if scrollView.contentOffset == CGPoint.zero{
            self.tokenReceivedHighLightView.isHidden = false
            self.tokenPurchasedHighlightView.isHidden = true
            self.tokenReceivedButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            self.tokenPurchasedButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            
            printDebug(object: "purchased token is \(self.tokenReceived.remainingTokens)")
            
           self.numberOfTokensLabel.text = self.tokenReceived.remainingTokens
            
        }else{
            self.tokenReceivedHighLightView.isHidden = true
            self.tokenPurchasedHighlightView.isHidden = false
            self.tokenReceivedButton.setTitleColor(AppColors.lightGrey, for: UIControlState.normal)
            self.tokenPurchasedButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
            
            if let tok = CurentUser.tokenCount{
              
              self.numberOfTokensLabel.text = "\(CommonFunction.formatPoints(num: Double(tok)!))"
            
             //   self.numberOfTokensLabel.text = "\(CommonFunction.formatPoints(num: 10005007))"
                
            //    self.numberOfTokensLabel.text = "\(tok)"
            
            }
            
            
        }

    }

}
