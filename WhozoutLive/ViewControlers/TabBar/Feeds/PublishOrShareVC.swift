




import UIKit


protocol PublishStreamWithData {
    
    func publish(data:jsonDictionary)
}

class PublishOrShareVC : UIViewController {

    var documentController: UIDocumentInteractionController!
    var streamingdata : jsonDictionary!
    var publishDelegate : PublishStreamWithData?
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var publishButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    
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
    
    @IBAction func shareButtontapped(_ sender: UIButton) {
     
             self.shareOnInstaGram(image: UIImage(named: "logo")!)
    }
    
    @IBAction func publishButtonTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.view.removeFromSuperview()

        }
        
        self.publishDelegate?.publish(data: self.streamingdata)
        
    }
    
}


private extension PublishOrShareVC{
    func setUpSubView(){
        self.publishButton.layer.cornerRadius = 3
        self.publishButton.layer.borderWidth = 1.0
        self.publishButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.publishButton.clipsToBounds = true
        self.shareButton.layer.cornerRadius = 3
        self.shareButton.layer.borderWidth = 1.0
        self.shareButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.shareButton.clipsToBounds = true
        self.backView.backgroundColor =
            UIColor.black.withAlphaComponent(0.8)
        self.view.backgroundColor = UIColor.clear
    }
}


extension PublishOrShareVC : UIDocumentInteractionControllerDelegate{
    
    func shareOnInstaGram(image:UIImage){
        
        let imgData:Data = UIImageJPEGRepresentation(image,1)!
        
        let instagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(instagramURL!)) {
            
            let captionString = "Share"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            
            do {
                
                try imgData.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL)
                
                self.documentController.delegate = self
                
                self.documentController.uti = "com.instagram.exclusivegram"
                
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                
                self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                
            } catch {
                printDebug(object: "catch block")
            }
            
            
        } else {
            print(" Instagram is not installed ")
        }
    }
}



