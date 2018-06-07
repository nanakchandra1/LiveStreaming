
import UIKit


class PurchasemoreTokenVC : UIViewController {
    
    // var navigateToPlayerdelegate : NavigateVideoPlayer?
    var purchaseFrom = PurchaseFrom.None
    
    
    
    //MARK:- IBOutlets
    //==================
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var sureButtontapped: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    
    var message : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func notNowButtonTapped(_ sender: UIButton) {
        
        CommonFunction.removeChildVC(childVC: self)
        
        
        if self.purchaseFrom == .WatchingVideo{
            sharedAppdelegate.parentNavigationController.popViewController(animated: true)
        }

    }
    
    @IBAction func sharebuttonTapped(_ sender: UIButton) {
        
        CommonFunction.removeChildVC(childVC: self)
        //    self.navigateToPlayerdelegate?.openPurchaseToken()
        
        if self.purchaseFrom == .Feed{
            CommonWebService.sharedInstance.addChildPurchaseToken()
            
        }else if self.purchaseFrom == .WatchingVideo{
            CommonWebService.sharedInstance.pushPurchaseToken(from: .WatchingVideo)
            
        }else{
            CommonWebService.sharedInstance.pushPurchaseToken(from: .EmogieKeyBoard)
        }
    }
}

extension PurchasemoreTokenVC{
    
    func setUpSubview(){
        
        self.messageLabel.text = self.message
        
        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    }
    
}

