

import UIKit

class AccountApprovedOrRejectedPopUpVC: UIViewController {

    var message : String = ""
    
    
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var okButton: UIButton!
    @IBOutlet weak var messageLabel: UILabel!
    
    
    override func viewDidLoad() {
       super.viewDidLoad()

        self.setUpSubView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func okButtontapped(_ sender: UIButton) {
        
        self.view.removeFromSuperview()
        
    }
    
}


private extension AccountApprovedOrRejectedPopUpVC{
    
    func setUpSubView(){
        self.backView.backgroundColor =  UIColor.black.withAlphaComponent(0.8)
        self.messageLabel.text = self.message
        
    }
    
}
