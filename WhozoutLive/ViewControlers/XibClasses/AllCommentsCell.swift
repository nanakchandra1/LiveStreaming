

import UIKit

class AllCommentsCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var emogieimageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        self.profileImageView.layer.borderWidth = 1.0
        self.profileImageView.layer.borderColor = AppColors.placeHolderColor.cgColor

        self.dotView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.dotView.clipsToBounds = true

        
    }

    
    func showEmogieOrText(type:String,emogieId:String){
        printDebug(object: "type...\(type)")
        
        if type == "0"{
            printDebug(object: "type is 0...\(type)")
           
            self.commentLabel.isHidden = false
            self.emogieimageView.isHidden = true

        }else{
            printDebug(object: "type is 1...\(type)")
            self.commentLabel.isHidden = true
            self.emogieimageView.isHidden = false
            
           // self.emogieimageView.setImageWithStringURL(URL: self.getImageurlFromCoredata(emogieId: emogieId), placeholder: UIImage(named: "userPlaceholder")!)
            
            let PathAndDimendion = DataBaseControler.getImagePath(emogieId: emogieId)
        
            if PathAndDimendion.0 != ""{
                
                if PathAndDimendion.2 == "1"{
                    self.emogieimageView.image = UIImage(named: "king")
                }else{
                    self.emogieimageView.image = CommonFunction.getImage(pathName: PathAndDimendion.0)
                }
            }else{
                self.emogieimageView.image = UIImage(named: "emogie")
            }

        }
    }
    

    func getImageurlFromCoredata(emogieId:String) -> String{
        
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            
            guard let url = emogies[0].url else{
                return ""
            }
            
            return url
            
        }
        
        return ""
    }

    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
