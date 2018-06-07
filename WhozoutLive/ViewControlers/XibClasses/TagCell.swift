

import UIKit

class TagCell: UICollectionViewCell {
    
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var tagNameMaxWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var removeButton: UIButton!
    override func awakeFromNib() {
      //  self.backgroundColor = UIColor.darkGray
        self.tagName.textColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        self.tagName.layer.cornerRadius = 3.0
          self.tagName.layer.borderWidth = 1.0
          self.tagName.layer.borderColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1).cgColor
        
        self.tagNameMaxWidthConstraint.constant = UIScreen.main.bounds.width - 8 * 2 - 8 * 2 + 8 * 1
        
        //self.backgroundColor = UIColor.grayColor()
    }
    
    @IBAction func removeBtnTapped(_ sender: Any) {
        
    }
}
