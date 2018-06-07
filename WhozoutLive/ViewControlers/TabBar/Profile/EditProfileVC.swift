

import UIKit
import Photos


class EditProfileVC: UIViewController {

    //MARK:- Variables
    //=================
  //  var headings = ["EMAIL ID","AGE","GENDER","","SAVED IMAGES","IMAGES"]
    var icons = ["emailIcon","ageIcon","genderIcon",""]
    var profileData : ProfileData!
    var getBackDelegate : GetProfileDataBack!
    let picker : UIImagePickerController = UIImagePickerController()
    var screenname = ""
    var bio = ""
    var isPicAvail = ""
    
    //MARK:- IBOutlets
    //==================
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var editProfileTableView: UITableView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    //@IBOutlet weak var screenNameTextField: UITextField!
    @IBOutlet weak var editImageButton: UIButton!
    @IBOutlet weak var profileImageBackView: UIView!
  //  @IBOutlet weak var doneButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtontapped(_ sender: UIButton) {
       
    _ = self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func doneButtontapped(_ sender: UIButton) {
        
       self.editProfileService()
    }
 
    
    @IBAction func editImageButtonTapped(_ sender: UIButton) {
        
        self.selectType()
    }
}


private extension EditProfileVC{
    
    func setUpSubView(){
        //self.screenNameTextField.text = self.profileData.username
        self.editProfileTableView.delegate = self
        self.editProfileTableView.dataSource = self
       // self.screenNameTextField.delegate = self
        self.editProfileTableView.backgroundColor = UIColor.white
        self.profileImageBackView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        
         self.profileImageView.setImageWithStringURL(URL: self.profileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder")!)
        self.screenname = self.profileData.username!
        self.bio = self.profileData.bio!
        
        if self.isPicAvail == "1"{
            self.profileImageView.contentMode = .scaleToFill
        }else{
            self.profileImageView.contentMode = .center
        }
    }
}

//MARK:- Table view delegate and datasource
//=============================================
extension EditProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.row == 3{
            return 60
        }else{
            return 56
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    let cell = tableView.dequeueReusableCell(withIdentifier: "editProfileCell") as! EditProfileCell
        
        cell.showHideControls(row: indexPath.row)
        cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
        switch indexPath.row {
        case 0:
            
            cell.editProfileTextField.delegate = self
            cell.editProfileTextField.text = self.profileData.username
            cell.detailheadingLabel.text = "SCREENNAME"
        case 1:
            cell.bioTextView.delegate = self
            cell.bioTextView.text = self.profileData.bio
        
        default:
            fatalError("Unknown cell")
        }
        
    return cell
    
    }
}


extension EditProfileVC : UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        
         //CommonFunction.delay(delay: 0.1) {
        
            let  char = string.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
        
        if string == " " && range.location == 0{
        
            return false
      
        }else if (textField.text?.characters.count)! == 50 && isBackSpace != -92{

                return false
            }else{
                
               //self.profileData.username = textField.text
            CommonFunction.delay(delay:0.1){
                self.screenname = textField.text!
                self.profileData.username = textField.text!
                return true
            }

            
            
               // self.screenName = textField.text

                return true
            }

       // }
        
    }
}



extension EditProfileVC : UITextViewDelegate{
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        
       // CommonFunction.delay(delay: 0.1) {
            
            let  char = text.cString(using: String.Encoding.utf8)!
            let isBackSpace = strcmp(char, "\\b")
        
        if text == " " && range.location == 0{
            
            return false
            
        }else if (textView.text?.characters.count)! == 50 && isBackSpace != -92{
                return false
            }else{
             //   self.profileData.bio = textView.text
            CommonFunction.delay(delay:0.1){

                self.bio = textView.text
                self.profileData.bio = textView.text

                return true

            }
                return true
            }


       // }
        
       // return true
    }
    
}


//MARK:- Webservices
//=====================
extension EditProfileVC{
    
