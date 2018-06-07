

import UIKit

class AgePopUpVC: UIViewController {

     var syncDelegate : SyncEmogies?
    
    @IBOutlet weak var yesButton: UIButton!
    @IBOutlet weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor =
    UIColor.black.withAlphaComponent(0.8)
        sharedAppdelegate.agePopUpShown = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    
    }
    
    @IBAction func yesButtontappe(_ sender: UIButton) {
        CommonFunction.removeChildVC(childVC: self)
        self.syncDelegate?.sync()
    }
    
    @IBAction func noButtonTapped(_ sender: UIButton) {
        CommonFunction.removeChildVC(childVC: self)
        exit(0)
    }
    
  }
