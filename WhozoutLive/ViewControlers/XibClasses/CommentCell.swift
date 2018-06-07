

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var emogieImageView: UIImageView!
    @IBOutlet weak var dotView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nameLabelWidth: NSLayoutConstraint!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var emogieCommentImageView: UIImageView!
    @IBOutlet weak var emogieImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var ghostBanButton: UIButton!
    @IBOutlet weak var nameLeading: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.dotView.layer.cornerRadius = self.dotView.frame.size.height / 2
        self.dotView.clipsToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool){
        super.setSelected(selected, animated: animated)
    }
    
    
    func caleulateNameWidth(name:String,type:String){
        if type == "1"{
            self.nameLabelWidth.constant = 200
        }else{
           // let size = CommonFunction.getTextSize(text: name, font: AppFonts.lotoRegular.withSize(13))
            
           let size = CommonFunction.getTextWidth(text: name, font: AppFonts.lotoRegular.withSize(13), height: 15)
            
            printDebug(object: "size.width...\(size)")
            
            if size < 35 {
              //  self.nameLabelWidth.constant = size
            }else{
               // self.nameLabelWidth.constant = 35
            }
            
            self.nameLabelWidth.constant = 40
        }
    }
    
    
    func showEmogieOrText(type:String,emogieId:String,emojiOrRain : String){
    // printDebug(object: "type...\(type)")
        
        if type == "0"{
            printDebug(object: "type is 0...\(type)")
            self.emogieImageViewWidth.constant = 0
            self.commentLabel.isHidden = false
            self.emogieCommentImageView.isHidden = true
            self.emogieCommentImageView.image = UIImage(named: "")
        }else{

            self.emogieImageViewWidth.constant = 35
            self.commentLabel.isHidden = true
            self.emogieCommentImageView.isHidden = false
            
            let PathAndDimendion = DataBaseControler.getImagePath(emogieId: emogieId)
            
           // printDebug(object: "PathAndDimendion is \(PathAndDimendion)")
            
           // let PathAndDimendion = ("","medium")
            
            printDebug(object: "PathAndDimendion is \(PathAndDimendion)")
            
            //if PathAndDimendion.0 != ""{
                
              if emojiOrRain == "1"{
                self.emogieCommentImageView.image = UIImage(named: "king")
              }else{
                
                 if PathAndDimendion.0 != ""{
                    self.emogieCommentImageView.image = CommonFunction.getImage(pathName: PathAndDimendion.0)
                 }else{
                     self.emogieCommentImageView.image = UIImage(named: "emogie")
                }
                
                }
        }
    }
    
    
    func getImageurlFromCoredata(emogieId:String) -> String{
        
        let prStr = NSPredicate(format: "emogiId == %@", emogieId)
        
        if let emogies = DataBaseControler.fetchData(modelName: "WLEmogies", predicate: prStr) as? [WLEmogies]{
            
            
            if emogies.count <= 0{
                
                return ""
            }
            
          
            guard let url = emogies[0].url else{
                return ""
            }
            
            return url
            
        }
        
        return ""
    }
    
    func setTime(time : String){
        if time != "just now"{
        let timeStampValue = Double(time)! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        self.timeLabel.text = Date().timeFrom(date:date as Date)
        }else{
              self.timeLabel.text = "just now"
        }
    }
    
   func myCommentOrNot(userId:String){
    if userId == CurentUser.userId{
        self.ghostBanButton.isHidden = true
    }else{
        self.ghostBanButton.isHidden = false

        }
    
    }
    
    func ghostBanUser(banUserId:String,banUsers:StringArray){
        if banUserId == CurentUser.userId{
         self.ghostBanButton.isHidden = true
            
        }else if banUsers.contains(banUserId){
            self.ghostBanButton.setImage( UIImage(named: "blackToggle"), for: UIControlState.normal)
            self.ghostBanButton.isUserInteractionEnabled = false
            self.ghostBanButton.isHidden = false

        }else{
             self.ghostBanButton.setImage( UIImage(named: "purpleToggle"), for: UIControlState.normal)
            self.ghostBanButton.isUserInteractionEnabled = true
            self.ghostBanButton.isHidden = false


        }
    }
    
    func setNameText(name:String,type:String){
        
        if type == "1"{
            
            self.nameLabel.text = name
            
        }else{
    
       self.nameLabel.text = "\(name) :"
        }
    }
    
}