    func editProfileService(){
        
        let params : jsonDictionary = ["userid" : CurentUser.userId! as AnyObject,"bio" : self.bio as AnyObject,"username" :  self.screenname as AnyObject]
        printDebug(object: params)
        CommonFunction.showLoader(vc: self)

        UserService.editProfileApi(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                self.profileData.username = self.screenname
                
                self.profileData.bio = self.bio
                
                self.getBackDelegate.getDataBack(profileData: self.profileData)
               _ = self.navigationController?.popViewController(animated: true)
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        
        }
        
    }
    
    func uploadImageAndGender(userImage:UIImage?){
        
        let params : jsonDictionary = ["userid" : CurentUser.userId as AnyObject , "gender" : CurentUser.gender as AnyObject , "email" : CurentUser.email as AnyObject]
        
        printDebug(object: params)
        
        var imgData : NSData?
        
        if let img = userImage{
            imgData = UIImageJPEGRepresentation(img, 0.5) as NSData?
        }else{
            imgData = nil
        }
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.uploadImageApi(params: params, imageData: imgData as NSData?, imageKey: "userimg") { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
           
                printDebug(object: ".........\(String(describing: data))")
                
            self.profileData.userImage = data?["image"] as? String
                self.getBackDelegate.getProfilePicBack(imgUrl: self.profileData.userImage!)
               // _ = self.navigationController?.popViewController(animated: true)
            }else{
                CommonFunction.hideLoader(vc: self)
            }
            CommonFunction.hideLoader(vc: self)
            
        }
        
    }
}


//MARK:- UIImagePickerController & UINavigationController Delegate

extension EditProfileVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    
    
    func selectType() {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        self.picker.allowsEditing = true
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
            
            navigationController!.present(self.picker, animated: true, completion: nil)
            
        }
            
        else {
            if status == .restricted {
          
                _ = VKCAlertController.alert(title: "Error", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", buttons: ["Cancel"], tapBlock: { (_, index) in
                    
                    
                })
                
                
            }
            else {
                
                if status == .denied {
                    
                    _ = VKCAlertController.alert(title: "Error", message: "Please change your privacy setting from the setting app and allow access to library for WhozoutLive.", buttons: ["Settings","Cancel"], tapBlock: { (_, index) in
                        
                        if index == 0{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                                
                            })

                        }
                        
                    })
                    
                    
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
                    
                    _ = VKCAlertController.alert(title: "Error", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", buttons: ["Cancel"], tapBlock: { (_, index) in
                        
                    })
                    
                }
                    
                else {
                    
                    _ = VKCAlertController.alert(title: "Error", message: "Please change your privacy setting from the setting app and allow access to camera for WhozoutLive", buttons: ["Settings","Cancel"], tapBlock: { (_, index) in
                        
                        if index == 0{
                         
                            
                         
                UIApplication.shared.open(   URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                                
                    })
                            
                }
                        
            })
                    
               }
                
            }
            
        }
        
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        print(info)
        
        if mediaType == kUTTypeImage {
            
            self.picker.dismiss(animated: true, completion: {
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    self.profileImageView.contentMode = .scaleToFill

                    
                    self.profileImageView.image = image
                    
                  //  self.profileImage = image
                    
                    
                    self.uploadImageAndGender(userImage:image)
                    
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

class EditProfileCell : UITableViewCell{
    
    @IBOutlet weak var bioTextView: UITextView!
    @IBOutlet weak var detailheadingLabel: UILabel!
    @IBOutlet weak var editProfileTextField: UITextField!
    @IBOutlet weak var dataImageView: UIImageView!
    @IBOutlet weak var seperatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
       // self.editProfileTextField.isUserInteractionEnabled = false
        self.bioTextView.layer.borderWidth = 1.0
        self.bioTextView.layer.borderColor = AppColors.placeHolderColor.cgColor
    }
    
    //MARK:- Hide show cell controls
    //================================
    func showHideControls(row:Int){
        if row == 1{
            self.bioTextView.isHidden = false
            self.detailheadingLabel.isHidden = true
            self.editProfileTextField.isHidden = true
            self.dataImageView.isHidden = true
            self.seperatorView.isHidden = true
        }else{
            self.bioTextView.isHidden = true
            self.detailheadingLabel.isHidden = false
            self.editProfileTextField.isHidden = false
            self.dataImageView.isHidden = false
            self.seperatorView.isHidden = false
        }
    }
}
