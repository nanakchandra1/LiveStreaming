



import UIKit

protocol ReportAbuse {
    
    func report(reason : String)
}

class OtherProfileVC: UIViewController {

    //MARK:- Variables
    //=====================
    var otherProfileData : ProfileData!
    var headings = ["FULL NAME","AGE","GENDER","","SAVED IMAGES","IMAGES"]
    var icons = ["fullName","ageIcon","genderIcon",""]

    var popMenu = ["Block User","Report Abuse"]
    var userId : String!
    var index : Int!
    var followBackDelegate : GetDataBack!
    
    
    //MARK:- IBouthets
    //===================
    @IBOutlet weak var otherProfileTableView: UITableView!
    @IBOutlet weak var followUnfollowButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var profileImageBackView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var popMenuTableView: UITableView!
    @IBOutlet weak var popMenuBackView: UIView!
    @IBOutlet weak var popMenuHeight: NSLayoutConstraint!
    @IBOutlet weak var popMenuButton: UIButton!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubview()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.popMenuButton.isSelected = false
        self.popMenuBackView.isHidden = true
        
    }
    
    @IBAction func backButtontapped(_ sender: UIButton) {
        
    printDebug(object: "////\(self.index)")
       
        
        guard let _ = self.index else {
            _ = self.navigationController?.popViewController(animated: true)

            return
        }
        
        if let _ = self.followBackDelegate{
            printDebug(object: "follow delegate..")
         //   self.followBackDelegate.getFollowUnFollowBack!(isFollow: self.otherProfileData.isfollowed ?? "0" , index: self.index)
        }
        _ = self.navigationController?.popViewController(animated: true)

    }

    
    @IBAction func followUnFollowButtontapped(_ sender: UIButton) {
        
        self.followButtonTapped()
   
    }
    
    
    
    @IBAction func popMenuButtonTapped(_ sender: UIButton) {
        
        if sender.isSelected{
            self.popMenuBackView.isHidden = true
            
        }else{
            self.popMenuBackView.isHidden = false

        }
        
        sender.isSelected = !sender.isSelected
    }
}


private extension OtherProfileVC{
    
  func setUpSubview(){
        
    self.otherProfileTableView.estimatedRowHeight = 100
    self.otherProfileTableView.rowHeight = UITableViewAutomaticDimension
    self.otherProfileTableView.isEditing = true
    self.profileImageBackView.isHidden = true
    self.popMenuTableView.delegate = self
    self.popMenuTableView.dataSource = self
    self.popMenuBackView.isHidden = true
    self.profileImageBackView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
    self.profileImageView.frame = CGRect(x: 0, y: 0, width: screenWidth, height: screenWidth)
    
    if Networking.isConnectedToNetwork{
        self.getOthersProfile()
    }else{
        CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
    }

    }
 }

//MARK:- Table view delegate and datasource
//=============================================
extension OtherProfileVC : UITableViewDelegate , UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == self.popMenuTableView{
            
