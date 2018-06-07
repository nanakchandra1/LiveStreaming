

import UIKit

enum SlectedAction{
    case Camera
    case Galery
    case Dropbox
    case Cancel
}


class UploadIdProofVC: UIViewController {

    //MARK:- Variables
    //=================
    let picker : UIImagePickerController = UIImagePickerController()

    var docType = UploadDocumentType.None
    
    let uploadIdProofDescription : [Int : StringArray] = [
        
        0 : [NSLocalizedString("upload id proof header 1.1", comment: ""),
             NSLocalizedString("upload id proof header 1.2", comment: "")],
        
        1 : [NSLocalizedString("upload id proof header 2.1", comment: ""),NSLocalizedString("upload id proof header 2.2", comment: ""),NSLocalizedString("upload id proof header 2.3", comment: ""),NSLocalizedString("upload id proof header 2.4", comment: "")]
    ]
    
    var idProofFrontImage : UIImage?
    var idProofBackImage : UIImage?
    var photoImage : UIImage?
    
    var idProofFrontFileName = ""
    var idProofBackFileName = ""
    var photoFileName = ""
    
    var indexFor : Int!

    
    //MARK:- IBOutlets
    //====================
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var uploadIdProofTableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var uploadedAllDocuments: UILabel!
    @IBOutlet weak var adminApprovalLabel: UILabel!
    
    //Mark:-Variables
    
    
    //
    //MARK:- IBOutlets

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubview()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func backbuttontapped(_ sender: UIButton) {
         _ = self.navigationController?.popViewController(animated: true)
    }
   
    @IBAction func submitButtontapped(_ sender: UIButton) {
        if self.docType == .IdProof{
            self.uploadService(img: self.idProofFrontImage,docKey:
    "identityProofFront")
        }else{
            self.uploadService(img: self.photoImage,docKey:"identityProofSelfie")
        }
    }

}

//MARK:- private functions
//============================
private extension UploadIdProofVC{
    
