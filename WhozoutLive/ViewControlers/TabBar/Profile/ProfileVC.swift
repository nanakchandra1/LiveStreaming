
import UIKit
import Photos

protocol GetProfileDataBack {
    
    func getDataBack(profileData : ProfileData)
    
    func getProfilePicBack(imgUrl : String)
    
}


enum MyProfileFrom{
    case Notification
    case FromOther
    case None
}

class ProfileVC: UIViewController {
    
    var headings = ["FULL NAME","EMAIL ID","AGE","GENDER","","SAVED IMAGES","IMAGES"]
    var icons = ["fullName","emailIcon","ageIcon","genderIcon",""]
    var profileData : ProfileData!
    var rowIndex : Int!
    let picker : UIImagePickerController = UIImagePickerController()
    var profileFrom = MyProfileFrom.None
    var documentController: UIDocumentInteractionController!

    
    //IBOutlets
    //===============
    @IBOutlet weak var sharebutton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var visibilityTypelabel: UILabel!
    @IBOutlet weak var visibilitylabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var documentUploadButton: UIButton!
    @IBOutlet weak var profileimageBackView: UIView!
    @IBOutlet weak var tokenLeftButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    //MARK:- View life cycle
    //=========================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.setButtontitle()
        
        if Networking.isConnectedToNetwork{
         self.getMyProfile()
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
        if let tokens = CurentUser.tokenCount{
            let tokenInPoints = "\(CommonFunction.formatPoints(num: Double(tokens)!))"

            self.tokenLeftButton.setTitle("\(tokenInPoints) Tokens Left", for: UIControlState.normal)
        }
        
        if self.profileFrom == .Notification{
            self.backButton.isHidden = false
            self.tokenLeftButton.isHidden = true
        }else{
            self.backButton.isHidden = true
            self.tokenLeftButton.isHidden = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    
    @IBAction func editProfileButtonTapped(_ sender: UIButton){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "editProfileID") as! EditProfileVC
        vc.profileData = self.profileData
        vc.isPicAvail = self.profileData.isProfilePicAvailable!
        vc.getBackDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func shareButtonTapped(_ sender: UIButton) {
        
     CommonFunction.shareWithSocialMedia(message: self.profileData.shareUrl! ,vcObj:self)
        
//        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SharingID") as! SharingVC
//        vc.sharing = self
//        CommonFunction.addChildVC(childVC: vc,parentVC: sharedAppdelegate.tabBar)
        

    }
    
    @IBAction func toggleSwitchTapped(_ sender: UISwitch) {
        
        self.profileTypeService()
    }
    
    
    @IBAction func documentUploadButtontapped(_ sender: UIButton) {
        let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "GetVerifiedID") as! GetVerifiedVC
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    @IBAction func tokenLeftButtonTapped(_ sender: UIButton) {
        
        if Networking.isConnectedToNetwork{
            CommonWebService.sharedInstance.pushPurchaseToken(from: PurchaseFrom.TokenLessButton)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
        
    }
    
    
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        
    }
    
}

private extension ProfileVC{
    
    func setUpSubview(){
        self.profileTableView.estimatedRowHeight = 100
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        self.documentUploadButton.isHidden = true
        //self.profileimageBackView.isHidden = true
        self.documentUploadButton.titleLabel?.numberOfLines = 2
        self.documentUploadButton.titleLabel?.textAlignment = .center
        self.documentUploadButton.titleLabel?.lineBreakMode = .byWordWrapping
        self.profileimageBackView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
        printDebug(object: CurentUser.docUpload!)
        self.tokenLeftButton.layer.borderWidth = 1.0
        self.tokenLeftButton.layer.borderColor = AppColors.pinkColor.cgColor
        self.tokenLeftButton.layer.cornerRadius = 3.0
        self.documentUploadButton.layer.cornerRadius = 3.0
        self.documentUploadButton.clipsToBounds = true
        self.setButtontitle()
        //self.getMyProfile()
    }
    
    func setButtontitle(){
        
        if CurentUser.docUpload! == "5"{
            
            self.documentUploadButton.setTitle("BECOME A VERIFIED" + "\n" + "MEMBER & RECEIVE CASH", for: UIControlState.normal)
            self.documentUploadButton.isEnabled = true
            
        }else  if CurentUser.docUpload! == "4"{
            
            self.documentUploadButton.setTitle("PENDING APPROVAL", for: UIControlState.normal)
            self.documentUploadButton.isEnabled = false
            
        }else  if CurentUser.docUpload! == "3"{
            
            self.documentUploadButton.setTitle("VERIFICATION INCOMPLETE", for: UIControlState.normal)
            self.documentUploadButton.isEnabled = true
            
        }else  if CurentUser.docUpload! == "2"{
            
            self.documentUploadButton.setTitle("NOT APPROVED", for: UIControlState.normal)
            
            self.documentUploadButton.isEnabled = true
            
        }else  if CurentUser.docUpload!  == "1"{
            
            self.documentUploadButton.setTitle("RESUBMIT, VERIFY YOUR" + "\n" + "EMAIL FOR MORE INFORMATION", for: UIControlState.normal)
            self.documentUploadButton.isEnabled = true
            
        }
        
    }
    
    //MARK:- save doc upload status to user defaults
    //==================================================
    func saveDocUploadStatus(){
        
        AppUserDefaults.save(value : self.profileData.docUpload ?? "" , forKey:AppUserDefaults.Key.DocUpload)
        
        AppUserDefaults.save(value: self.profileData.taxDocument ?? "",forKey:AppUserDefaults.Key.TaxDocument)
        
        AppUserDefaults.save(value: self.profileData.taxDocumentStatus ?? ""  , forKey:AppUserDefaults.Key.TaxDocumentStatus)
        
        AppUserDefaults.save(value: self.profileData.identityProofSelfieStatus ?? "" , forKey:AppUserDefaults.Key.IdentityProofSelfieStatus)
        
        AppUserDefaults.save(value: self.profileData.identityProofSelfie ?? "", forKey:AppUserDefaults.Key.IdentityProofSelfie)
        
        AppUserDefaults.save(value: self.profileData.identityProofFrontStatus ?? "", forKey:AppUserDefaults.Key.IdentityProofFrontStatus)
        
        AppUserDefaults.save(value: self.profileData.identityProofFront ?? "", forKey:AppUserDefaults.Key.IdentityProofFront)
        
        AppUserDefaults.save(value: self.profileData.identityProofBackStatus ?? "", forKey:AppUserDefaults.Key.IdentityProofBackStatus)
        
        AppUserDefaults.save(value: self.profileData.identityProofBack ?? "", forKey:AppUserDefaults.Key.IdentityProofBack)
        
    }
    
}

//MARK:- Table view delegate and datasource
//=============================================
extension ProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row{
            
        case 0,1,2,3:
            return 50
        case 4:
            return UITableViewAutomaticDimension
        case 5,6:
            return screenWidth / 4 + 42
        default:
            fatalError("wrong cell")
        }
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0))
        backView.backgroundColor = UIColor.white
        return backView
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row{
            
            case 0:
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: true)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            cell.dataValuelabel.text = self.profileData.name ?? ""
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: true)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            cell.dataValuelabel.text = self.profileData.email ?? ""
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: true)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            cell.dataValuelabel.text = CommonFunction.getAgeFromTimeStamp(timeStampString: self.profileData.dob!).replacingOccurrences(of: "y", with: "")
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: true)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            
            if self.profileData.gender == "1"{
                cell.dataValuelabel.text = "Male"
            }else{
                cell.dataValuelabel.text = "Female"
            }
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: true)
            cell.descriptionlabel.text = self.profileData.bio
            
            return cell
            
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedimagesCell") as! SavedimagesCell
            
            if (self.profileData.savedImages?.count)! > 4{
                cell.viewAllButton.isHidden = false
            }else{
                cell.viewAllButton.isHidden = true
                
            }
            
            if (self.profileData.savedImages?.count)! > 0{
                cell.noImageLbl.isHidden = true
                cell.savedImagesCollectionView.isHidden = false
            }else{
                cell.noImageLbl.isHidden = false
                cell.savedImagesCollectionView.isHidden = true
                
            }
            
            cell.savedImagesCollectionView.tag = 123456
            
            cell.savedImagesCollectionView.delegate = self
            cell.savedImagesCollectionView.dataSource = self
            
            cell.savedImagesCollectionView.reloadData()
            
            cell.imageTypeLabel.text = self.headings[indexPath.row]
            
            cell.viewAllButton.addTarget(self, action: #selector(ProfileVC.viewAllButtontapped), for: UIControlEvents.touchUpInside)
            
            return cell
            
        case 6:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedimagesCell") as! SavedimagesCell
            
            if (self.profileData.userImages?.count)! > 4{
                cell.viewAllButton.isHidden = false
            }else{
                cell.viewAllButton.isHidden = true
                
            }
            
            //            if (self.profileData.savedImages?.count)! > 0{
            //                cell.noImageLbl.isHidden = true
            //                cell.savedImagesCollectionView.isHidden = false
            //            }else{
            //                cell.noImageLbl.isHidden = false
            //                cell.savedImagesCollectionView.isHidden = true
            //
            //            }
            
            cell.noImageLbl.isHidden = true
            
            cell.savedImagesCollectionView.tag = 1234567
            
            cell.savedImagesCollectionView.delegate = self
            cell.savedImagesCollectionView.dataSource = self
            
            
            cell.savedImagesCollectionView.reloadData()
            
            cell.imageTypeLabel.text = self.headings[indexPath.row]
            
            
            cell.viewAllButton.addTarget(self, action: #selector(ProfileVC.viewAllButtontapped), for: UIControlEvents.touchUpInside)
            return cell
        default:
            fatalError("")
        }
    }
    
    func viewAllButtontapped(sender:UIButton){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SavedImagesID") as! SavedImagesVC
        vc.userId = CurentUser.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

//MARK:- collection view datasource and delegate
//================================================
extension ProfileVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let cell = self.profileTableView.dequeueReusableCell(withIdentifier: "savedimagesCell") as? SavedimagesCell else{
            fatalError("no cell found")
        }
        
        let indx = cell.tableViewIndexPath(tableView: self.profileTableView)
        
        printDebug(object: indx?.row)
        
        if collectionView.tag == 123456{
            
            return (self.profileData.savedImages?.count)!
            
        }else{
            
            if (self.profileData.userImages?.count)! <= 3{
                return (self.profileData.userImages?.count)! + 1
                
            }else{
                return 4
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth / 4) - 10 , height: screenWidth / 4 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      
    
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "savedImageCollectionViewCell", for: indexPath) as! SavedImageCollectionViewCell
        
        if collectionView.tag == 123456{
            
            cell.savedImageview.setImageWithStringURL(URL: (self.profileData.savedImages?[indexPath.row].imageUrl)!, placeholder: UIImage(named : "pramotionalPlaceholder")!)
            cell.savedImageview.contentMode = .scaleToFill
            
        }else{
            
            if (self.profileData.userImages?.count)! <= 3{
                
                if indexPath.row == self.profileData.userImages?.count{
                    cell.savedImageview.image = UIImage(named: "ic_profile_add")
                    cell.savedImageview.contentMode = .center
                }else{
                    
                cell.savedImageview.setImageWithStringURL(URL: (self.profileData.userImages?[indexPath.row].imageUrl)!, placeholder: UIImage(named : "pramotionalPlaceholder")!)
                    cell.savedImageview.contentMode = .scaleToFill
                }
            }else{
                
                if indexPath.row == 3{
                    cell.savedImageview.image = UIImage(named: "ic_profile_add")
                    cell.savedImageview.contentMode = .center
                }else{
                    
                    cell.savedImageview.setImageWithStringURL(URL: (self.profileData.userImages?[indexPath.row].imageUrl)!, placeholder: UIImage(named : "pramotionalPlaceholder")!)
                    cell.savedImageview.contentMode = .scaleToFill
                }
            }
        }
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let index = collectionView.tableViewIndexPath(tableView: self.profileTableView) else{
            return
        }
        
        if index.row == 6 && indexPath.row == self.profileData.userImages?.count{
            
            self.selectType()
            
        }else{
            
            if index.row == 6 && indexPath.row == 3{
                self.selectType()
                
            }
            
           else if index.row == 5{
                
                let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as! ImagecommentVC
                
                printDebug(object: "index.row...\(index.row)")
                
                printDebug(object: "indexPath.row...\(indexPath.row)")
          
                
                
                vc.imgUrl = self.profileData.savedImages?[indexPath.row].imageUrl
                
                vc.ImgId = self.profileData.savedImages?[indexPath.row].imageId
                
                sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
                
            }else{
                
                let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as! ImagecommentVC
                //vc.imgUrl = self.profileData.userImages?[indexPath.row].imageUrl
                vc.ImgId = self.profileData.userImages?[indexPath.row].imageId
                sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
            }
        }
    }
}