            return 2
        }else{
            return 5

            
        }
    
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if tableView == self.popMenuTableView{

            return 30
        }else{
        switch indexPath.row{
            
        case 0,1,2:
            return 50
        case 3:
            return UITableViewAutomaticDimension
        case 4:
            
            if self.otherProfileData.profileType == "1"{
                 return screenWidth / 4 + 42
            }else{
                 return 0
              //  return screenWidth / 4 + 42

            }
            
           
//            
//            if (self.otherProfileData.userImages?.count)! > 0{
//                return screenWidth / 4 + 42
//            }else{
//                return 0
//
//            }
            
        default:
            fatalError("wrong cell")
        }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 10))
        backView.backgroundColor = UIColor.white
        return backView
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.popMenuTableView{
            let cell = tableView.dequeueReusableCell(withIdentifier: "popMenuCell") as! PopMenuCell
            
            cell.menuLabel.text = self.popMenu[indexPath.row]
            
            return cell
            
        }else{
        switch indexPath.row{
            
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: false)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            cell.dataValuelabel.text = self.otherProfileData.name ?? ""
            
            return cell

     
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: false)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            
            cell.dataValuelabel.text = CommonFunction.getAgeFromTimeStamp(timeStampString: self.otherProfileData.dob!).replacingOccurrences(of: "y", with: "")
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: false)
            cell.dataImageView.image = UIImage(named: self.icons[indexPath.row])
            cell.dataHeadinglabel.text = self.headings[indexPath.row]
            
            if self.otherProfileData.gender == "1"{
                cell.dataValuelabel.text = "Male"
            }else{
                cell.dataValuelabel.text = "Female"
            }
            
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: "userDataCell") as! UserDataCell
            cell.hideShowLabels(row: indexPath.row,isMyProfile: false)
            cell.descriptionlabel.text = self.otherProfileData.bio
            
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: "savedimagesCell") as! SavedimagesCell
            
            if (self.otherProfileData.userImages?.count)! > 0{
                cell.noImageLabel.isHidden = true
                cell.savedImagesCollectionView.isHidden = false
            }else{
                cell.noImageLabel.isHidden = false
                cell.savedImagesCollectionView.isHidden = true

            }
            
            cell.savedImagesCollectionView.delegate = self
            cell.savedImagesCollectionView.dataSource = self
            cell.savedImagesCollectionView.reloadData()
            
            cell.imageTypeLabel.text = "IMAGES"
            cell.viewAllButton.addTarget(self, action: #selector(ProfileVC.viewAllButtontapped), for: UIControlEvents.touchUpInside)
            
            
          cell.showHideViewAllButton(count: (self.otherProfileData.userImages?.count)!)
            
            return cell
        default:
            fatalError("")
        }
        }
        
        
    
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.popMenuTableView{
            
           // self.blockUser(type: "\(indexPath.row + 1)")
            if indexPath.row == 0{
                self.showAlert(blockType: indexPath.row + 1, title: "Block User", message: "Are you sure you wan't to block this user?")

            }else if indexPath.row == 1{
              
            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ReportAbuseID") as! ReportAbuseVC
                vc.reportDelegate = self
                self.navigationController?.pushViewController(vc, animated: true)
            }else{
                self.showAlert(blockType: indexPath.row + 1, title: "Ghost Ban", message: "Are you sure you wan't Ghost Ban this user?")

            }
            
            
        }else{
            
        }
        
        

    }
    
 
    
    func viewAllButtontapped(sender:UIButton){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SavedImagesID") as! SavedImagesVC
        vc.userId = self.userId
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func showAlert(blockType:Int,title : String,message : String ){
      
        _ = VKCAlertController.alert(title: title, message: message, buttons: ["No","Yes"], tapBlock: { (_, index) in
        
            if index == 1{
                
                printDebug(object: blockType)
                
               self.blockUser(type: "\(blockType)",reason: "")
                self.popMenuButton.isSelected = false
                self.popMenuBackView.isHidden = true
            }else{
                self.popMenuButton.isSelected = false
                self.popMenuBackView.isHidden = true
            }
            
        })
    }
    
}


extension OtherProfileVC : ReportAbuse{
    
    func report(reason:String){
        self.blockUser(type: "2",reason: reason)
        self.popMenuButton.isSelected = false
        self.popMenuBackView.isHidden = true

    }
    
}

//MARK:- collection view datasource and delegate
//================================================
extension OtherProfileVC : UICollectionViewDelegate , UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if self.otherProfileData.userImages!.count <= 4{
             return self.otherProfileData.userImages!.count
        }else{
            return 4
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1.0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (screenWidth / 4) - 10 , height: screenWidth / 4 - 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 7
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "otherProfileImageCell", for: indexPath) as! OtherProfileImageCell
        
         cell.savedImageView.setImageWithStringURL(URL: (self.otherProfileData.userImages?[indexPath.row].imageUrl)!, placeholder: UIImage(named : "pramotionalPlaceholder")!)
        cell.likeCountLabel.text = self.otherProfileData.userImages?[indexPath.row].like
        
        cell.viewsCountLabel.text = self.otherProfileData.userImages?[indexPath.row].views
       
        cell.setLikeButtonImage(isLiked: (self.otherProfileData.userImages?[indexPath.row].islike)!)

        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
        self.popMenuBackView.isHidden = true
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as! ImagecommentVC
        vc.imgUrl = self.otherProfileData.userImages?[indexPath.row].imageUrl
        vc.ImgId = self.otherProfileData.userImages?[indexPath.row].imageId
        vc.likeDelegate = self
        vc.index = indexPath.row
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        
    }
}


extension OtherProfileVC : LikeBack{
    func getLikeBack( index: Int,isLiked: String,totalLikeCount totalCount : String,totalViews:String) {
        printDebug(object: "like back \(isLiked)....\(index)")
        
        self.otherProfileData.userImages?[index].islike = isLiked
        printDebug(object: ">>>>>>>>")
        printDebug(object:self.otherProfileData.userImages?[index].islike)
        
        self.otherProfileTableView.reloadData()
    }
}

extension OtherProfileVC{
    
