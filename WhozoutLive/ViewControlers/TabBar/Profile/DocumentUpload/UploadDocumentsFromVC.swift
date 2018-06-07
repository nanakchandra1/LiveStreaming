

import UIKit

class UploadDocumentsFromVC: UIViewController {

    
    //Variables
    //==============
    
    let picker : UIImagePickerController = UIImagePickerController()
    
    //IBOutlets
    //===========
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var dropBoxButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var buttonBackview: UIView!
    @IBOutlet weak var galeryButton: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
  
    }
    
    
    func setUpSubView(){
        self.picker.delegate = self
        self.backView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
    }
    
    @IBAction func cancelButtontapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        CommonFunction.checkAndOpenCamera(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
    }

    
    @IBAction func galeryButtontapped(_ sender: UIButton) {
    
        CommonFunction.checkAndOpenLibrary(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
      
    }
    
    @IBAction func dropNoxButtontapped(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)

    }
    
}


extension UploadDocumentsFromVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        print(info)
        
        if mediaType == kUTTypeImage {
            
            self.picker.dismiss(animated: true, completion: {
                
                 if let _ = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    self.dismiss(animated: true, completion: nil)
                    
                    printDebug(object: "got image")
                    
                }
                
            })
            
        } else {
            
            print("Data not found.")
            
        }
        
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //        self.isFromEdit = true
        
        self.picker.dismiss(animated: true, completion: nil)
        
    }

    
}