extension ProfileVC : UIDocumentInteractionControllerDelegate{
    
    func shareOnInstaGram(image:UIImage){
        
       let imgData:Data = UIImageJPEGRepresentation(image,1)!
       let instagramURL = URL(string: "instagram://app")
        
        if (UIApplication.shared.canOpenURL(instagramURL!)) {
            
            let captionString = "caption"
            
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


extension ProfileVC : SharingDelegate{
    
    func isInstagram(isInstagram:Bool){
        
        if isInstagram{
            printDebug(object: "share on instagram")
            // CommonFunction.shareOnInstaGram(image: UIImage(named:"emogie")!, vcObj: self)
            
            if self.profileData.userImage != ""{
                 self.shareOnInstaGram(image: self.profileImageView.image!)
            }else{
                 self.shareOnInstaGram(image: UIImage(named: "logo")!)
            }
            
        }else{
            printDebug(object: "share on other")
            CommonFunction.shareWithSocialMedia(message: "https://tinyurl.com/lt428vx", vcObj: self)
        }
        
    }
    
}



extension ProfileVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
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
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                                
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
                    
                    self.profileImageView.image = image
                    
                    self.uploadNewImageService(userImage: image)
                    
                    //  self.profileImage = image
                    
                    
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

extension ProfileVC : GetProfileDataBack{
    
    func getDataBack(profileData : ProfileData){
        self.profileData = profileData
        self.namelabel.text = self.profileData.username
        self.profileImageView.setImageWithStringURL(URL: self.profileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder2")!)
        self.profileTableView.reloadData()
    }
    
    func getProfilePicBack(imgUrl : String){
        self.profileData.userImage = imgUrl
        self.profileImageView.setImageWithStringURL(URL: self.profileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder2")!)
        self.profileImageView.contentMode = .scaleToFill
        
    }
}


//MRK:- Webservices
//====================
extension ProfileVC{
    
    func getMyProfile(){
        let params : jsonDictionary = ["userid" : CurentUser.userId as AnyObject]
        
        print(params)
        self.documentUploadButton.isHidden = true
        //self.profileimageBackView.isHidden = true
        CommonFunction.showLoader(vc: self)

        UserService.myProfileApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                self.documentUploadButton.isHidden = false
                self.profileimageBackView.isHidden = false
                
                if let data = data{
                    
                    printDebug(object: data)
                    
                    self.profileData = data
                    
//                    if self.profileData.isProfilePicAvailable == "1"{
//                        self.profileImageView.contentMode = .scaleToFill
//                    }else{
//                        self.profileImageView.contentMode = .center
//                    }
                    
                self.profileImageView.setImageWithStringURL(URL: self.profileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder2")!)
                    
                    self.namelabel.text = self.profileData.username
                    
                    if self.profileData.profileType == "1"{
                        self.visibilitySwitch.isOn = true
                        self.visibilityTypelabel.text = "Public"
                    }else{
                        self.visibilitySwitch.isOn = false
                        self.visibilityTypelabel.text = "Private"

                    }
                    
                    self.saveDocUploadStatus()
                    
                    self.setButtontitle()
                    
                    self.profileTableView.delegate = self
                    self.profileTableView.dataSource = self
                    self.profileTableView.reloadData()
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
            
        }
        
    }
    

    func uploadNewImageService(userImage:UIImage?){
        
        let params : jsonDictionary = ["userid" : CurentUser.userId as AnyObject]
        
        var imgData : NSData?
        
        if let img = userImage{
            imgData = UIImageJPEGRepresentation(img, 0.5) as NSData?
        }
        
        CommonFunction.showLoader(vc: self)
        UserService.addImageApi(params: params, imgData: imgData, imageKey: "userimg") { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                // self.profileData.userImages?.insert(data!, at: 0)
                
                
                self.getMyProfile()
                
                self.profileTableView.reloadData()
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
        
    }
    
    
    func profileTypeService(){
        
        var params : jsonDictionary = ["userid" : CurentUser.userId as AnyObject]
        
        if self.visibilitySwitch.isOn{
            params["profileType"] = "1" as AnyObject?
            self.visibilityTypelabel.text = "Public"
        }else{
            params["profileType"] = "0" as AnyObject?
            self.visibilityTypelabel.text = "Private"

        }
        
        printDebug(object: params)
        
        //CommonFunction.showLoader(vc: self)

        UserService.profileTypeApi(params: params) { (success) in
            
            if success{
               // CommonFunction.hideLoader(vc: self)
                
                
            }else{
               // CommonFunction.hideLoader(vc: self)
                
            }
        }
        
    }
    
}

class UserDataCell : UITableViewCell{
    @IBOutlet weak var dataHeadinglabel: UILabel!
    @IBOutlet weak var dataValuelabel: UILabel!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var dataImageView: UIImageView!
    
    
    func hideShowLabels(row:Int,isMyProfile:Bool){
        
        if isMyProfile{
            
            switch row{
            case 0,1,2,3:
                self.descriptionlabel.isHidden = true
                self.dataHeadinglabel.isHidden = false
                self.dataValuelabel.isHidden = false
                self.dataImageView.isHidden = false
                
            case 4,5:
                self.descriptionlabel.isHidden = false
                self.dataHeadinglabel.isHidden = true
                self.dataValuelabel.isHidden = true
                self.dataImageView.isHidden = true
                
            default:
                fatalError("wrong cell")
            }

            
        }else{
            
            switch row{
            case 0,1,2:
                self.descriptionlabel.isHidden = true
                self.dataHeadinglabel.isHidden = false
                self.dataValuelabel.isHidden = false
                self.dataImageView.isHidden = false
                
            case 3,4:
                self.descriptionlabel.isHidden = false
                self.dataHeadinglabel.isHidden = true
                self.dataValuelabel.isHidden = true
                self.dataImageView.isHidden = true
                
            default:
                fatalError("wrong cell")
            }

            
        }
        
    }
    
}


class SavedimagesCell : UITableViewCell{
    @IBOutlet weak var savedImagesCollectionView: UICollectionView!
    @IBOutlet weak var imageTypeLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var noImageLabel: UILabel!
    @IBOutlet weak var noImageLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
       
    }
    
    func showHideViewAllButton(count:Int){
        if count > 4{
            self.viewAllButton.isHidden = false
        }else{
            self.viewAllButton.isHidden = true
        }
        
    }
}

class SavedImageCollectionViewCell : UICollectionViewCell{
    @IBOutlet weak var savedImageview: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.savedImageview.layer.cornerRadius = 5.0
        self.savedImageview.layer.borderColor = UIColor.black.cgColor
        self.savedImageview.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        
        self.layer.borderColor = UIColor.black.cgColor
        self.clipsToBounds = true
        self.backgroundColor = AppColors.lightSeperatorColor
        self.clipsToBounds = true
        
    }
    
}

