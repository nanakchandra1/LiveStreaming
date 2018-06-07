
import UIKit
//import AVFoundation
//import AssetsLibrary
import Photos



class ProfileSetUpVC: BaseViewControler {
    
    //MARK:- variables
    //===================
    let picker : UIImagePickerController = UIImagePickerController()
    var gender = ""
    var tapImage : UITapGestureRecognizer!
    var profileImage: UIImage!
    
    //MARK:- IBOutlets
    //=========
    //@IBOutlet weak var maleButton: NSLayoutConstraint!
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var femaleLabel: UILabel!
    @IBOutlet weak var maleLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var skipButton: UIButton!
    
    //MARK:- view lifecycle
    //===================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func maleButtonTapped(_ sender: UIButton) {
        self.maleLabel.textColor = AppColors.blueColor
        self.femaleLabel.textColor = AppColors.placeHolderColor
        self.gender = "1"
         self.maleButton.setImage(UIImage(named: "maleSelected"), for: .normal)
         self.femaleButton.setImage(UIImage(named: "femaleGrey"), for: .normal)
    }
    
    
    @IBAction func femaleButtontapped(_ sender: UIButton) {
        
        self.maleLabel.textColor = AppColors.placeHolderColor
        self.femaleLabel.textColor = AppColors.femaleTextColor
        self.gender = "0"
        
        self.maleButton.setImage(UIImage(named: "maleGrey"), for: .normal)
       
        self.femaleButton.setImage(UIImage(named: "femaleSelected"), for: .normal)
    }
    
    
    @IBAction func uploadButtontapped(_ sender: UIButton) {
        //self.takeImageFromCameraGallery(fromViewController: self)
        
        self.selectType()
        
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        //
        //        if self.profileImage == nil && self.gender == ""{
        //            CommonFunction.showTsMessageError(message: "Please select gender or upload your profile pic")
        //        }else{
        //            self.uploadImageAndGender(userImage: self.profileImage)
        //        }
        self.uploadImageAndGender(userImage: self.profileImage)
    }
    
    
    @IBAction func skipButtonTapped(_ sender: UIButton) {
        
        //        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LandingID") as! LandingVC
        //        self.navigationController?.pushViewController(vc, animated: true)
        
        CommonFunction.pushToHome()
        
      
        
    }
    
    func tapOnImage(sender : UITapGestureRecognizer){
        self.selectType()
    }
    
    
    
    @IBAction func ProfileImageButtonTapped(_ sender: UIButton) {
        self.selectType()
    }
}


//MARK:- Private functions
//===========================
private extension ProfileSetUpVC {
    func setUpSubView(){
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
    }
}

//MARK:- UIImagePickerController & UINavigationController Delegate

