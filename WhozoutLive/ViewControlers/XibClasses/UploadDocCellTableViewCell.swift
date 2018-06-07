


import UIKit



class UploadDocCellTableViewCell: UITableViewCell {
    
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var docimageView: UIImageView!
    @IBOutlet weak var descriptionlabel: UILabel!
    @IBOutlet weak var fileNameLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        
    }
    
    func setDocImage(row:Int,type:UploadDocumentType,img : UIImage?){
        
        if type == .IdProof{
            
            if row == 0{
                
                guard let imag = img else{
                    self.docimageView.image = UIImage(named: "docFrontplaceholder")
                    self.uploadButton.setImage(UIImage(named : "uploadIcon"), for: UIControlState.normal)
                    
                    return
                }
                self.uploadButton.setImage(UIImage(named : "removeDocument"), for: UIControlState.normal)
                self.docimageView.image = imag
                
                
            }else{
                guard let imag = img else{
                    self.docimageView.image = UIImage(named: "docbackPlaceHolder")
                    self.uploadButton.setImage(UIImage(named : "uploadIcon"), for: UIControlState.normal)
                    return
                }
                
                self.docimageView.image = imag
                self.uploadButton.setImage(UIImage(named : "removeDocument"), for: UIControlState.normal)
                
            }
            
        }else{
            guard let imag = img else{
                self.docimageView.image = UIImage(named: "photoPlaceHolder")
                self.uploadButton.setImage(UIImage(named : "uploadIcon"), for: UIControlState.normal)
                
                
                return
            }
            self.uploadButton.setImage(UIImage(named : "removeDocument"), for: UIControlState.normal)
            self.docimageView.image = imag
            
        }
        
    }
    
    
    func setFileName(row : Int,type:UploadDocumentType, fileName : String){
        
        if type == .IdProof{
            if row == 0{
                if fileName != ""{
                    self.fileNameLabel.text = fileName
                }else if CurentUser.identityProofFrontStatus == "1"{
                    self.fileNameLabel.text = CurentUser.identityProofFront
                }else if CurentUser.identityProofFrontStatus == "2"{
                    self.fileNameLabel.text = "Unapproved"
                }else{
                    self.fileNameLabel.text = ""
                }
            }else{
                if fileName != ""{
                    self.fileNameLabel.text = fileName
                }else if CurentUser.identityProofBackStatus == "1"{
                    self.fileNameLabel.text = CurentUser.identityProofBack
                }else if CurentUser.identityProofBackStatus == "2"{
                self.fileNameLabel.text = "Unapproved"
                
                }else{
                    self.fileNameLabel.text = ""
                }
            }
        }else{
            if row == 0{
                if fileName != ""{
                    self.fileNameLabel.text = fileName
                }else if CurentUser.identityProofSelfieStatus == "1"{
                    self.fileNameLabel.text = CurentUser.identityProofSelfie
                }else if CurentUser.identityProofSelfieStatus == "2"{
                    self.fileNameLabel.text = "Unapproved"
                }else{
                    self.fileNameLabel.text = ""
                }
            }
        }
    }
}
