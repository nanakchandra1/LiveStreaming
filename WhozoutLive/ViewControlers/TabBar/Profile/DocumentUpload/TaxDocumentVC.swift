

import UIKit
import SwiftyDropbox

protocol GetDocumentBack {
    
    func getDocBack(path : String)
}

class TaxDocumentVC: UIViewController {

    //MARK:- Variables
    //====================
    let taxDescription : [Int : StringArray] = [
    
    0 : [NSLocalizedString("tax documents 1.1" , comment: "")],
    1 : [NSLocalizedString("tax documents US" , comment: ""),
        NSLocalizedString("tax documents non US" , comment: "")]
    ]
    
    var usOrNot = USOrNonUs.None
    var docImage : UIImage?
    let picker : UIImagePickerController = UIImagePickerController()
    
    //MARK:- IBOutlets
    //====================
    @IBOutlet weak var backbutton: UIButton!
    @IBOutlet weak var taxtableView: UITableView!
    @IBOutlet weak var uploadedAllDocumentsLabel: UILabel!
    @IBOutlet weak var adminApprovalRequiredlabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubview()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
        

        
    }
    
  

}



//MARK:- private functions
//============================
private extension TaxDocumentVC{
    
    //MARK:- Setup your viewDidLoad
    //===============================
    func setUpSubview(){
        
        self.taxtableView.register(UINib(nibName: "DetailedDescriptionCell", bundle: nil), forCellReuseIdentifier: "detailedDescriptionCell")
        self.picker.delegate = self
        self.taxtableView.delegate = self
        self.taxtableView.dataSource = self
        
        
        
        self.uploadedAllDocumentsLabel.isHidden = true
        self.adminApprovalRequiredlabel.isHidden = true
        
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
extension TaxDocumentVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
         return 1
            
        }else{
            return 1
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            let height = CommonFunction.getTextHeight(text: (self.taxDescription[indexPath.section]?[indexPath.row])!, font: AppFonts.lotoRegular.withSize(12), width: screenWidth - 33)
            return height + 10

        }else{
            
           let txt = self.usOrNot == .US ? self.taxDescription[indexPath.section]?[0] :  self.taxDescription[indexPath.section]?[1]
            
         let height = CommonFunction.getTextHeight(text:txt!, font: AppFonts.lotoRegular.withSize(12), width: screenWidth - 33)
    
    return height + 10
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            return 40
            
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
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 60))
        let txtlabel = UILabel(frame:CGRect(x: 5, y: 0, width: screenWidth - 55, height: 50))

        backView.backgroundColor = UIColor.white
        
        let btn = UIButton(frame: CGRect(x: screenWidth - 55 , y: 0, width: 45, height: 45))
        
        
        if let _ = self.docImage{
            btn.setImage(UIImage(named : "removeDocument"), for: UIControlState.normal)
        }else{
               btn.setImage(UIImage(named : "uploadIcon"), for: UIControlState.normal)
        }
        
        
        btn.addTarget(self, action: #selector(TaxDocumentVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
        
        txtlabel.numberOfLines = 0
        
        if section == 0{
            txtlabel.textColor = UIColor.black
            txtlabel.font = AppFonts.lotoMedium.withSize(15)
            txtlabel.text =  "TAX DOCUMENTS"
            
        }else{
            txtlabel.textColor = UIColor.black
            txtlabel.font = AppFonts.lotoMedium.withSize(16)
        
            if self.usOrNot == .US{
                txtlabel.text =  "US CITIZENS OR US RESIDENTS (W-9)"
            }else{
                txtlabel.text =  "NON US CITIZENS OR NON US RESIDENTS (W-8)"

            }
            
            
        }
        
        section == 1 ? backView.addSubview(btn) : printDebug(object: "")

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
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailedDescriptionCell") as! DetailedDescriptionCell
            
            cell.descriptionLabel.text = self.taxDescription[indexPath.section]?[indexPath.row]
           
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "detailedDescriptionCell") as! DetailedDescriptionCell
            
            if self.usOrNot == .US{
                cell.descriptionLabel.text = self.taxDescription[indexPath.section]?[0]
            }else{
                 cell.descriptionLabel.text = self.taxDescription[indexPath.section]?[1]
            }
            
    
            return cell
        }
}
    func uploadButtontapped(sender : UIButton){
    
        self.getOrRemovePhoto()
      
    }
    
    
    //MARk:- get or remove photo
    //===========================
    func getOrRemovePhoto(){
            if let _ = self.docImage{
                self.docImage = nil
                self.taxtableView.reloadData()
            }else{
                self.openActionSheet()
            }
    }
    
    
    func openActionSheet(){
        CommonFunction.selectType(vcObj : self,isPdfAllowed: true) { (type) in
            
            if type == .Camera{
                CommonFunction.checkAndOpenCamera(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Galery{
                
                CommonFunction.checkAndOpenLibrary(picker: self.picker, forTypes: ["\(kUTTypeImage)"],vcObj: self)
                
            }else if type == .Dropbox{
                
                if let _ = DropboxClientsManager.authorizedClient{
                    
                    self.getList()
                }else{
                    
                    DropboxClientsManager.authorizeFromController(UIApplication.shared, controller: self, openURL: {(url: URL) -> Void in
                        
                        //UIApplication.shared.openURL(url)
                        
                        UIApplication.shared.open(url, options: ["":""], completionHandler: { (success) in
                            
                        })

                    })
               
                }
            }else{
                
            }
        }
        
    }

}

extension TaxDocumentVC :  UIImagePickerControllerDelegate, UINavigationControllerDelegate  {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let mediaType = info[UIImagePickerControllerMediaType] as! NSString
        
        print("=======\(info)")
        let name = "\(String(describing: info["UIImagePickerControllerReferenceURL"]))".components(separatedBy: "-").last
        
        printDebug(object: name)
        
        
        if mediaType == kUTTypeImage {
            
            self.picker.dismiss(animated: true, completion: {
                
                if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
                    
                    self.dismiss(animated: true, completion: nil)
                   
                    self.docImage = image
                   
                    self.taxtableView.reloadData()
                    
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



extension TaxDocumentVC : GetDocumentBack{
    
    func getDocBack(path: String) {
        
        print(path)
        self.dismiss(animated: true, completion: nil)
        self.downloadFile(path: path)
        
    }
}

//MARK:- Dropbox
//==================
extension TaxDocumentVC{
    
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
                    
                    //print("gata....\(fileData)")
                    
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


extension TaxDocumentVC{

    func uploadPdfDoc(docData : NSData){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"docKey":"taxDocument" as AnyObject]
        CommonWebService.sharedInstance.docPdfeUploadService(params: params, imgData: docData, imgKey: "userimg", vcObj: self) { (success) in
            if success{
                
                self.navigateToPayment()
          
            }else{
                
            }
            
        }

    }
}