    //MARK:- Setup your viewDidLoad
    //===============================
    func setUpSubview(){
        
        self.uploadIdProofTableView.register(UINib(nibName: "UploadDocCellTableViewCell", bundle: nil), forCellReuseIdentifier: "uploadDocCellTableViewCell")
        
        self.uploadIdProofTableView.register(UINib(nibName: "DetailedDescriptionCell", bundle: nil), forCellReuseIdentifier: "detailedDescriptionCell")
        
        self.picker.delegate = self
        self.uploadIdProofTableView.delegate = self
        self.uploadIdProofTableView.dataSource = self
        
        self.submitButton.isEnabled = false
        self.submitButton.backgroundColor = AppColors.pinkColor.withAlphaComponent(0.5)
     
        if self.docType == .IdProof{
            
            if CurentUser.identityProofFrontStatus == "1"{
                self.uploadedAllDocuments.isHidden = false
                self.adminApprovalLabel.isHidden = false
            }else{
                self.uploadedAllDocuments.isHidden = true
                self.adminApprovalLabel.isHidden = true

            }
            
        }else{
            
            if CurentUser.identityProofSelfieStatus == "1"{
                self.uploadedAllDocuments.isHidden = false
                self.adminApprovalLabel.isHidden = false

            }else{
                self.uploadedAllDocuments.isHidden = true
                self.adminApprovalLabel.isHidden = true

            }
        }
        
        self.uploadedAllDocuments.isHidden = true
        self.adminApprovalLabel.isHidden = true
    }
    
    
    //MARK:- Get or remove id proof
    func getOrRemoveIdProof(row:Int){
        if row == 0{
            if let _ = self.idProofFrontImage{
                self.idProofFrontImage = nil
                self.idProofFrontFileName = ""
                
                self.uploadIdProofTableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.none)
            }else{
                self.openActionSheet()
            }
        }else{
            if let _ = self.idProofBackImage{
                self.idProofBackImage = nil
                self.idProofBackFileName = ""
                
                self.uploadIdProofTableView.reloadRows(at: [IndexPath(row: 1, section: 0)], with: UITableViewRowAnimation.none)
            }else{
                self.openActionSheet()
            }
        }
    }
    
    //MARk:- get or remove photo
    //===========================
    func getOrRemovePhoto(row:Int){
        if row == 0{
            if let _ = self.photoImage{
                self.photoImage = nil
                self.photoFileName = ""
                self.uploadIdProofTableView.reloadRows(at: [IndexPath(row: 0, section: 1)], with: UITableViewRowAnimation.none)
            }else{
                self.openActionSheet()
            }
            
        }
    }
    
    
    func openActionSheet(){
        CommonFunction.selectType(vcObj : self,isPdfAllowed: false) { (type) in
            
            if type == .Camera{
                CommonFunction.checkAndOpenCamera(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Galery{
                
                CommonFunction.checkAndOpenLibrary(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Dropbox{
                
                
            }else{
                
            }
        }
        
    }
    
    
    //MARK:- Enable disable submit button
    //=====================================
    func enableDisableSubmitButton(){
        if self.docType == .IdProof{
            if let _ = self.idProofFrontImage,self.idProofBackImage != nil{
                self.submitButton.isEnabled = true
                self.submitButton.backgroundColor = AppColors.pinkColor
            }else{
                self.submitButton.isEnabled = false
                self.submitButton.backgroundColor = AppColors.pinkColor.withAlphaComponent(0.5)
            }
        }else{
            
            if let _ = self.photoImage{
                self.submitButton.isEnabled = true
                self.submitButton.backgroundColor = AppColors.pinkColor

            }else{
                self.submitButton.isEnabled = false
                self.submitButton.backgroundColor = AppColors.pinkColor.withAlphaComponent(0.5)
                

            }
        }
    }
    
    
    func navigateToPayment(){
        if CurentUser.docUpload == "4"{
            
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "PaymentID") as! PaymentVC
            self.navigationController?.pushViewController(vc, animated: true)
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
}


//MARK:- datasource and delegate methods
//============================================
extension UploadIdProofVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            
            if self.docType == .IdProof{
                return 2

            }else{
                return 1

            }
            
        }else{
            return 4
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
          return 60
        }else{
            let height = CommonFunction.getTextHeight(text: (self.uploadIdProofDescription[indexPath.section]?[indexPath.row])!, font: AppFonts.lotoRegular.withSize(12), width: screenWidth - 33)
            return height + 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return 50
            
        }else{
            return 40
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0{
            return 5
            
        }else{
            return 0
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 50))
        let txtlabel = UILabel(frame:CGRect(x: 5, y: 0, width: screenWidth, height: 50))
       //   backView.backgroundColor = UIColor.green
        txtlabel.numberOfLines = 0
        
        if section == 0{
            txtlabel.textColor = UIColor.black
            txtlabel.font = AppFonts.lotoMedium.withSize(13)
            txtlabel.text =  NSLocalizedString("upload id proof header", comment: "")
            
        }else{
            txtlabel.textColor = UIColor.black
            txtlabel.font = AppFonts.lotoMedium.withSize(16)
            txtlabel.text =  "IMPORTANT NOTES"
            
        }
        backView.addSubview(txtlabel)
        return backView
    }
    
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 5))
        let seperatorView = UIView(frame: CGRect(x: 0 , y: 0, width: screenWidth, height: 1))
        // backView.backgroundColor = AppColors.pinkColor
        backView.addSubview(seperatorView)
        if section == 0{
            seperatorView.backgroundColor = AppColors.seperatorGreyColor
        }else{
            seperatorView.backgroundColor = UIColor.white
        }
        
        return backView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            let cell = tableView.dequeueReusableCell(withIdentifier: "uploadDocCellTableViewCell") as! UploadDocCellTableViewCell
            cell.descriptionlabel.text = self.uploadIdProofDescription[indexPath.section]?[indexPath.row]
            cell.uploadButton.addTarget(self, action: #selector(UploadIdProofVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
            self.enableDisableSubmitButton()
            
            if self.docType == .IdProof{
                
                 if indexPath.row == 0{
                    cell.setDocImage(row: indexPath.row, type: self.docType,img: self.idProofFrontImage)
                    cell.setFileName(row: indexPath.row, type: self.docType, fileName: self.idProofFrontFileName)
                }else{
                    cell.setDocImage(row: indexPath.row, type: self.docType,img: self.idProofBackImage)
                    cell.setFileName(row: indexPath.row, type: self.docType, fileName: self.idProofBackFileName)
                }
                
            }else{
                
                if indexPath.row == 0{
                    cell.setDocImage(row: indexPath.row, type: self.docType,img: self.photoImage)
                    cell.setFileName(row: indexPath.row, type: self.docType, fileName: self.photoFileName)
                }
            }
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailedDescriptionCell") as! DetailedDescriptionCell
            cell.descriptionLabel.text = self.uploadIdProofDescription[indexPath.section]?[indexPath.row]
            return cell
        }
    }
    
    
    //MARK:- upload buttontapped
    //==============================
    func uploadButtontapped(sender : UIButton){
        
        let ind = sender.tableViewIndexPath(tableView : self.uploadIdProofTableView)
        self.indexFor = ind?.row
        
        if self.docType == .IdProof{
           self.getOrRemoveIdProof(row: (ind?.row)!)
        }else{
            self.getOrRemovePhoto(row: (ind?.row)!)
        }
        
         self.uploadIdProofTableView.reloadRows(at:[IndexPath(row: self.indexFor,section:0) as IndexPath], with: UITableViewRowAnimation.none)
    }
}


