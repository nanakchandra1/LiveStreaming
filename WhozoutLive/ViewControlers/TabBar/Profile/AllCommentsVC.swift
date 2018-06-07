
import UIKit


enum AllCommentsFrom{
    
    case Image
    case Feed
    case None
}

class AllCommentsVC: UIViewController {
    
    
    var comments : [ImageCommentData] = []
    var ImgId : String!
    var from = AllCommentsFrom.None
    var keyboard : EmogieKeyBoardVC!
    var streamedata : DisplayImageData!
    var serviceHit = false
    
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var emogiesButton: UIButton!
    @IBOutlet weak var allCommentstableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var commentsBackView: UIView!
    @IBOutlet weak var commentBackViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var noDataImage: UIImageView!
    @IBOutlet weak var noDataLabel: UILabel!
    
    @IBOutlet weak var commentsTableViewBottom: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUpSubView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    
    @IBAction func emogiesButtontapped(_ sender: UIButton) {
        
        if self.commentTextView.text.isEmpty{
            
            self.addKeyBoard()
            
        }else{
            
            self.postComment(cmt: self.commentTextView.text,type: "0")
        }
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        
        self.postComment(cmt: "58d518d2da283dbc99932e82", type: "1")
        
        //  CommonFunction.floatEmogie(id: "58d518d2da283dbc99932e82")
        
        
    }
    
    @IBAction func backButtontapped(_ sender: UIButton) {
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
}


private extension AllCommentsVC{
    
    func setUpSubView(){
        
        self.allCommentstableView.register( UINib(nibName: "AllCommentsCell", bundle: nil), forCellReuseIdentifier: "allCommentsCell")
        
        self.allCommentstableView.delegate = self
        self.allCommentstableView.dataSource = self
        self.commentTextView.delegate = self
        
        if self.from == .Feed{
            
            self.commentBackViewHeight.constant = 0
            self.getStreamComments(isFirst: true,isScrollToLast: true)
            
        }else{
            self.commentBackViewHeight.constant = 50
            
            self.getComments(isFirst: true,id: self.ImgId,isScrollToLast: true)
            
        }
    }
    
    
    
    //MARK:- Add age pop up
    //=======================
    func addKeyBoard(){
        self.keyboard = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "EmogieKeyBoardID") as! EmogieKeyBoardVC
        self.keyboard.emogieDelegate = self
        CommonFunction.addChildVC(childVC: self.keyboard,parentVC: self)
        
        self.commentBackViewHeight.constant = 220
        
        if self.comments.count > 0{
            
            self.allCommentstableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
            
        }
        
        self.keyboard.view.frame = CGRect(x: 0, y: screenHeight - 200 , width: screenWidth, height: 200)
        
        
    }
}


extension AllCommentsVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
        // return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let height = CommonFunction.getTextHeight(text: self.comments[indexPath.row].comment!, font: AppFonts.lotoRegular.withSize(13), width: screenWidth - 78)
        
        return height + 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "allCommentsCell") as! AllCommentsCell
        
        cell.commentLabel.text = self.comments[indexPath.row].comment
        
        
        cell.showEmogieOrText(type:  self.comments[indexPath.row].commentType!, emogieId: self.comments[indexPath.row].comment!)
        
        if self.comments[indexPath.row].imageUrl! != URLName.demoUrl{
            cell.profileImageView.setImageWithStringURL(URL: self.comments[indexPath.row].imageUrl!, placeholder: UIImage(named: "userPlaceholder")!)
            
            
        }else{
            cell.profileImageView.image = UIImage(named : "userPlaceholder")
        }
        
        
        cell.nameLabel.text = self.comments[indexPath.row].name
        
        let timeStampValue = Double(self.comments[indexPath.row].dateCreated ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        cell.timeLabel.text = Date().timeFrom(date:date as Date)
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let _ = self.streamedata{
            if self.streamedata.next == "1" && indexPath.row == 0 && self.comments.count >= 9{

                if self.from == .Feed{
                    self.getStreamComments(isFirst: false,isScrollToLast: false)
                }else{
                self.getComments(isFirst: false,id: self.ImgId,isScrollToLast: false)
                }
            }
        }
    }
 
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if (self.allCommentstableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)))!{
            printDebug(object: "row displayed")
            if let _ = self.streamedata{
                if self.streamedata.next == "1" && self.comments.count >= 9{
                    
                    if self.from == .Feed{
                        if self.serviceHit{
                        self.getStreamComments(isFirst: false,isScrollToLast: false)
                        }
                    }else{
                        if self.serviceHit{
                        self.getComments(isFirst: false,id: self.ImgId,isScrollToLast: false)
                        }
                    }
                }
            }
            
        }
    }
    
    
}

//MARK:- Textview delegate
//============================
extension AllCommentsVC : UITextViewDelegate{
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        printDebug(object: textView.text)
        
        if text == " " && range.location == 0
        {
            
            return false
            
        }else{
            
            CommonFunction.delayy(delay: 0.1) {
                
                if textView.text.isEmpty{
                    self.emogiesButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
                }else{
                    self.emogiesButton.setImage(UIImage(named: "sendIcon"), for: .normal)
                }
            }
            
            return true
        }
    }
    
}



extension AllCommentsVC : CommentEmogie{

