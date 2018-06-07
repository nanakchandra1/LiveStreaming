


import UIKit

class AboutAndpolicyVC : UIViewController {

    //MARK:- Variables
    //===================
    var urlToLoad : String!
    var heading : String!
    
    //MARK:- IBOutlets
    //====================
    @IBOutlet weak var headinglabel: UILabel!
    @IBOutlet weak var policyWebView: UIWebView!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        self.setUpSubView()
    
        //self.animateLikeRiver(xPos: Int(screenWidth) , yPos: 70)
        
    }
    
    
    
    @IBAction func closeButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)

    }

    func setUpSubView(){
        let pageUrl = URL(string : urlToLoad)
        
        self.policyWebView.loadRequest(URLRequest(url: pageUrl!))
        
        self.headinglabel.text = self.heading

    }
    
    

    
}
