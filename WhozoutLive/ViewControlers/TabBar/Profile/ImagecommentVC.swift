

import UIKit
import SAConfettiView

class ImagecommentVC: UIViewController {
    
    //MARK:-Variables
    //====================
    var imagedata : DisplayImageData!
    var comments : [ImageCommentData] = []
    var imgUrl : String!
    var ImgId : String!
    var index : Int!
    var commentFieldIsEmpty = true
    var likeDelegate : LikeBack!
    var keyboard : EmogieKeyBoardVC!
    var confettiView: SAConfettiView!
    var serviceHit : Bool = true

    
    //MARK:- IBOutlets
    //==================
    @IBOutlet weak var pramotionalImageView: UIImageView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    @IBOutlet weak var commentsBackView: UIView!
    @IBOutlet weak var commentsBackViewHeight: NSLayoutConstraint!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var emogiesButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeListButton: UIButton!
    @IBOutlet weak var downloadButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var commentsBackViewBottom: NSLayoutConstraint!
    
    
    //MARK:- View life cycle
    //==========================
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        if Networking.isConnectedToNetwork{
            self.getComments(isFirst: true,isScrollToLast: true,isFromPostComment: false)
        }else{
            CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
        }
    }
    
    
    @IBAction func commentsbuttonTapped(_ sender: UIButton) {
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AllCommentsID") as! AllCommentsVC
        vc.ImgId = self.ImgId
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func likeButtontapped(_ sender: UIButton) {
        if self.imagedata.isLiked == "1"{
            self.imagedata.isLiked = "0"
            self.setLikeButtonImage(isLiked: "0")
            
            self.imagedata.likeCount = "\(Int(self.imagedata.likeCount!)! - 1)"
            
            self.likeButton.setTitle( self.imagedata.likeCount, for: UIControlState.normal)
            
            self.likeDisLikeImage(imagesId: self.ImgId, like: "0")
        }else{
            self.imagedata.isLiked = "1"
            self.setLikeButtonImage(isLiked: "1")
            self.imagedata.likeCount = "\(Int(self.imagedata.likeCount!)! + 1)"
            
            self.likeButton.setTitle( self.imagedata.likeCount, for: UIControlState.normal)
            self.likeDisLikeImage(imagesId: self.ImgId, like: "1")
        }
    }
    
    @IBAction func likeListButtontapped(_ sender: UIButton) {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId = self.ImgId
        vc.type = .ImageLikeList
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func viewsButtonTapped(_ sender: UIButton) {
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId = self.ImgId
        vc.type = .ImageViews
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    @IBAction func backButtontapped(_ sender: UIButton) {
        self.pramotionalImageView.isHidden = true
        if let _ = self.imagedata{
        
        guard let _ = self.imagedata.isLiked else{
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        guard let _ = self.index else{
            _ = self.navigationController?.popViewController(animated: true)
            
            return
        }
        
        self.likeDelegate.getLikeBack(index: self.index, isLiked: self.imagedata.isLiked!, totalLikeCount: self.imagedata.likeCount!, totalViews: self.imagedata.viewCount!)
        
        _ = self.navigationController?.popViewController(animated: true)
            
        }else{
            _ = self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    @IBAction func emogiesButtontapped(_ sender: UIButton) {
       // self.view.endEditing(true)
        if   self.commentFieldIsEmpty == false{
            
            if Networking.isConnectedToNetwork{
                self.postComment(cmt: self.commentTextView.text,type: "0", emojiOrRain: "0")
                
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            }
            
        }else{
            
            self.addKeyBoard()
            
        }
        
        
    }
    
    
    @IBAction func thumbButtonTapped(_ sender: UIButton) {
        
        self.postComment(cmt: "58d518d2da283dbc99932e82", type: "1", emojiOrRain: "0")
        
    }
    
    @IBAction func downloadButtontapped(_ sender: UIButton) {
        
        self.downloadImage()
        
    }
}

//MARK:- Private functions
//==========================
private extension ImagecommentVC{
    
    func setUpSubView(){
        let cellNib = UINib(nibName: "CommentCell", bundle: nil)
        self.commentsTableView.register(cellNib, forCellReuseIdentifier: "commentCell")
        self.commentsTableView.estimatedRowHeight = 50
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        self.commentTextView.autocorrectionType = .no
        self.commentsBackViewHeight.constant = 0
        self.commentTextView.returnKeyType = .done
        self.emogiesButton.setTitleColor(AppColors.pinkColor, for: UIControlState.normal)
        
        self.pramotionalImageView.image = UIImage(named: "pramotionalPlaceholder")
        
//        self.pramotionalImageView.isHidden = true
//        self.bottomView.isHidden = true
        
        self.commentTextView.delegate = self
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        
     //   self.pramotionalImageView.contentMode = .scaleAspectFit
        
    }
    
    func scrollTableViewToLast(){
        
        self.commentsTableView.scrollToRow(at:
            IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
    }
    
    func setTableViewHeight(){
       
        if  self.comments.count < 4{
            self.commentsBackViewHeight.constant = CGFloat(self.comments.count * 32)
        }else{
            self.commentsBackViewHeight.constant = 128
        }
        
//        if  self.commentsBackViewHeight.constant < 128{
//             self.commentsBackViewHeight.constant = self.commentsTableView.contentSize.height
//        }else{
//            self.commentsBackViewHeight.constant = 128
//        }
        
        
    }
    
    func setLikeButtonImage(isLiked:String){
        if isLiked == "1"{
            self.likeButton.setImage(UIImage(named : "liked"), for: UIControlState.normal)
            
        }else{
            self.likeButton.setImage(UIImage(named : "like"), for: UIControlState.normal)
            
        }
    }
    
    //MARK:- Add age pop up
    //=======================
    func addKeyBoard(){
        self.keyboard = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "EmogieKeyBoardID") as! EmogieKeyBoardVC
        self.keyboard.emogieDelegate = self
        CommonFunction.addChildVC(childVC: self.keyboard,parentVC: self)
        self.commentsBackViewBottom.constant = 110
        self.keyboard.view.frame = CGRect(x: 0, y: screenHeight - 200 , width: screenWidth, height: 200)
    }
}


extension ImagecommentVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
        // return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.comments[indexPath.row].commentType == "1"{
            return 30
        }else{
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        
       // cell.caleulateNameWidth(name: self.comments[indexPath.row].name!,type: self.comments[indexPath.row].commentType!)
        
        cell.nameLabel.text = self.comments[indexPath.row].name
        cell.commentLabel.text = self.comments[indexPath.row].comment
        cell.timeLabel.textAlignment = .right
        
        cell.showEmogieOrText(type:  self.comments[indexPath.row].commentType!, emogieId: self.comments[indexPath.row].comment!, emojiOrRain: self.comments[indexPath.row].emojiOrRain!)
        
        cell.timeLabel.textAlignment = .right

        let timeStampValue = Double(self.comments[indexPath.row].dateCreated ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        cell.timeLabel.text = Date().timeFrom(date:date as Date)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let _ = self.imagedata{
//            if self.imagedata.next == "1" && indexPath.row == 0 && self.comments.count >= 9{
//                self.getComments(isFirst: false,isScrollToLast: false,isFromPostComment: false)
//            }
//        }
//    }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (self.commentsTableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)))!{
            printDebug(object: "row displayed")
            if let _ = self.imagedata{
                if self.imagedata.next == "1" && self.comments.count >= 9{
                     if self.serviceHit{
                    self.getComments(isFirst: false,isScrollToLast: false,isFromPostComment: false)
                    }
                }
            }
        }
    }
    
    
}

//MARK:- Textview delegate
//============================
extension ImagecommentVC : UITextViewDelegate{
    
    func textViewShouldReturn(_ textView: UITextView!) -> Bool{
        //self.view.endEditing(true);
        
        //self.postComment(cmt: self.commentTextView.text,type: "0")
        return true;
    }
    
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        printDebug(object: textView.text)
        
        if text == " " && range.location == 0{
            
            return false
            
        }else{
            
            CommonFunction.delayy(delay: 0.1) {
                
                if textView.text.isEmpty{
                    self.commentFieldIsEmpty = true
                    self.emogiesButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
                }else{
                    self.commentFieldIsEmpty = false
                    self.emogiesButton.setImage(UIImage(named: "sendIcon"), for: .normal)
                }
                
            }
            
            return true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        self.view.endEditing(true);
        
        if !textView.text.isEmpty{
            let timeStamp = Date().timeIntervalSinceNow
            
            printDebug(object: timeStamp)
            
            printDebug(object:"timestamp======\(timeStamp)")
            
        }
    }
}



extension ImagecommentVC : CommentEmogie{
  

    func sendEmogie(id: String, price: Int, image: UIImage, dimension: String, catagoryType: String,smileyType:String) {
        
        printDebug(object: "smileyType....\(smileyType)")
        
        if let tok = CurentUser.tokenCount{
            
            if Int(tok)! > price{
                
                let leftToken = Int(tok)! - price
                
                AppUserDefaults.save(value: "\(leftToken)", forKey:AppUserDefaults.Key.TokenCount)
                
                if smileyType == "1"{
                    self.postComment(cmt: id, type: "1", emojiOrRain: "1")

                }else{
                    self.postComment(cmt: id, type: "1", emojiOrRain: "0")

                }
                
                
            }else{
                DispatchQueue.main.async {
                    
                    let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
                    vc.purchaseFrom = .EmogieKeyBoard
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
                
            }
            
        }else{
            
            
        }
        
        
    }
    
    func tokenFinished(){
        
        let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func removeKeyBoard(){
        self.commentsBackViewBottom.constant = 0
        
        //        self.isEmojiKeboardShown = false
        //        self.bottomView.isHidden = false
        //        self.view.bringSubview(toFront: self.bottomView)
    }
}



//MARK:- Webservices
//=====================
extension ImagecommentVC{
    //MARK:- Get all commentsTableView
    //==============================
    func getComments(isFirst : Bool,isScrollToLast:Bool,isFromPostComment:Bool){
        printDebug(object: "comm")
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject  ,"mediaId" : self.ImgId as AnyObject,"limit" : "0" as AnyObject,"mediaType" : "0" as AnyObject]
        
        
        if let _ = self.imagedata , !isFromPostComment {
            params["limit"] = self.imagedata.limit as AnyObject?
        }else{
            params["limit"] = "0" as AnyObject?
        }
        
        if isFromPostComment || isFirst{
            params["limit"] = "0" as AnyObject?
        }
        
        printDebug(object: "params is \(params)")
        
        if isFirst{
            CommonFunction.showLoader(vc: self)
        }
        
        self.serviceHit = false

        UserService.getCommentsApi(params: params) { (success, data, message) in
            
              self.serviceHit = true
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    
                    if isFromPostComment || isFirst{
                        self.comments.removeAll()
                    }
                    
                    self.imagedata = data
                    
                
                  //  self.imagedata.comments?.append(contentsOf: self.comments)
                    
                    
                    _ = self.imagedata.comments!.map { (obj)  in
                        
                        self.comments.insert(obj, at: 0)
                        
                        
                    }

                self.likeCountButton.setTitle(self.imagedata.likeCount, for: UIControlState.normal)
                    
                    self.setLikeButtonImage(isLiked: self.imagedata.isLiked!)
                    self.commentsButton.setTitle(self.imagedata.commentCount, for: UIControlState.normal)
                    
                    self.viewsButton.setTitle(self.imagedata.viewCount, for: UIControlState.normal)
                    
                    self.downloadButton.setTitle(self.imagedata.downloadCount, for: UIControlState.normal)
                    
                    self.pramotionalImageView.setImageWithStringURL(URL: self.imagedata.imageUrl! , placeholder: UIImage(named: "pramotionalPlaceholder")!)
//                    
//                    self.pramotionalImageView.isHidden = false
//                    self.bottomView.isHidden = false
                    
                    
                    self.commentsTableView.reloadData()
                    
                    if (self.comments.count) > 0 && isScrollToLast{
                        self.commentsTableView.scrollToRow(at: IndexPath(row: (self.imagedata.comments?.count)! - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                    }
                    
                    
                    self.setTableViewHeight()
                    self.viewImageService()
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
//                self.pramotionalImageView.isHidden = false
//                self.bottomView.isHidden = false
                

            }
        }
    }
    
    //MARK:- Post comment Webservices
    //=================================
    func postComment(cmt : String,type:String,emojiOrRain:String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject, "imageId" : self.ImgId as AnyObject,"comment" : cmt as AnyObject,"commentType" : type as AnyObject,"userName" : CurentUser.userName as AnyObject,"emojiOrRain" : emojiOrRain as AnyObject]
        
        
        UserService.postCommentApi(params: params) { (success, data, message) in
            
            
            if success{
               

                self.commentTextView.text = ""
               // self.view.endEditing(true)
                self.emogiesButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
                self.commentFieldIsEmpty = true
                self.emogiesButton.setTitle("", for: UIControlState.normal)
                
                self.comments.last?.dateCreated = data?.dateCreated
                
              //  self.commentsTableView.reloadData()
                
                
                let comment = ["comment" : cmt as AnyObject,"commentType" : type as AnyObject,"dateCreated" : "\( CommonFunction.getTimeStampFromDate(date: Date()) * 1000)" as AnyObject,"name" : CurentUser.userName as AnyObject,"userId" : CurentUser.userId as AnyObject,"emojiOrRain" : emojiOrRain as AnyObject]
                
                
                if Networking.isConnectedToNetwork{
                    
                    //self.getComments(isFirst: false,isScrollToLast: true,isFromPostComment: true)
                    let imgCmt = ImageCommentData(commentsData: comment)

                    self.comments.append(imgCmt)
                    self.commentsTableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: UITableViewRowAnimation.none)
                     self.setTableViewHeight()
                    self.scrollTableViewToLast()
                }else{
                    CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
                }
                //self.commentsTableView.reloadData()
                
        
            }else{
                
            }
        }
    }
    
    
    func likeDisLikeImage(imagesId:String,like:String){
        
        CommonWebService.sharedInstance.likeDislikeImage(vcObj: self, imagesId: imagesId, like: like) { (success, totalKikes) in
            if success{
                
                printDebug(object: "my count---...>>>>\(String(describing: totalKikes))")
                
                self.imagedata.likeCount = totalKikes
                
                self.likeCountButton.setTitle( self.imagedata.likeCount, for: UIControlState.normal)
                
                
            }else{
                
            }
            
        }
        
    }
    
    
    
    func viewImageService(){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject,"imageId" : self.ImgId as AnyObject]
        
        
        UserService.viewImageApi(params: params) { (success, viewCount) in
            if success{
                
                if let count = viewCount{
                    
                    printDebug(object: "views count.........>>>....>>>\(count)")
                    
                    printDebug(object: self.imagedata.viewCount)
                    
                    self.imagedata.viewCount = count
                    
                    //  printDebug(object: self.imagedata.viewCount)
                    
                    self.viewsButton.setTitle(self.imagedata.viewCount, for: UIControlState.normal)
                }else{
                    
                    
                }
                
            }else{
                
                
            }
        }
        
    }
    
    func downloadImage(){
        UIImageWriteToSavedPhotosAlbum(self.pramotionalImageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "imageId" : self.ImgId as AnyObject]
        CommonFunction.showLoader(vc: self)
        UserService.downloadImage(params: params) { (success, count) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                
                printDebug(object: "downcount.......\(String(describing: count))")
                
                guard let cnt = count else{
                    return
                }
                
                self.downloadButton.setTitle("\(cnt)", for: UIControlState.normal)
                
                UIImageWriteToSavedPhotosAlbum(self.pramotionalImageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                
            }else{
                CommonFunction.hideLoader(vc: self)
                
                UIImageWriteToSavedPhotosAlbum(self.pramotionalImageView.image!, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
                
                
            }
        }
        CommonFunction.hideLoader(vc: self)
        
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        
        printDebug(object: "Finished")
        
        CommonFunction.showTsMessageSuccess(message: "Image has been added to your photos.")
        
    }
    
    
    
}