extension UploadIdProofVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        print("=======\(info)")
        
        if mediaType == kUTTypeImage {
            
            self.picker.dismiss(animated: true, completion: {
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    self.dismiss(animated: true, completion: nil)
                    
        let fileName = "\(info["UIImagePickerControllerReferenceURL"] ?? "")".components(separatedBy: "-").last
                    
                    if self.docType == .IdProof{
                        if self.indexFor == 0{
                            
                            self.idProofFrontImage = image
                            self.idProofFrontFileName = fileName ?? ""
                        }else{
                           
                        self.idProofBackImage = image
                         self.idProofBackFileName = fileName ?? ""
                        }
                        
                    }else{
                       
                        self.photoImage = image
                        self.photoFileName = fileName ?? ""
                    }
          
                    self.uploadIdProofTableView.reloadRows(at:[IndexPath(row: self.indexFor,section:0) as IndexPath], with: UITableViewRowAnimation.none)
                    
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


//MARK:- Webservices
//===================
extension UploadIdProofVC{
    
    func uploadService(img:UIImage?,docKey:String){
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"docKey":docKey as AnyObject]
        print(params)
        var imgData : NSData?
        
        if let img = img{
            imgData = UIImageJPEGRepresentation(img, 0.5) as NSData?
        }
     
        CommonFunction.showLoader(vc: self)
        CommonWebService.sharedInstance.docImageUploadService(params: params, imgData: imgData, imgKey: "userimg", vcObj: self) { (success) in
            if success{
                CommonFunction.hideLoader(vc: self)
            if docKey == "identityProofFront"{
                
                self.uploadService(img: self.idProofBackImage, docKey: "identityProofBack")
            
                }else if docKey == "identityProofBack"{

                AppUserDefaults.save(value: "1", forKey:AppUserDefaults.Key.IdentityProofFrontStatus)
                
                AppUserDefaults.save(value: "1", forKey:AppUserDefaults.Key.IdentityProofBackStatus)
                
                self.navigateToPayment()

                
                }else{
                AppUserDefaults.save(value: "1"  , forKey:AppUserDefaults.Key.IdentityProofSelfieStatus)
                
                self.navigateToPayment()
            }
                
                
            }else{
                CommonFunction.hideLoader(vc: self)

            }
        
        }
        
    }
    
}
