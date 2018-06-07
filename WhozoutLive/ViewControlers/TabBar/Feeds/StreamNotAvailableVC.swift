

import UIKit

class StreamNotAvailableVC: UIViewController {

    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func okButtonTapped(_ sender: UIButton) {
        
        
    CommonFunction.removeChildVC(childVC: self)
        
    }
 

}