extension ProfileSetUpVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func selectType() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Camera", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.checkAndOpenCamera(forTypes: ["\(kUTTypeImage)"])
            
        })
        
        let saveAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.checkAndOpenLibrary(forTypes: ["\(kUTTypeImage)"])
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(saveAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    
    private func checkAndOpenLibrary(forTypes: [String]) {
        
        self.picker.delegate = self
        
        self.picker.mediaTypes = forTypes
        
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if (status == .notDetermined) {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
            
            self.picker.sourceType = sourceType
            
            self.picker.allowsEditing = true

            navigationController!.present(self.picker, animated: true, completion: nil)
            
        }
            
        else {
            if status == .restricted {
                let alert = UIAlertController(title: "Error", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", preferredStyle: UIAlertControllerStyle.alert)
                let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
                    self.dismiss(animated: true, completion: nil)
                }
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                
                if status == .denied {
                    
                    
                    
                    let alert = UIAlertController(title: "Error", message: "Please change your privacy setting from the setting app and allow access to library for WhozoutLive", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (action) in
                        
                        UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                            
                            
                        })

                        
                    })
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    alert.addAction(settingsAction)
                    
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    if status == .authorized {
                        
                        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
                        
                        self.picker.sourceType = sourceType
                        
                        self.picker.allowsEditing = true
                        
                        self.navigationController!.present(self.picker, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    
    private func checkAndOpenCamera(forTypes: [String]) {
        
        self.picker.delegate = self
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authStatus == AVAuthorizationStatus.authorized {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                self.picker.sourceType = sourceType
                
                self.picker.mediaTypes = forTypes
                
                self.picker.allowsEditing = true
                
                if self.picker.sourceType == UIImagePickerControllerSourceType.camera {
                    
                    self.picker.showsCameraControls = true
                    
                }
                self.navigationController!.present(self.picker, animated: true, completion: nil)
                
            }
                
            else {
                
                //                dispatch_get_main_queue().asynchronously(execute: {
                //
                //                    //PKCommonClass.showTSMessageForError("Sorry! Camera not supported on this device")
                //
                //                })
                
            }
            
        }
            
        else {
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) in
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        if granted {
                            
                            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                            
                            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                                
                                self.picker.sourceType = sourceType
                                
                                if self.picker.sourceType == UIImagePickerControllerSourceType.camera {
                                    
                                    self.picker.showsCameraControls = true
                                    
                                }
                                
                                self.navigationController!.present(self.picker, animated: true, completion: nil)
                                
                            }
                                
                            else {
                                
                                
                                DispatchQueue.main.async(execute: {
                                    //PKCommonClass.showTSMessageForError("Sorry! Camera not supported on this device")
                                })
                                
                                
                            }
                            
                        }
                        
                    })
                    
                })
                
            }
                
            else {
                
                if authStatus == AVAuthorizationStatus.restricted {
                    
                    let alert = UIAlertController(title: "Error", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    alert.addAction(cancelAction)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                    
                else {
                    
                    let alert = UIAlertController(title: "Error", message: "Please change your privacy setting from the setting app and allow access to camera for WhozoutLive", preferredStyle: UIAlertControllerStyle.alert)
                    
                    let settingsAction = UIAlertAction(title: "Settings", style: UIAlertActionStyle.default, handler: { (action) in
                        
            
                UIApplication.shared.open(   URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                            
                            
                        })
                        
                        
                    })
                    
                    
                    
                    let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
                        
                        self.dismiss(animated: true, completion: nil)
                        
                    }
                    
                    
                    
                    alert.addAction(settingsAction)
                    
                    alert.addAction(cancelAction)
                    
                    
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
        }
        
    }
    
    
    
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        print("info is \(info)")
        
        if mediaType == kUTTypeImage {
            
            
            
            //self.isFromEdit = true
            
            
            
            self.picker.dismiss(animated: true, completion: {
                
                
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    self.profileImageView.image = image
                    
                    self.profileImage = image
                    
                    
                    // self.uploadProfilePic(image)
                    
                    
                    
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

//MARK:- webservice
//====================
extension ProfileSetUpVC{
    
    func uploadImageAndGender(userImage:UIImage?){
        
        
        let params : [String : AnyObject] = ["userid" : CurentUser.userId as AnyObject , "gender" : self.gender as AnyObject , "email" : CurentUser.email as AnyObject]
        
        printDebug(object: params)
        
        var imgData : NSData?
        
        if let img = userImage{
            imgData = UIImageJPEGRepresentation(img, 0.5) as NSData?
        }else{
            imgData = nil
        }
        
        printDebug(object: params)
        
        printDebug(object: imgData)
        CommonFunction.showLoader(vc: self)
        UserService.uploadImageApi(params: params, imageData: imgData as NSData?, imageKey: "userimg") { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                printDebug(object: data)
                
                
                //        let vc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LandingID") as! LandingVC
                //        self.navigationController?.pushViewController(vc, animated: true)
                
             //   CommonFunction.setTabBarToRoot()
                
                CommonFunction.pushToHome()

            }else{
                CommonFunction.hideLoader(vc: self)
            }
            CommonFunction.hideLoader(vc: self)
            
        }
        
    }
    
}

