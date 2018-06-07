

import UIKit
import SwiftyDropbox


class BroadcasterAggrementVC: UIViewController {
    
    var docType = UploadDocumentType.None
    let picker : UIImagePickerController = UIImagePickerController()

    let uploadIdProofDescription : [Int : StringArray] = [
    
        0 : [NSLocalizedString("broadcaster 1.1", comment: "")
             ],
        
        1 : [NSLocalizedString("upload id proof header 2.1", comment: ""),NSLocalizedString("upload id proof header 2.2", comment: ""),NSLocalizedString("upload id proof header 2.3", comment: ""),NSLocalizedString("upload id proof header 2.4", comment: "")]
    ]
    
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var broadcasterAggrementTableView: UITableView!
    @IBOutlet weak var allYourDocsLabel: UIView!
    @IBOutlet weak var adminApprovalRequiredLabel: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubview()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    @IBAction func backButtontapped(_ sender: UIButton) {
        
        
       _ = self.navigationController?.popViewController(animated: true)
    }
    
    
}

//MARK:- private functions
//============================
private extension BroadcasterAggrementVC{
    
    //MARK:- Setup your viewDidLoad
    //===============================
    func setUpSubview(){
        
        self.broadcasterAggrementTableView.register(UINib(nibName: "UploadDocCellTableViewCell", bundle: nil), forCellReuseIdentifier: "uploadDocCellTableViewCell")
        
        self.broadcasterAggrementTableView.register(UINib(nibName: "DetailedDescriptionCell", bundle: nil), forCellReuseIdentifier: "detailedDescriptionCell")
        
        self.allYourDocsLabel.isHidden = true
        self.adminApprovalRequiredLabel.isHidden = true
       
        self.broadcasterAggrementTableView.delegate = self
        self.broadcasterAggrementTableView.dataSource = self
        
  
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
extension BroadcasterAggrementVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            
          return 1
            
        }else{
            return 4
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
         return 80
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
           backView.backgroundColor = UIColor.white
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
            cell.docimageView.isHidden = true
            cell.fileNameLabel.isHidden = true
           // cell.descriptionlabel.textColor = UIColor.black
            cell.uploadButton.addTarget(self, action: #selector(BroadcasterAggrementVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailedDescriptionCell") as! DetailedDescriptionCell
            cell.descriptionLabel.text = self.uploadIdProofDescription[indexPath.section]?[indexPath.row]
            return cell
        }
    }
    
    
   // MARK:- upload buttontapped
   // ==============================
    func uploadButtontapped(sender : UIButton){

        openActionSheet()
    }
    
    func openActionSheet(){
        CommonFunction.selectType(vcObj : self,isPdfAllowed: true) { (type) in
            
            if type == .Camera{
                CommonFunction.checkAndOpenCamera(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Galery{
                
                CommonFunction.checkAndOpenLibrary(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Dropbox{
                
//                DropboxClientsManager.unlinkClients()
//                DropboxClientsManager.resetClients()

                
                if let _ = DropboxClientsManager.authorizedClient{
                    self.getList()
                }else{
                    
                    DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: { (url) in
                        
                        UIApplication.shared.open(url, options: ["":""], completionHandler: { (success) in
                            
                            
                        })
                        
                    })
                    
                    
                }
                
            }else{
                
            }
        }
        
    }

    
}


extension BroadcasterAggrementVC : GetDocumentBack{
    
    func getDocBack(path: String) {
        
        print(path)
        self.dismiss(animated: true, completion: nil)
        self.downloadFile(path: path)
        
    }
}
//MARK:- Dropbox
//==================
extension BroadcasterAggrementVC{
    
    func getList(){
        let client = DropboxClientsManager.authorizedClient!
        
        DispatchQueue.main.async {
            CommonFunction.showLoader(vc: self)
        }
        
        client.files.listFolder(path: "").response(queue: DispatchQueue(label: "MyCustomSerialQueue")) { response, error in
            if let result = response {
                
                DispatchQueue.main.async {
                    CommonFunction.hideLoader(vc: self)
                }
                
                print(Thread.current)
                
                print(Thread.main)
                
                // self.downloadFile()
                print(result)
                
                
                var filterPdf : [Files.Metadata] = []
                
                for item in result.entries{
                    
                    if (item.pathLower?.hasSuffix(".pdf"))!{
                        
                        filterPdf.append(item)
                    }
                    
                }
                
                
                let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "ShowDropBoxDataID") as! ShowDropBoxDataVC
                vc.dropBoxdata = filterPdf
                vc.getDocDelegate = self
                self.navigationController?.present(vc, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Download file from dropbox and convert to nsdata
    //=======================================================
    func downloadFile(path : String){
        
        printDebug(object: "path....\(path)")
        CommonFunction.showLoader(vc: self)
        let client = DropboxClientsManager.authorizedClient!
        
        let fileManager = FileManager.default
        let directoryURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let destURL = directoryURL.appendingPathComponent("myTestFile")
        let destination: (URL, HTTPURLResponse) -> URL = { temporaryURL, response in
            return destURL
        }
        client.files.download(path: path, overwrite: true, destination: destination)
            .response { response, error in
                if let response = response {
                    print(response)
                    var fileData : NSData!
                    
                    fileData = NSData(contentsOf: response.1)
                    
                    CommonFunction.hideLoader(vc: self)
                    
                   // print("gata....\(fileData)")
                    
                    self.uploadPdfDoc(docData: fileData)
                    
                } else if let error = error {
                    print(error)
                }
            }
            .progress { progressData in
                print(progressData)
        }
        
    }
    
}


extension BroadcasterAggrementVC{
    
    func uploadPdfDoc(docData : NSData){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"docKey":"broadcastDocument" as AnyObject,"documentType" : "0" as AnyObject]
        CommonWebService.sharedInstance.docPdfeUploadService(params: params, imgData: docData, imgKey: "userimg", vcObj: self) { (success) in
            if success{
                self.navigateToPayment()
            }else{
                
            }
            
        }
        
    }
    
}



