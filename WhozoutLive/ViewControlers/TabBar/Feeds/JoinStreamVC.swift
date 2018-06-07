

import UIKit

protocol JoinStream {
    
    func join()
    
    func joining(feedid:String,vcObj:UIViewController)
}

class JoinStreamVC: UIViewController {

    @IBOutlet weak var sureButton: UIButton!
    @IBOutlet weak var notNowButton: UIButton!
    @IBOutlet weak var tokenlabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var streamTypeLabel: UILabel!
    
    var joinDelegate : JoinStream?
    var price : String!
    var streamType : String = "0"
    var vcObj : UIViewController?
    var feedId : String = ""
    //MARK:- View life cycle
    //==============
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubView()
        
        self.tokenlabel.text = self.price
        
        if self.streamType == "1"{
            self.streamTypeLabel.text = "Tokens per broadcast"
        }else{
            self.streamTypeLabel.text = "Tokens per minute"

        }
        
    }

  
    
    @IBAction func notNowButtontapped(_ sender: UIButton){
    
         CommonFunction.removeChildVC(childVC: self)
    
    }
    
    
    
    @IBAction func sureButtonTapped(_ sender: UIButton) {
       // self.joinDelegate?.join()
        
        self.joinDelegate?.joining(feedid: self.feedId, vcObj: self.vcObj!)
        
         CommonFunction.removeChildVC(childVC: self)
        
    }
    
}


private extension JoinStreamVC{
  
    func setUpSubView(){
        
        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        
    }
}
