

import UIKit

class FollowingFollowersCell: UITableViewCell {

    @IBOutlet weak var followerNamelabel: UILabel!
    @IBOutlet weak var followUnfollowBitton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var liveStreamButton: UIButton!
    @IBOutlet weak var tickImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.followerNamelabel.isUserInteractionEnabled = true
        self.profileImageView.isUserInteractionEnabled = true

    }

    override func layoutIfNeeded() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
       self.profileImageView.layer.borderWidth = 1.0
       self.profileImageView.layer.borderColor = AppColors.placeHolderColor.cgColor
    }
    
    func setButtonHiddenStatus(live:String,from : ConnectionsFrom){
        if from == .SharingInformation{
            self.liveStreamButton.isHidden = true
            self.followUnfollowBitton.isHidden = true
            self.tickImageView.isHidden = false
        }else{
            self.followUnfollowBitton.isHidden = false
            self.tickImageView.isHidden = true
        if live == "1"{
        self.liveStreamButton.isHidden = false
        }else{
            self.liveStreamButton.isHidden = true
        }
      }
    }
    
    func setFollowButtonImage(isFollow:String){
        
        if isFollow == "1"{
            self.followUnfollowBitton.setImage(UIImage(named : "followIcon"), for: UIControlState.normal)
        }else{
            self.followUnfollowBitton.setImage(UIImage(named : "unfollowIcon"), for: UIControlState.normal)
            
        }
    }
    
}