    func sendEmogie(id: String, price: Int, image: UIImage, dimension: String,catagoryType:String,smileyType:String) {
    
        if let tok = CurentUser.tokenCount{
            
            
            if Int(tok)! > price{

                
                let leftToken = Int(tok)! - price
                
                
                AppUserDefaults.save(value: "\(leftToken)", forKey:AppUserDefaults.Key.TokenCount)
                
                self.postComment(cmt: id, type: "1")
                
            }else{
                
                let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
                
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }else{
            
            
        }
        
    }
    
    func tokenFinished(){
        
        let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
        
        vc.purchaseFrom = .EmogieKeyBoard
        
        self.navigationController?.pushViewController(vc, animated: true)
        
        
    }
    
    
    func removeKeyBoard(){
     self.commentBackViewHeight.constant = 50
        
        //        self.isEmojiKeboardShown = false
        //        self.bottomView.isHidden = false
        //        self.view.bringSubview(toFront: self.bottomView)
    }
    
    
}


//MARK:- Webservices
//=====================
extension AllCommentsVC{
    //MARK:- Get all commentsTableView
    //==============================
    func getComments(isFirst : Bool,id:String,isScrollToLast:Bool){
        printDebug(object: "All Image comments......")
        
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject  ,"mediaId" : self.ImgId as AnyObject,"mediaType" : "0" as AnyObject]
        
        if let _ = self.streamedata{
            params["limit"] = self.streamedata.limit as AnyObject?
        }else{
            params["limit"] = "0" as AnyObject?
        }
        
        if isFirst{
            CommonFunction.showLoader(vc: self)
        }
        
         self.serviceHit = false

        UserService.getCommentsApi(params: params) { (success, data, messahe) in
             self.serviceHit = true
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    
                    self.streamedata = data
                  //  self.comments.append(contentsOf: self.streamedata.comments!)
                    
                    
                    _ = self.streamedata.comments!.map { (obj)  in
                        
                        self.comments.insert(obj, at: 0)
                        
                        
                    }
                    
                    
                  
                    
                    
                    if self.comments.isEmpty{
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                        self.noDataLabel.text = messahe
                        
                    }else{
                        self.noDataImage.isHidden = true
                        self.noDataLabel.isHidden = true
                        self.noDataLabel.text = ""
                        
                    }
                    
                    
                    self.allCommentstableView.reloadData()
                    
                    if self.comments.count > 0 && isScrollToLast{
                        
                        self.allCommentstableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        
                        self.allCommentstableView.reloadData()
                        
                    }
                    
                }
                
            }else{
            self.noDataLabel.text = messahe
                CommonFunction.hideLoader(vc: self)
                
                if self.comments.isEmpty{
                    self.noDataImage.isHidden = false
                    self.noDataLabel.isHidden = false
                }
            }
        }
    }
    
    
    func getStreamComments(isFirst : Bool,isScrollToLast:Bool){
        printDebug(object: "All stream comments......")
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject  ,"mediaId" : self.ImgId as AnyObject,"limit" : "0" as AnyObject,"mediaType" : "1" as AnyObject]
        
        
        if let _ = self.streamedata ,!isScrollToLast {
            params["limit"] = self.streamedata.limit as AnyObject?
        }else{
            params["limit"] = "0" as AnyObject?
        }
        
        if isFirst{
            CommonFunction.showLoader(vc: self)
        }

      printDebug(object: "all comments params \(params)")
        UserService.getCommentsApi(params: params) { (success, data, message) in
            CommonFunction.hideLoader(vc: self)

            if success{
                CommonFunction.hideLoader(vc: self)
                if let data = data{
                    //self.comments.removeAll()
                    
                    if isScrollToLast{
                        self.comments.removeAll()

                    }
                    
                    self.streamedata = data
                    //self.comments.append(contentsOf: self.streamedata.comments!)
                    
                    
                    
                    _ = self.streamedata.comments!.map { (obj)  in
                        
                        self.comments.insert(obj, at: 0)
                        
                        
                    }
                    
                    
                    self.allCommentstableView.reloadData()
                    
                    if self.comments.isEmpty{
                        self.noDataImage.isHidden = false
                        self.noDataLabel.isHidden = false
                        self.noDataLabel.text = ""
                    }else{
                        self.noDataImage.isHidden = true
                        self.noDataLabel.isHidden = true
                        self.noDataLabel.text = ""
                    }
                    
                    if self.comments.count > 0 && isScrollToLast{
                        self.allCommentstableView.scrollToRow(at:
                            IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                    }
                }
            }else{
                self.noDataLabel.text = message
                CommonFunction.hideLoader(vc: self)

                if self.comments.isEmpty{
                self.noDataImage.isHidden = false
                self.noDataLabel.isHidden = false
                }
            }
        }
    }
    
    
    //MARK:- Post comment Webservices
    //=================================
    func postComment(cmt : String,type:String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject, "imageId" : self.ImgId as AnyObject,"comment" : cmt as AnyObject,"commentType" : type as AnyObject,"userName" : CurentUser.userName as AnyObject]
        
        UserService.postCommentApi(params: params) { (success, data, message) in
            
            if success{
                self.noDataImage.isHidden = true
                self.noDataLabel.isHidden = true
                self.noDataLabel.text = ""
                self.commentTextView.text = ""
                self.view.endEditing(true)
                self.emogiesButton.setImage(UIImage(named: "sendIcon"), for: .normal)
                self.emogiesButton.setTitle("", for: UIControlState.normal)
                
                data?.imageUrl = CurentUser.userImage
                self.comments.append(data!)
                self.comments.last?.dateCreated = data?.dateCreated
                self.allCommentstableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: UITableViewRowAnimation.none)
                
                 self.allCommentstableView.scrollToRow(at: IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                
               // self.allCommentstableView.reloadData()
                
                
                self.emogiesButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
                
                if Networking.isConnectedToNetwork{
                    //self.getComments(isFirst: false,id: self.ImgId,isScrollToLast: true)
                    
                }else{
                    CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
                }
            }else{
                
            }
        }
        
    }
    
}

