

import UIKit

class VerifiedBroadcasterCell: UITableViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var uploadButton: UIButton!
    @IBOutlet weak var submitedLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
    func hideShowButtons(index : Int){
        if index == 0{
            self.submitedLabel.isHidden = true
            self.uploadButton.isHidden = true
        }else if index == 1{
            self.submitedLabel.isHidden = false
            self.uploadButton.isHidden = true
        }else if index == 2{
            
            if CurentUser.identityProofFrontStatus! == "1"{
                self.submitedLabel.isHidden = false
                self.uploadButton.isHidden = true
            
            }else{
                self.submitedLabel.isHidden = true
                self.uploadButton.isHidden = false
            }
        }else if index == 3{
            if CurentUser.identityProofSelfieStatus! == "1"{
                self.submitedLabel.isHidden = false
                self.uploadButton.isHidden = true
            }else{
                self.submitedLabel.isHidden = true
                self.uploadButton.isHidden = false
            }        }
        
    }
    
   
    
    
}
