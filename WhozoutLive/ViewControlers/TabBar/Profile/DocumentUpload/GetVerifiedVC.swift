

import UIKit


enum UploadDocumentType{
    case IdProof
    case Photo
    case BroadcasterAggrement
    case None
}

enum USOrNonUs{
    case US
    case NonUS
    case None
}

class GetVerifiedVC: BaseViewController {

  
    
  //Mark:-Variables
    let verifieduserDescription : [Int : StringArray] = [0 : [NSLocalizedString("getverified 1.1", comment: ""),
    NSLocalizedString("getverified 1.2", comment: ""),
    NSLocalizedString("getverified 1.3", comment: ""),
    NSLocalizedString("getverified 1.4", comment: "")
    ] , 1 : [NSLocalizedString("getverified 2.1", comment: ""),
    NSLocalizedString("getverified 2.2", comment: "")]
]
      //MARK:- IBOutlets
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var getVerifiedtableView: UITableView!
    
  
    
    
    //MARK:- View life cycle
    //=======================
    override func viewDidLoad() {
        super.viewDidLoad()

        self.setUpSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.getVerifiedtableView.reloadData()
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
private extension GetVerifiedVC{
    
    //MARK:- Setup your viewDidLoad
    //===============================
    func setUpSubview(){
        
        let cellNib = UINib(nibName: "VerifiedBroadcasterCell", bundle: nil)
        self.getVerifiedtableView.register(cellNib, forCellReuseIdentifier: "verifiedBroadcasterCell")
        
        self.getVerifiedtableView.delegate = self
        self.getVerifiedtableView.dataSource = self
        
        
    }
}


//MARK:- datasource and delegate methods
//============================================
extension GetVerifiedVC : UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return 4
        }else{
            return 2

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 0{
            
        let height = CommonFunction.getTextHeight(text: (self.verifieduserDescription[indexPath.section]?[indexPath.row])!, font: AppFonts.lotoRegular.withSize(12), width: indexPath.row == 1 ? screenWidth - 203 : screenWidth - 100)
            
            if indexPath.row == 3{
                return height + 40
            }else{
                return height + 25
            }
        }else{
            return 80
        }
    }
    

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0{
            
            return 60
            
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
        let txtlabel = UILabel(frame:CGRect(x: 5, y: 0, width: screenWidth - 10, height: 35))
        
        let dropboxlabel = UILabel(frame:CGRect(x: 5, y: 35, width: screenWidth - 10, height: 25))
        
        backView.backgroundColor = UIColor.white
        txtlabel.numberOfLines = 0
        
        if section == 0{
            txtlabel.textColor = AppColors.pinkColor
            dropboxlabel.textColor = AppColors.pinkColor
            txtlabel.font = AppFonts.latoSemiBold.withSize(13)
            dropboxlabel.font = AppFonts.latoSemiBold.withSize(13)
            txtlabel.text =  NSLocalizedString("become verified broadcaster", comment: "")
            dropboxlabel.text = NSLocalizedString("download from dropbox", comment:"")
            backView.addSubview(txtlabel)
            backView.addSubview(dropboxlabel)
        }else{
            txtlabel.textColor = UIColor.black
            txtlabel.font = AppFonts.lotoMedium.withSize(16)
            txtlabel.text =  "TAX Documents"
             backView.addSubview(txtlabel)
        }
      
        return backView
    }
    
  
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 5))
        let seperatorView = UIView(frame: CGRect(x: 0 , y: 0, width: screenWidth, height: 1))
       // backView.backgroundColor = AppColors.pinkColor
            backView.addSubview(seperatorView)
        seperatorView.backgroundColor = AppColors.seperatorGreyColor
        return backView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
        
            if indexPath.row == 1{
                
                let cell = tableView.dequeueReusableCell(withIdentifier: "taxDocumentDownloadUploadCell") as! TaxDocumentDownloadUploadCell
                cell.descriptionlabel.text = self.verifieduserDescription[indexPath.section]?[indexPath.row]
                cell.descriptionlabel.textColor = UIColor.black
                cell.uploadButton.addTarget(self, action: #selector(GetVerifiedVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
               // cell.downloadButton.addTarget(self, action: #selector(GetVerifiedVC.downloadPdf), for: UIControlEvents.touchUpInside)
                cell.emailbutton.addTarget(self, action: #selector(GetVerifiedVC.emailbuttontapped), for: UIControlEvents.touchUpInside)
                return cell
            }else{
                
                
            let cell = tableView.dequeueReusableCell(withIdentifier: "verifiedBroadcasterCell") as! VerifiedBroadcasterCell
            cell.submitedLabel.isHidden = true
                //  cell.hideShowButtons(index: indexPath.row)
            cell.descriptionLabel.text = self.verifieduserDescription[indexPath.section]?[indexPath.row]
            cell.uploadButton.addTarget(self, action: #selector(GetVerifiedVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
                
            if indexPath.row == 0{
                    cell.uploadButton.isHidden = true
                cell.updateLabel.isHidden = true
            }else{
                cell.uploadButton.isHidden = false
                cell.updateLabel.isHidden = false

            }
                
                return cell
                
            }
            
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "taxDocumentDownloadUploadCell") as! TaxDocumentDownloadUploadCell
              cell.descriptionlabel.text = self.verifieduserDescription[indexPath.section]?[indexPath.row]
            cell.descriptionlabel.textColor = AppColors.placeHolderColor
            cell.uploadButton.addTarget(self, action: #selector(GetVerifiedVC.uploadButtontapped), for: UIControlEvents.touchUpInside)
            //cell.downloadButton.addTarget(self, action: #selector(GetVerifiedVC.downloadPdf), for: UIControlEvents.touchUpInside)
            cell.emailbutton.addTarget(self, action: #selector(GetVerifiedVC.emailbuttontapped), for: UIControlEvents.touchUpInside)
            return cell
        }
    }
    
    func downloadPdf(sender : UIButton){
        
        CommonFunction.downloadPdf(urlString: URLName.kDownloadPdf,vcObj: self)
        
    }
    
    func emailbuttontapped(sender : UIButton){
     
        let ind = sender.tableViewIndexPath(tableView: self.getVerifiedtableView)
        
        if ind?.section == 0{
            
            self.sendEmailService(isUsResident: "1")
            
        }else{
            if ind?.row == 0{
                 self.sendEmailService(isUsResident: "2")
            }else{
                self.sendEmailService(isUsResident: "3")
            }
        }
      
    }
    
    func uploadButtontapped(sender : UIButton){
        
        let indx = sender.tableViewIndexPath(tableView: self.getVerifiedtableView)!
        
        if indx.section == 0{
        
        switch indx.row {
            case 0:
            printDebug(object: "0")
           
            
        case 1:
            let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "BroadcasterAggrementID") as! BroadcasterAggrementVC
            vc.docType = .BroadcasterAggrement
            self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                
            let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "UploadIdProofID") as! UploadIdProofVC
            vc.docType = .IdProof
            self.navigationController?.pushViewController(vc, animated: true)
                
            case 3:
                
                let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "UploadIdProofID") as! UploadIdProofVC
                vc.docType = .Photo
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                printDebug(object: "wrong")
            }
        }else{
            
            let vc = StoryBoard.DocumentUpload.instance.instantiateViewController(withIdentifier: "TaxDocumentID") as! TaxDocumentVC
           
            if indx.row == 0{
                vc.usOrNot = .US
            }else{
                vc.usOrNot = .NonUS
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
            
        }
    }
    
}

//MARK:- Webservices
//======================
extension GetVerifiedVC{
    
    func sendEmailService(isUsResident : String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"usResident" : isUsResident as AnyObject]
        
        CommonFunction.showLoader(vc: self)
        UserService.emailDocumentApi(params: params) { (success) in
            
            if success{
               
                CommonFunction.hideLoader(vc: self)
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
        }
        
    }
    
}

class TaxDocumentDownloadUploadCell : UITableViewCell{
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var emailbutton: UIButton!
   // @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var descriptionlabel: UILabel!
    
}

