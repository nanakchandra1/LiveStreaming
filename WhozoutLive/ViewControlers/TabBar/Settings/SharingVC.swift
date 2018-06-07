

import UIKit


protocol SharingDelegate{
    
    func isInstagram(isInstagram:Bool)
    
}


class SharingVC: UIViewController {

    
    var sharing : SharingDelegate?
    
    @IBOutlet weak var instagramButton: UIButton!
    @IBOutlet weak var othersButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var backView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
          }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
       
        
    }
    
    
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        
        self.view.removeFromSuperview()

        
    }

    @IBAction func othersButtonTapped(_ sender: UIButton) {
        
        
        self.view.removeFromSuperview()
        self.sharing?.isInstagram(isInstagram: false)
 
    }
    
    
    
    @IBAction func instagramButtonTapped(_ sender: UIButton) {
        self.sharing?.isInstagram(isInstagram: true)

        self.view.removeFromSuperview()
        
    }
    
    
    
}


extension SharingVC{
    
    func setUpSubView(){
        
        self.backView.backgroundColor =
            UIColor.black.withAlphaComponent(0.8)

        self.instagramButton.layer.cornerRadius = 3.0
        self.othersButton.layer.cornerRadius = 3.0
        self.instagramButton.clipsToBounds = true
        self.othersButton.clipsToBounds = true
    }
    
}