    func getOthersProfile(){
     
        let params : jsonDictionary = ["userid" : CurentUser.userId as AnyObject , "viewUserId" : self.userId as AnyObject]
        
        print(params)
        
        CommonFunction.showLoader(vc: self)
        UserService.otherProfileApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    self.otherProfileTableView.isEditing = false
                    self.profileImageBackView.isHidden = false

                    printDebug(object: data)
                    
                    self.otherProfileData = data
                    
                    self.nameLabel.text = self.otherProfileData.username?.localizedUppercase
                    
                    self.screenNameLabel.text = self.otherProfileData.username?.localizedUppercase
                    
//                    if self.otherProfileData.isProfilePicAvailable == "1"{
//                        self.profileImageView.contentMode = .scaleAspectFit
//                    }else{
//                        self.profileImageView.contentMode = .center
//                    }
                    
                 printDebug(object: "before\(self.profileImageView.bounds)")
            self.profileImageView.setImageWithStringURL(URL: self.otherProfileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder2")!)
                    
                printDebug(object: "after\(self.profileImageView.bounds)")
                    
                    
                    //self.profileImageView.image.
                    
                    
                    //self.namelabel.text = self.profileData.username
                  
                    if self.otherProfileData.isfollowed == "1"{
                    
                        self.followUnfollowButton.setImage(UIImage(named : "followIcon"), for: UIControlState.normal)
                    }else{
                        self.followUnfollowButton.setImage(UIImage(named : "unfollowIcon"), for: UIControlState.normal)
                    }
    
                    self.profileImageView.setImageWithStringURL(URL: self.otherProfileData.userImage!, placeholder: UIImage(named : "profilePlaceHolder2")!)
                    
                    self.otherProfileTableView.delegate = self
                    self.otherProfileTableView.dataSource = self
                    self.otherProfileTableView.reloadData()
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
            }
            
        }
        
    }
    
    
    func blockUser(type : String,reason:String){
        
        var params : jsonDictionary = ["userId" : CurentUser.userId  as AnyObject , "blockUsersId" : self.userId as AnyObject , "blockType" : type as AnyObject , "reason" : "Blocked" as AnyObject]
        
        if type == "2"{
         
            params["reason"] = reason as AnyObject?
        }
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.blockApi(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
//                _ = self.navigationController?.popViewController(animated: true)
                if let _ = self.index{
                self.followBackDelegate.removeBlockedUserStream!(index: self.index)
                    
                }
                _ = self.navigationController?.popToRootViewController(animated: true)
                
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
    
    func followButtonTapped(){

        
        if self.otherProfileData.isfollowed == "0"{
        
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId:self.userId, followType: "1",name : self.otherProfileData.name! , vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.otherProfileData.isfollowed = "1"
                     self.followUnfollowButton.setImage(UIImage(named : "followIcon"), for: UIControlState.normal)
                    guard let _ = self.followBackDelegate else{
                     return
                    }
                    self.followBackDelegate.getFollowUnFollowBack!(isFollow: self.otherProfileData.isfollowed ?? "0" , index: self.index)

                }else{
                    
                }
                
            }
        }else{
            CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId:self.userId, followType: "0",name : self.otherProfileData.name! , vcObj: self,isFollowFromFeed: false){ (success) in
                
                if success{
                    self.otherProfileData.isfollowed = "0"
                   self.followUnfollowButton.setImage(UIImage(named : "unfollowIcon"), for: UIControlState.normal)
                    
                    guard let _ = self.followBackDelegate else{
                    
                     return
                    }
                    self.followBackDelegate.getFollowUnFollowBack!(isFollow: self.otherProfileData.isfollowed ?? "0" , index: self.index)

                    
                }else{
                    
                }
            }
        }
    }

    
    func likeDisLikeFeed(index : Int , broadcastId:String,like:String){
        
        CommonWebService.sharedInstance.likeDislikeFeed(vcObj: self, broadcastId: broadcastId, like: like) { (success, totalKikes) in
            if success{
                
               
                
               //  self.feeds[index].likes = totalKikes
                
              //   self.feedTableView.reloadRows(at:[IndexPath(row:index, section: 0)], with:UITableViewRowAnimation.none)
                
                
            }else{
                
            }
            
        }
        
    }
    

    
}


class OtherProfileImageCell : UICollectionViewCell{
    
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var viewsCountLabel: UILabel!
    @IBOutlet weak var savedImageView: UIImageView!
    
    @IBOutlet weak var likeImageView: UIImageView!
    
    @IBOutlet weak var viewImageView: UIImageView!
    
    override func awakeFromNib() {
        self.savedImageView.layer.cornerRadius = 5.0
        self.savedImageView.clipsToBounds = true
        self.layer.cornerRadius = 5.0
        self.clipsToBounds = true
    }
    
    func setLikeButtonImage(isLiked:String){
        if isLiked == "1"{

            self.likeImageView.image = UIImage(named : "liked")
            
        }else{
            self.likeImageView.image = UIImage(named : "ic_otherprofile_like")
            
        }
    }
    
}

class PopMenuCell : UITableViewCell{
    
    
    @IBOutlet weak var menuLabel: UILabel!
    
}
