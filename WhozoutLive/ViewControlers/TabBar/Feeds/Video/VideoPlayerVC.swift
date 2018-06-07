

import UIKit
import AVKit
import AVFoundation
import NotificationCenter
import Starscream
import SAConfettiView


enum VideoPlayerFrom{
    case Feeds
    case Notification
    case Push
    case None
}

@objc protocol CutWhileWatchingDelegate {
    
    func cutWhileWatching()
    
}

class VideoPlayerVC : UIViewController {
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var numberOfTokenLeft: UILabel!
    @IBOutlet weak var namelabel: UILabel!
    @IBOutlet weak var tokenleftlabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var nameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var overLayView: UIImageView!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var viewsButton: UIButton!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var emogieButton: UIButton!
    @IBOutlet weak var commentsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var thumbsUpButton: UIButton!
    @IBOutlet weak var bottomView: UIView!
    
    @IBOutlet weak var frameLabel: UILabel!
    
    @IBOutlet weak var tokenButtonTapped: UIButton!
    
    
    var player : AVPlayer?
    var playerLayer: AVPlayerLayer!
    var timeObserver: AnyObject!
    let seekSlider = UISlider()
    var playerRateBeforeSeek: Float = 0
    var blureViewFlag = true
    var videoLogoView: UIImageView!
    var imgUrl : String!
    var name : String!
    var tapVideo : UITapGestureRecognizer!
    var videoUrl : String!
    var videoDescription : String!
    var broadcastId : String!
    var isBackBtnPressed = false
    var isVideoPlaying = false
    var isFollow : Int!
    var followUserId : String!
    var feedObj : FeedsData!
    var commmingFrom = VideoPlayerFrom.None
    weak var likeBackDelegate : GetDataBack?
    var totalTokens:Int = 0
    //var getfollowDelegateBack : UpdateFollowStatus!
    
    var keyboard : EmogieKeyBoardVC!
    var confettiView: SAConfettiView?
    var commentFieldIsEmpty = true
    var streamedata : DisplayImageData!
    var comments : [ImageCommentData] = []
    var timeElapsed : Int = 0
    var streamType : String = "0"
    var perMinuteToken : Int = 0
    var rainTimer : Timer?
    var rainTimeElapsed : Int = 0
    var isEmojiKeboardShown = false
    let activityIndicator = UIActivityIndicatorView()
    var ghostBanIds : StringArray = []
    var emogiImageArray = [UIImage]()
    var serviceHit : Bool = true
    fileprivate var rainPendingArray : StringArray = []
    let rewindTimelineView = TimelineView()
    
    
    
    @IBAction func moreBtnTapped(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        let report = UIAlertAction(title: "Report", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.reportAbuseUser()
            
        })
        
        let block = UIAlertAction(title: "Block", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            self.blockUser()
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(report)
        optionMenu.addAction(block)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
        
    }
    
    func reportAbuseUser() {
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ReportAbuseID") as! ReportAbuseVC
        vc.reportDelegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func blockUser() {
        
        
        self.showAlert(blockType:1, title: "Block User", message: "Are you sure you wan't to block this user?")
        
    }
    
    func showAlert(blockType:Int,title : String,message : String ){
        
        _ = VKCAlertController.alert(title: title, message: message, buttons: ["No","Yes"], tapBlock: { (_, index) in
            
            if index == 1{
                
                printDebug(object: blockType)
                
                self.blockUser(type: "\(blockType)",reason: "")
            }else{
                
            }
            
        })
    }
    
    override func viewDidLayoutSubviews() {
        self.profileImageView.layer.cornerRadius = self.profileImageView.frame.height / 2
        self.profileImageView.clipsToBounds = true
        self.tokenleftlabel.layer.cornerRadius = 3.0
        self.tokenleftlabel.clipsToBounds = true
        self.tokenleftlabel.layer.borderColor = AppColors.pinkColor.cgColor
        self.tokenleftlabel.layer.borderWidth = 1.0
        
    }
    
    //MARK:- view life cycle
    //========================
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.commentTextView.keyboardType = .asciiCapable
        self.setUpSubView()
        self.setUpVideo()
   
        self.activityIndicator.frame = CGRect(x:(screenWidth / 2) - 50, y: (screenHeight / 2) - 50, width: 100, height: 100)
       // self.activityIndicator.backgroundColor = UIColor.blue
       
        self.resolutionSetup(url:self.videoUrl)
        
        ShowVideoControls.shoeControls = .Show
        self.activityIndicator.startAnimating()
        self.view.addSubview(self.activityIndicator)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.setCountValues()
        
    self.addKeyBoardSetup()
        
        UIApplication.shared.isStatusBarHidden = true
        SocketHelper.sharedInstance.socket.delegate = self
        SocketHelper.sharedInstance.socket.pongDelegate = self

        if let tokens = CurentUser.tokenCount{
            
            self.totalTokens = Int(tokens)!
        }else{
            self.totalTokens = 0
        }

        self.tokenleftlabel.text = "\(self.totalTokens) Tokens Left"
        
        self.timeElapsed = 0
        
        if self.imgUrl != URLName.demoUrl{
            self.profileImageView.setImageWithStringURL(URL: self.imgUrl ?? "", placeholder: UIImage(named: "userPlaceholder")!)
        }else{
            self.profileImageView.image = UIImage(named : "userPlaceholder")
        }
        
        self.commentsTableView.isHidden = true
        
        self.viewService()
        
        self.getComments(isFirst : true)
        
      self.player?.isMuted = false
      self.player?.play()
        
    }
    

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.setContainerFrame()
        printDebug(object: "layer bounds \(self.playerLayer.bounds)")
        
        printDebug(object: "video rect ....\(self.playerLayer.videoRect)")
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        UIApplication.shared.isStatusBarHidden = false
        
        self.removeKeyBoard()
        
    }
    
    
    deinit {
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillEnterForeground, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object:nil )

        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemPlaybackStalled, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemTimeJumped, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object:nil )
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object:nil )
        
    }
    
   
    
    //MARK:- IBActions
    //===============
    @IBAction func emogieButtontapped(_ sender: UIButton) {
    self.view.endEditing(true)
        if   self.commentFieldIsEmpty == false{
            
            if Networking.isConnectedToNetwork{
                
                self.postCommentService(type: "0", comment:self.commentTextView.text,emojiOrRain: "0")
                
                 self.commentTextView.text = ""
                self.commentFieldIsEmpty = true
                self.emogieButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            }
            
        }else{
            
            self.addKeyBoard()
            
        }
        
    }
    
    
    @IBAction func followButtontapped(_ sender: UIButton) {
         CommonWebService.sharedInstance.userIdToFollow = self.followUserId
        CommonWebService.sharedInstance.followUnFollowService(userId: CurentUser.userId!, followId: self.followUserId,followType: "1", name : self.name , vcObj: self,isFollowFromFeed: false){ (success) in
            
            if success{
                self.plusButton.isHidden = true
            }else{
                
            }
        }
    }
    
    
    @IBAction func commentsButtontapped(_ sender: UIButton){
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "AllCommentsID") as! AllCommentsVC
        vc.ImgId = self.broadcastId
        vc.from = .Feed
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
        
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
        
        if self.feedObj.isliked == "1"{
            self.feedObj.isliked = "0"
            self.setLikeButtonImage(isLiked: "0")
            //self.likeDisLikeFeed(broadcastId: self.broadcastId, like: "0")
            
            let likeCount = Int(self.feedObj.likes!)! - 1
            self.feedObj.likes = "\(likeCount)"
            self.likeCountButton.setTitle("\(likeCount)", for: UIControlState.normal)
            
            self.likeFeed(like: "0")
            
        }else{
            self.feedObj.isliked = "1"
            self.setLikeButtonImage(isLiked: "1")
            //self.likeDisLikeFeed(broadcastId: self.broadcastId, like: "1")
            
            let likeCount = Int(self.feedObj.likes!)! + 1
            self.feedObj.likes = "\(likeCount)"
            self.likeCountButton.setTitle("\(likeCount)", for: UIControlState.normal)
            
            self.likeFeed(like: "1")
            
        }
        
    }
    
    @IBAction func likeCountButtonTapped(_ sender: UIButton) {
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId =  self.broadcastId
        vc.type = .FeedsLikeList
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func viewCountButtontapped(_ sender: UIButton){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "LikeAndViewsListID") as! LikeAndViewsListVC
        vc.mediaId =  self.broadcastId
        vc.type = .FeedsViews
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func thumbsUpButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)
        
        self.postCommentService(type: "1", comment: "58d518d2da283dbc99932e82", emojiOrRain: "0")
        
        CommonFunction.floatEmogie(id: "58d518d2da283dbc99932e82",isPlaySound: true, animationStartPosition:Float(self.commentsTableView.frame.origin.y),vcObj: self)
      
        CommonFunction.playSound(name: "bell",type: "mp3")

    }
    
   
    @IBAction func tokenLeftButtonTapped(_ sender: UIButton) {
        self.player?.pause()
        self.player?.isMuted = true
        CommonWebService.sharedInstance.pushPurchaseToken(from: PurchaseFrom.TokenLessButton)
    }
    
    
    func setCountValues(){
        self.viewFeeds()
        self.setLikeButtonImage(isLiked: (self.feedObj?.isliked!)!)
        
        self.likeCountButton.setTitle(self.feedObj.likes, for: UIControlState.normal)
        self.commentsButton.setTitle(self.feedObj.commentCount, for: UIControlState.normal)
        
        self.viewsButton.setTitle(self.feedObj.views, for: UIControlState.normal)
    }
    
    
    func setUpSubView(){
        
        self.commentTextView.autocorrectionType = .no
        
        self.player = AVPlayer()
        self.overLayView.image = UIImage(named: "ic_home_shadow")
        
        if self.isFollow == 1{
            self.plusButton.isHidden = true
        }else{
            self.plusButton.isHidden = false
        }
        
        let cellNib = UINib(nibName: "CommentCell", bundle: nil)
        self.commentsTableView.register(cellNib, forCellReuseIdentifier: "commentCell")
        self.commentsTableView.backgroundColor = UIColor.clear
        self.commentsTableView.estimatedRowHeight = 50
        self.commentsTableView.rowHeight = UITableViewAutomaticDimension
        self.commentsTableView.delegate = self
        self.commentsTableView.dataSource = self
        self.commentTextView.delegate = self
        
        if self.streamType == "2"{
            self.timeElapsed = 0
            CommonWebService.sharedInstance.cutTokenWhileWatching = self
            
            CommonWebService.sharedInstance.diductToken(broadCastId: self.broadcastId, vcObj: self, type: "2", from: .WatchingVideo, completionBlock: { (success) in
                
                if let tok = CurentUser.tokenCount{
                    
                    self.totalTokens = Int(tok)!
                    
                    printDebug(object: "totalTokens....\(self.totalTokens)")
                    
                    self.tokenleftlabel.text = "\(tok) Tokens Left"
                    
                      sharedAppdelegate.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VideoPlayerVC.fireTimer), userInfo: nil, repeats: true)
                    
                }
                
            })
            
          
            
          
        }
        
        self.frameLabel.isHidden = true
        
       // self.player?.automaticallyWaitsToMinimizeStalling = false
        
       // self.setPlayerRate()
        
        //    self.view.bringSubview(toFront:self.bottomView)
        
    }
    
    
    func setPlayerRate(){
        
        let hostTimeNow = CMClockGetTime(CMClockGetHostTimeClock())
        _ = CMTimeMakeWithSeconds(0.01, hostTimeNow.timescale)
            self.player?.setRate(1.0, time: kCMTimeZero, atHostTime: hostTimeNow)
    }
    
    
    func seekTime(){
//        let seekableRange : CMTimeRange = self.player?.currentItem?.seekableTimeRanges.last as! CMTimeRange
//        let seekableStart : CGFloat = CGFloat(CMTimeGetSeconds(seekableRange.start))
//        
//        let seekableDuration = CGFloat(CMTimeGetSeconds(seekableRange.duration))
//        
//        let livePsotion = seekableStart + seekableDuration
//        
//        if seekableDuration > 5.0 {
//            self.player?.seek(to: CMTime(seconds: Double(livePsotion), preferredTimescale: 1))
//        }
        
        let newTime = CMTime(seconds: rewindTimelineView.currentTime, preferredTimescale:(self.player?.currentItem?.currentTime().timescale)!)
        self.player?.currentItem?.seek(to: newTime)
        
    }
    
    func setLikeButtonImage(isLiked:String){
        if isLiked == "1"{
            self.likeButton.setImage(UIImage(named : "liked"), for: UIControlState.normal)
            
        }else{
            self.likeButton.setImage(UIImage(named : "like"), for: UIControlState.normal)
            
        }
    }
    
    
    func setUpVideo() {
        
        player?.isMuted = false
    
        self.commentTextView.placeholder = "Write a comment"
        //
        
        player?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: [.old,.new], context: nil)
        
        self.namelabel.text = self.name
        self.view.bringSubview(toFront: self.playerView)
        self.playerView.clipsToBounds = true
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        self.playerLayer.needsDisplayOnBoundsChange = true
        
        self.playerView.layer.insertSublayer(self.playerLayer, at: 0)
        
        self.playerLayer.backgroundColor = UIColor.black.cgColor
        
        self.tapVideo = UITapGestureRecognizer(target: self, action: #selector(VideoPlayerVC.tapOnVideoView))
        
        self.playerView.addGestureRecognizer(self.tapVideo)
        self.seekSlider.minimumTrackTintColor = UIColor.red
        self.seekSlider.maximumTrackTintColor = UIColor.white
        self.seekSlider.thumbTintColor = UIColor.lightGray
        
      // let url = NSURL(string: self.videoUrl.replacingOccurrences(of: "amlst:", with: ""))
        
        let url = NSURL(string: self.videoUrl)

        printDebug(object: "url is ,,,,\(String(describing: url))")
        
        let playerItem = AVPlayerItem(url: url! as URL)
        player?.replaceCurrentItem(with: playerItem)
        
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 50)
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main, using: { (elapsedTime: CMTime) -> Void in
            
            self.observeTime(elapsedTime: elapsedTime)
        }) as AnyObject!
        
        //TO DO :: set image in bg.
        self.setContainerFrame()
        self.player?.play()
        
        self.descriptionLabel.attributedText = CommonFunction.attributedHashTagString(main_string: self.videoDescription, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white, withFont: AppFonts.lotoMedium.withSize(11))
        
        CommonWebService.sharedInstance.scroll = self
        
        self.addNotifications()
        self.player?.play()
    }
    
    
    @IBAction func backButtonTapped(_ sener: UIButton) {
        
        self.stopWatching()
        self.timeElapsed = 0
        sharedAppdelegate.time?.invalidate()
        self.player?.pause()
        self.player?.isMuted = true
        CommonFunction.hideLoader(vc: self)
        CommonWebService.sharedInstance.videoAnimationCount = 0
        // AppUserDefaults.save(value: self.totalTokens, forKey:AppUserDefaults.Key.TokenCount)

        //if self.commmingFrom == .Feeds{
        
        if let _ =  self.likeBackDelegate{
            
            self.likeBackDelegate?.getLikesBack!(isLiked: self.feedObj.isliked ?? "0", totalLikes: self.feedObj.likes ?? "0",totalViews : self.feedObj.views ?? "0")
        }else{
            
            
        }
        
        
        //        }else{
        //
        //        }
        
        guard let _ = self.keyboard else{
            
            _ = self.navigationController?.popViewController(animated: true)
            return
        }
        
        CommonFunction.removeChildVC(childVC: self.keyboard)
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    private func setContainerFrame() {
        
        self.view.bringSubview(toFront:self.bottomView)
        
        CATransaction.begin()
        CATransaction.setDisableActions(true)
        self.playerView.backgroundColor = UIColor.black
        let pHeight = self.playerView.bounds.size.height
        let pWidth = screenSize.width//self.playerView.bounds.size.width
        let pOrigin = self.playerView.bounds.origin
        
        self.playerLayer.frame = CGRect(origin: pOrigin, size: CGSize(width: pWidth, height: pHeight))
        
        CATransaction.commit()
    }
    
    //Timer Update
    private func observeTime(elapsedTime: CMTime) {
        /*
         let duration = CMTimeGetSeconds(player.currentItem!.duration)
         if isfinite(duration) {
         let elapsedTime = CMTimeGetSeconds(elapsedTime)
         updateTimeLabel(elapsedTime: elapsedTime, duration: duration)
         }*/
    }
    
    
    func tapOnVideoView(sender : UITapGestureRecognizer){
        self.view.endEditing(true)
        if ShowVideoControls.shoeControls == .Show{
            ShowVideoControls.shoeControls = .Hide
            
            self.overLayView.image = UIImage(named: "")
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.bottomViewBottom.constant = -(75 + self.commentsTableView.frame.height + self.descriptionLabel.frame.height)
                
                self.nameTopConstraint.constant = -60
                self.view.layoutIfNeeded()
            
            })
        
        }else if ShowVideoControls.shoeControls == .Hide{
            ShowVideoControls.shoeControls = .Show
            
            self.overLayView.image = UIImage(named: "ic_home_shadow")
            
            UIView.animate(withDuration: 0.5, animations: {
                self.bottomViewBottom.constant = 0
                self.nameTopConstraint.constant = 15
                self.view.layoutIfNeeded()
            })
        }
    }
    
    private func resolutionSetup(url:String) {
        //let = URL(file)
        // let stringUrl = NSURL(string: url)
        
        // let kk = stringUrl?.m3u8PlanString()
        
        let videoURL = NSURL(string: url)
        printDebug(object: videoURL)
        let decodedURLString = (videoURL?.m3u8PlanString())! as String
        printDebug(object: decodedURLString)
        let decodedURLNSString =  NSString(string: "\(decodedURLString)")
        
        printDebug(object: "decoded url string")
        
        printDebug(object: decodedURLNSString)
        
        if let infoArr = decodedURLNSString.m3u8SegementInfoArr() {
            print(infoArr)
        }
        
    }
    
}



//MARK:- Keyboard setup
//=========================
extension VideoPlayerVC{

    //MARK:- text view ,ove up when keyboard appears
    //=================================================
     func addKeyBoardSetup() {
        IQKeyboardManager.shared().isEnabled = false
       // IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    
    //MARK:- Text view move down when keyboard is closed
    //=====================================================
     func removeKeyBoardSetup() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        
        IQKeyboardManager.shared().isEnabled = true
        // IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    
     func keyboardWillShow(notification:NSNotification){
        
        printDebug(object: "keyboard shown")
        
        let userInfo:NSDictionary = notification.userInfo! as NSDictionary
        let keyboardFrame:NSValue = userInfo.value(forKey: UIKeyboardFrameEndUserInfoKey) as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: 0.33, animations: { () -> Void in
            
            self.bottomViewBottom.constant = keyboardHeight
            self.view.layoutIfNeeded()

        })
        
        
    }
    
     func keyboardWillHide(notification:NSNotification){
        
        printDebug(object: "keyboard hidden")
        
        UIView.animate(withDuration: 0.33, animations: { () -> Void in
            
            self.bottomViewBottom.constant = 0
            self.view.layoutIfNeeded()
        })
        
    }

    
}

extension VideoPlayerVC{
    
    //MARK:- add observers
    //=========================
    func addNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.handleEnteredForeground), name: NSNotification.Name.UIApplicationWillEnterForeground, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.handleEnteredBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
         NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.handleTerminate), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackDidFinish), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackDidFailedToEndTime), name: NSNotification.Name.AVPlayerItemFailedToPlayToEndTime, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackTimeJumped), name: NSNotification.Name.AVPlayerItemTimeJumped, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackStaled), name: NSNotification.Name.AVPlayerItemPlaybackStalled, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackAccessLogEntry), name: NSNotification.Name.AVPlayerItemNewAccessLogEntry, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(VideoPlayerVC.videoPlayBackNewErrorLogEntry), name: NSNotification.Name.AVPlayerItemNewErrorLogEntry, object: nil)
        
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        self.player?.currentItem?.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        
//        CommonWebService.sharedInstance.videoAnimationCount
        
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?){
        
    
        if object is AVPlayerItem{
   
            if (self.player?.currentItem?.isPlaybackLikelyToKeepUp)!{
                //CommonFunction.hideLoader(vc: self)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                printDebug(object: "likely to keep up")
                
                
            }else if (self.player?.currentItem?.isPlaybackBufferFull)!{
                
              //  CommonFunction.hideLoader(vc: self)
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
                
            }else if (self.player?.currentItem?.isPlaybackBufferEmpty)!{
                printDebug(object: "likely to keep up not")
              //  CommonFunction.showLoader(vc: self)
                self.activityIndicator.startAnimating()
                self.view.addSubview(self.activityIndicator)
               // self.seekTime()
            }
        }
    }
    
    
    func observeEvents(){
        if let actualVideoURL = NSURL(string : self.videoUrl){
            
            let asset : AVAsset = AVAsset(url: actualVideoURL as URL)
            let keys = ["playable","tracks","duration"]
            
            asset.loadValuesAsynchronously(forKeys: keys, completionHandler: {
                
                DispatchQueue.main.async {
                    printDebug(object: "---->>>\(keys)")
                    
                    if (self.isViewLoaded && self.view.window != nil){
                        
                        let playerItem = AVPlayerItem(asset: asset)
                        self.player = AVPlayer(playerItem: playerItem)
                        
                        
                        if self.isBackBtnPressed == false {
                            
                            
                            self.player?.addObserver(self, forKeyPath: "rate", options:[.new], context: nil)
                            
                            self.player?.addObserver(self, forKeyPath: "status", options:[.new], context: nil)
                            self.player?.play()
                        }
                        
                        
                        self.player?.actionAtItemEnd = AVPlayerActionAtItemEnd.none
                    }
                }
            })
            
        }else{
            CommonFunction.showTsMessageError(message: "Incorrect Url")
        }
    }
    
    
    //    override func observeValue(forKeyPath keyPath: String?,
    //    of object: Any?,change: [NSKeyValueChangeKey : Any]?,
    //    context: UnsafeMutableRawPointer?) {
    //
    //        printDebug(object: "observed")
    //
    //        if (object != nil) && (object as? NSObject == self.player) && (keyPath != nil) && (keyPath! == "rate"){
    //            printDebug(object: player.error)
    //            if (player.rate != 0 && player.error == nil) {
    //
    //                CommonFunction.hideLoader(vc: self)
    //                isVideoPlaying = true
    //
    //
    //            }
    //        }    else if (object != nil) && (object as? NSObject == player) && (keyPath != nil) && (keyPath! == "status"){
    //            CommonFunction.hideLoader(vc: self)
    //
    //
    //            if (self.player.status == AVPlayerStatus.failed) {
    //                printDebug(object: "AVPlayer Status Failed")
    //            } else if (self.player.status == AVPlayerStatus.readyToPlay) {
    //                printDebug(object: "AVPlayer Status ReadyToPlay")
    //                self.player.play()
    //            } else if (self.player.status == AVPlayerStatus.unknown) {
    //                printDebug(object: "AVPlayer Status Unknown")
    //            }
    //        }
    //
    //    }
    
    func handleEnteredForeground(sender:NSNotification){
        self.player?.play()
        self.player?.isMuted = false
        self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"

    }
    
    func handleEnteredBackground(sender:NSNotification){
        self.player?.pause()
        self.player?.isMuted = true
   
        self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
        
        //AppUserDefaults.save(value: self.totalTokens, forKey:AppUserDefaults.Key.TokenCount)

    }
    
    func handleTerminate(){
        self.player?.pause()
        self.player?.isMuted = true
        self.stopWatching()
   
        self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
        
       // AppUserDefaults.save(value: self.totalTokens, forKey:AppUserDefaults.Key.TokenCount)

    }
    
    func playerDidFinishPlaying(notification: NSNotification){
        printDebug(object: notification.description)
        print("Video Finished")
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"    }
    
    func videoPlayBackDidFinish(notification:NSNotification){
        
        printDebug(object: notification.description)
        
        printDebug(object: "videoPlayBackDidFinish")
        
      //  CommonFunction.hideLoader(vc: self)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
    }
    
    
    func videoPlayBackDidFailedToEndTime(notification:NSNotification){
        printDebug(object: notification.description)
        printDebug(object:"videoPlayBackDidFailedToEndTime")
       // CommonFunction.hideLoader(vc: self)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
    }
    
    func videoPlayBackTimeJumped(notification:NSNotification){
        printDebug(object: notification.description)
        printDebug(object:"videoPlayBackTimeJumped")
       // CommonFunction.hideLoader(vc: self)
        
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"    }
    
    func videoPlayBackStaled(notification:NSNotification){
        printDebug(object: notification.description)
        printDebug(object:"videoPlayBackStaled")
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
    }
    
    func videoPlayBackAccessLogEntry(notification:NSNotification){
        printDebug(object: notification.description)
        printDebug(object:"videoPlayBackAccessLogEntry")
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"    }
    
    func videoPlayBackNewErrorLogEntry(notification:NSNotification){
        printDebug(object: notification.description)
        printDebug(object:"videoPlayBackNewErrorLogEntry")
        //CommonFunction.hideLoader(vc: self)
        self.activityIndicator.stopAnimating()
        self.activityIndicator.removeFromSuperview()
 
   self.frameLabel.text = "\(self.playerLayer.videoRect.size.width),\(self.playerLayer.videoRect.size.height)"
    }
}


// MARK: - Socket work
//======================
extension ViewController {
    
    fileprivate func sendMessage(_ message: String) {
        
        SocketHelper.sharedInstance.socket.write(string: message) {
            
        }
        
    }
    
    fileprivate func messageReceived(_ message: String, senderName: String) {
        
        
    }
}

// MARK: - WebSocketDelegate
extension VideoPlayerVC : WebSocketDelegate,WebSocketPongDelegate {
    
    func fireTimer(sender : Timer){
        
        self.timeElapsed += 1
        
        printDebug(object: "\(self.timeElapsed)......\(self.streamType)")
        if self.timeElapsed >= 9{
            
           // self.totalTokens =  self.totalTokens - self.perMinuteToken
            
           // self.tokenleftlabel.text = "\(self.totalTokens) Tokens Left"
            
        
            if self.streamType == "2"{
                
                CommonWebService.sharedInstance.diductToken(broadCastId: self.broadcastId, vcObj: self, type: "2", from: .WatchingVideo, completionBlock: { (success) in
                    
                  
                    if let tok = CurentUser.tokenCount{

                          printDebug(object: "diducted after a minut...\(tok)")
                        
                        
                        self.tokenleftlabel.text = "\(tok) Tokens Left"

                        
                    }
                    
                })

            }
            
            
            
//            if let tok = CurentUser.tokenCount{
//                
//              //  let leftToken = Int(tok)! - self.perMinuteToken
//                
//                //AppUserDefaults.save(value: "\(leftToken)", forKey:AppUserDefaults.Key.TokenCount)
//                
//            }
//            
            
            if let tokens = CurentUser.tokenCount{
                
                self.totalTokens = Int(tokens)!
            
                if Int(tokens)! <= self.perMinuteToken{
                    
                    self.player?.pause()
                    self.player?.isMuted = true
                }
                
            }
            
            //self.tokenleftlabel.text = "\(self.totalTokens) Tokens Left"
            
            self.timeElapsed = 0

        }
    }
    
    
    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
        
        if !socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
        }
        
        printDebug(object: "socket connected")
        
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
        SocketHelper.sharedInstance.connectSocket()
        
        printDebug(object: ".....socket am disconnected")
        
    }
    
    func websocketDidReceivePong(_ socket: WebSocket) {
        
        printDebug(object: "video player pong delegate called")
        
        let dictionary = ["eventName":"ping"]
        //let pingData: Data = NSKeyedArchiver.archivedData(withRootObject: dictionary)
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: dictionary as jsonDictionary)
        SocketHelper.sharedInstance.socket.write( jsonStr.data(using: .utf8)!) {
        
        printDebug(object: "ping done")
        }
    }
    
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        printDebug(object: "receivedJsonText\(text)")
            
        autoreleasepool {
         
        let returnedDict = SocketHelper.sharedInstance.convertTextToJson(text: text)
        
        printDebug(object: "returnedDict===\(returnedDict)")
        

        if let socketType = returnedDict["socketType"] as? String , socketType ==  "broadcastComment"{
            
            SocketService.postComment(json: returnedDict) { (success, comment) in
                
                self.comments.append(comment)
                self.commentsTableView.insertRows(at: [IndexPath(row: self.self.comments.count - 1, section: 0)], with: UITableViewRowAnimation.none)
                
                self.setTableViewHeight()
                
                if let count = self.feedObj.commentCount{
                   // printDebug(object: "count is \(self.streamedata.commentCount)")
                    
                    let newCount = Int(count)! + 1
                    
                    self.commentsButton.setTitle("\(newCount)", for: UIControlState.normal)
                    self.feedObj.commentCount = "\(newCount)"
                    self.setCountValues()
                    
                }
                 
                self.commentTextView.text = ""
               // self.view.endEditing(true)
                

                //self.emogieButton.setImage(UIImage(named: "sendIcon"), for: .normal)
                self.commentFieldIsEmpty = true
                
                if self.comments.last?.commentType == "1"{
                    
                    printDebug(object: "comment is \(String(describing: self.comments.last?.comment))")
                    
//                    let catagory = DataBaseControler.getCatagory(emogieId:(self.comments.last?.comment)!)

                    // let smileyType = DataBaseControler.getSmileyType(emogieId:(self.comments.last?.comment)!)
                   
                    if  self.comments.last?.emojiOrRain == "1"{
                        
                        if let _ = self.confettiView{
                            if (self.confettiView?.isActive())!{
                                self.confettiView?.stopConfetti()
                                self.confettiView?.removeFromSuperview()
                                self.rainTimer?.invalidate()
                                self.rainTimer = nil
                            }
                            
                            self.configureMakeItRain(emogiId:(self.comments.last?.comment)!)
                            
                        }else{
                            
                        self.configureMakeItRain(emogiId:(self.comments.last?.comment)!)
                            
                        }

                        if self.comments.count > 1{
                            
                            self.commentsTableView.scrollToRow(at:IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        }
                        
                    }else{
                        let originY : Float = Float(self.commentsTableView.frame.origin.y)

                        CommonFunction.floatEmogie(id: (self.comments.last?.comment)!,isPlaySound: true,animationStartPosition: originY,vcObj: self)
                         CommonFunction.playSound(name: "bell",type: "mp3")
                    }
                    
                    //self.floatEmogie(id: (self.comments.last?.comment)!)
                    
                }else{
                    if self.comments.count > 1{
                        
                        self.commentsTableView.scrollToRow(at:IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                    }
                }
                
            }
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "likeFeed"{
            
            SocketService.likeFeed(json: returnedDict, completionBlock: { (success, count) in
                
                
                self.feedObj.likes = "\(count)"
                
                //self.setCountValues()
                self.likeCountButton.setTitle("\(count)", for: UIControlState.normal)
            })
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "viewFeed"{
            
            SocketService.viewFeed(json: returnedDict, completionBlock: { (success, count) in
                
                self.viewsButton.setTitle("\(count)", for: UIControlState.normal)
                
            })
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "stopBroadcast"{
            _ = VKCAlertController.alert(title: "The broadcast has been finished now.", message: "Broadcast has been stopped.", buttons: ["OK"], tapBlock: { (_, index) in
                
                if index == 0{
                    
                    self.stopWatching()
                    self.timeElapsed = 0
                    sharedAppdelegate.time?.invalidate()
                    self.player?.pause()
                    self.player?.isMuted = true
                    CommonFunction.hideLoader(vc: self)
                    CommonWebService.sharedInstance.videoAnimationCount = 0

                    _ = self.navigationController?.popViewController(animated: true)
                    
                }
            })
        }else if let socketType = returnedDict["socketType"] as? String , socketType == "stopstreeminganduseradmin" || socketType == "Blockbyadmin" || socketType == "Banbyadmin" || socketType == "Deletebyadmin" {
            self.stopWatching()
            self.timeElapsed = 0
            sharedAppdelegate.time?.invalidate()
            self.player?.pause()
            self.player?.isMuted = true
            CommonFunction.hideLoader(vc: self)
            
            if let message = returnedDict["message"]{
                
                CommonFunction.showTsMessageError(message: message as? String ?? "")
            }

            
            CommonWebService.sharedInstance.videoAnimationCount = 0
            
            _ = self.navigationController?.popViewController(animated: true)
            UserService.logoutFromApp()
            }
        
        printDebug(object: "returnedDict===\(String(describing: returnedDict["data"]))")
        
    }}
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        
        
    }
    
    
    func addTokenSocketService(){
        
        let addTokenServiceDict : jsonDictionary = ["socketType": SocketUrl.addToken as AnyObject,"data":["userId":CurentUser.userId,"token" : "500"] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: addTokenServiceDict)
        
        printDebug(object: "jsonStr---\(jsonStr)")
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
    func postCommentService(type:String,comment : String,emojiOrRain:String){
        
        autoreleasepool {
            DispatchQueue.main.async {
        if !SocketHelper.sharedInstance.socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
        }
        
                let postCommentServiceDict : jsonDictionary = ["socketType": SocketUrl.postComment as AnyObject,"data":["userId":CurentUser.userId as AnyObject ,"broadcastId" : self.broadcastId as AnyObject,"commentType" : type as AnyObject , "comment" : comment as AnyObject,"emojiOrRain" : emojiOrRain as AnyObject] as AnyObject]
        
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: postCommentServiceDict)
        
        printDebug(object: "jsonStr---\(jsonStr)")
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
       
        let cmt = ["comment":comment,"commentType" : type,"dateCreated":"\( CommonFunction.getTimeStampFromDate(date: Date()) * 1000)","commentId" : "", "imageUrl":"","name" : CurentUser.userName,"userId" : CurentUser.userId , "emojiOrRain" : emojiOrRain]
        
        let curentCmt = ImageCommentData(commentsData: cmt as jsonDictionary)
        

    
            //self.commentsTableView.reloadData()
            self.comments.append(curentCmt)

           self.commentsTableView.insertRows(at: [IndexPath(row: self.comments.count - 1, section: 0)], with: UITableViewRowAnimation.none)

            if let count = self.feedObj.commentCount{
                
                printDebug(object: count)
                let newCount = Int(count)! + 1
                
                self.commentsButton.setTitle("\(newCount)", for: UIControlState.normal)
                self.feedObj.commentCount = "\(newCount)"
                self.setCountValues()

            }

            self.setTableViewHeight()
            
            if self.comments.count > 1 && type != "1" {
                self.commentsTableView.scrollToRow(at:
                    IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                
            }
        }
        }
    }
    
    
    func likeFeed(like : String){
        
        let likeDict = ["socketType" : "likeFeed" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.broadcastId as AnyObject,"like" : like as AnyObject ] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: likeDict)
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
    func viewService(){
        
        let viewDict = ["socketType" : "viewFeed" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.broadcastId as AnyObject] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: viewDict)
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
    
    func ghostBan(banUserId:String){
        
        let ghostBanDict = ["socketType" : "ghostban" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.broadcastId as AnyObject,"ghostBanUserId" : banUserId as AnyObject ] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: ghostBanDict)
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        self.ghostBanIds.append(banUserId)
        
    _ = self.comments.map { (obj)  in
        
        if obj.userId == banUserId{
            self.comments.remove(at: self.comments.indexOfObject(object: obj))
        }
    }
        self.commentsTableView.reloadData()
        self.setTableViewHeight()
    }
}


extension VideoPlayerVC : CutWhileWatchingDelegate{
    
    func cutWhileWatching() {
        
        printDebug(object: "called......")
        
        self.timeElapsed = 0
        sharedAppdelegate.time?.invalidate()
        self.player?.play()
        self.player?.isMuted = false
        sharedAppdelegate.time = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(VideoPlayerVC.fireTimer), userInfo: nil, repeats: true)
    }
}


//MARK:- Emogi keyboard delegates
//===================================
extension VideoPlayerVC : CommentEmogie{
    
    func sendEmogie(id:String,price:Int,image:UIImage,dimension:String,catagoryType:String,smileyType:String){
        
       // if let tok = self.totalTokens{
        
          if let tok = CurentUser.tokenCount{
             if Int(tok)! > price{

                let leftToken = Int(tok)! - price

                AppUserDefaults.save(value: "\(leftToken)", forKey:AppUserDefaults.Key.TokenCount)

                DispatchQueue.main.async {
                    self.tokenleftlabel.text = "\(leftToken) Tokens Left"
                }
                
                
                if smileyType == "1"{
                    
                    DispatchQueue.main.async {
                        
                        //self.configureMakeItRain(emogiId:id)
                        
                        if let _ = self.confettiView{
                            if (self.confettiView?.isActive())!{
                                self.confettiView?.stopConfetti()
                                self.confettiView?.removeFromSuperview()
                                self.rainTimer?.invalidate()
                                self.rainTimer = nil
                            }
                            
                            self.configureMakeItRain(emogiId:id)
                            
                        }else{
                            
                            self.configureMakeItRain(emogiId:id)
                            
                        }
                        
                    }
                    
                }else{
                    
                    DispatchQueue.main.async {
                        
                        let random = CommonFunction.getEmogieYpos(animationStartPosition: Float(self.commentsTableView.frame.origin.y))
                        
                        CommonFunction.floatEmogie(ypos: CGFloat(random), duration: 5, emogieImg:image, isPlaySound: true,dimension:dimension,vcObj: self)
                        
                        CommonFunction.playSound(name: "bell",type: "mp3")
                    }
                }
                
                self.postCommentService(type: "1", comment: id, emojiOrRain: smileyType)
                
             }else{
                
                CommonWebService.sharedInstance.tokenLess(from: .EmogieKeyBoard)

            }
        }
        
        
            
       // }
    }
    
//        func tokenLess() {
//    
//            let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "PurchasemoreTokenID") as! PurchasemoreTokenVC
//            vc.navigateToPlayerdelegate = self
//            CommonFunction.addChildVC(childVC: vc,parentVC: self)
//    
//        }
    
    
    
        func tokenFinished(){
        
                let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
        
                self.navigationController?.pushViewController(vc, animated: true)
        
    }
    

    func removeKeyBoard(){
        self.isEmojiKeboardShown = false
        self.bottomView.isHidden = false
        self.view.bringSubview(toFront: self.bottomView)
    }
    
}

extension VideoPlayerVC : ScrollToLastDelegate{
    
    func scrollLast() {
        self.scrollTableViewToLast()
    }
}

private extension VideoPlayerVC{
    
    func setTableViewHeight(){
        
        printDebug(object: "self.commentsTableView.contentSize.height...\(self.commentsTableView.contentSize.height)")
        
        
        if  self.comments.count < 4{
            
            var tableHeight = 0
            
            for item in self.comments{
            
                if item.commentType == "1"{
                    tableHeight = tableHeight + 30
                }else{
                   // let timeStampValue = Double(item.dateCreated ?? "0.0")! / 1000.0
                  //  let date =  Date.init(timeIntervalSince1970:timeStampValue)
              
                    let height = CommonFunction.getTextHeight(text: item.comment!, font: AppFonts.lotoRegular.withSize(13), width: screenWidth - 100)
                    tableHeight = tableHeight + Int(height)
                }
            }
            
            self.commentsTableViewHeight.constant = CGFloat(tableHeight) + 20
        }else{
            self.commentsTableViewHeight.constant = 128
        }
    }
    
    
    func scrollTableViewToLast(){
        if self.comments.count > 1{
            self.commentsTableView.scrollToRow(at:
                IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }
}


extension VideoPlayerVC : UITableViewDelegate , UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        printDebug(object:"comments displayed \(self.comments.count)")
        
        return self.comments.count
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
         let height = CommonFunction.getTextHeight(text: self.comments[indexPath.row].comment!, font: AppFonts.lotoRegular.withSize(13), width: screenWidth - 56)
        
        printDebug(object: "height.....\(height)")
        
        
       if self.comments[indexPath.row].commentType == "1"{
        return 30
       }else{
        return UITableViewAutomaticDimension
        }

    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let backView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 0.2))
        backView.backgroundColor = AppColors.lightSeperatorColor.withAlphaComponent(0.3)
        return backView
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
        cell.backgroundColor = UIColor.clear
        cell.commentLabel.textColor = UIColor.white
        cell.dotView.backgroundColor = UIColor.white
        cell.timeLabel.textColor = UIColor.white
        cell.backView.backgroundColor = UIColor.clear
        cell.caleulateNameWidth(name: self.comments[indexPath.row].name!,type: self.comments[indexPath.row].commentType!)
        
       // cell.nameLabel.text = self.comments[indexPath.row].name
        
        cell.setNameText(name: "\(self.comments[indexPath.row].name!)", type: self.comments[indexPath.row].commentType!)
        
        cell.commentLabel.text = self.comments[indexPath.row].comment
        
        
        
        cell.showEmogieOrText(type: self.comments[indexPath.row].commentType!, emogieId: self.comments[indexPath.row].comment!, emojiOrRain: self.comments[indexPath.row].emojiOrRain!)
        
        cell.ghostBanButton.isHidden = true
        cell.timeLabel.textAlignment = .right
        
        cell.ghostBanButton.addTarget(self, action: #selector(StreamingVC.ghostBantapped), for: UIControlEvents.touchUpInside)
        
        let timeStampValue = Double(self.comments[indexPath.row].dateCreated ?? "0.0")! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        cell.timeLabel.text = Date().timeFrom(date:date as Date)
        
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        if let _ = self.streamedata{
//        if self.streamedata.next == "1" && indexPath.row == 0 && self.comments.count >= 9{
//           // self.getComments(isFirst: false)
//          }
//        }
//    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if (self.commentsTableView.indexPathsForVisibleRows?.contains(IndexPath(row: 0, section: 0)))!{
            printDebug(object: "row displayed")
            if let _ = self.streamedata{
                if self.streamedata.next == "1" && self.comments.count >= 9{
                    if self.serviceHit{
                     self.getComments(isFirst: false)
                    }
                }
            }
        }
    }
    
    
    
    func ghostBantapped(sender:UIButton){
        
        let indx = sender.tableViewIndexPath(tableView: commentsTableView)
        self.ghostBanActionSheet(row:(indx?.row)!)
        
    }
    
    
    func ghostBanActionSheet(row:Int) {
        let optionMenu = UIAlertController(title: nil, message: "GhostBan", preferredStyle: .actionSheet)
        
        let ghostBanAction = UIAlertAction(title: "GhostBan", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            
            _ = VKCAlertController.alert(title: "GhostBan this user", message: "Are you sure you want to GhostBan this user?", buttons: ["No","Yes"], tapBlock: { (_, index) in
                
                if index == 1{
                    self.ghostBan(banUserId: self.comments[row].userId!)
                }
                
            })
            
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        optionMenu.addAction(ghostBanAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
}


extension VideoPlayerVC : UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if let _ = self.confettiView{
            self.bottomView.bringSubview(toFront: self.confettiView!)
        }
    }
    
    func textViewShouldReturn(_ textView: UITextView!) -> Bool{
        //self.view.endEditing(true);
        // self.postComment(cmt: self.commentTextView.text)
        return true;
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        printDebug(object: textView.text)
        printDebug(object: textView.text.characters.count)
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        
        if text == " " && range.location == 0{
            return false
        }else if (textView.text?.characters.count)! == 100 && isBackSpace != -92{
            return false
        }else{
            
            CommonFunction.delayy(delay: 0.1) {
                
                if textView.text.isEmpty{
                    self.commentFieldIsEmpty = true
                    
                    
                    
                    self.emogieButton.setImage(UIImage(named: "emogiesIcon"), for: .normal)
                }else{
                    self.commentFieldIsEmpty = false
                    self.emogieButton.setImage(UIImage(named: "sendIcon"), for: .normal)
                }
            }
            
            return true
        }
    }
}


//MARK:- Emogies , Make it rain
extension VideoPlayerVC{
    
    //MARK:- Add age pop up
    //=======================
    func addKeyBoard(){
        self.isEmojiKeboardShown = true
        
        self.keyboard = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "EmogieKeyBoardID") as! EmogieKeyBoardVC
        self.keyboard.emogieDelegate = self
        CommonFunction.addChildVC(childVC: self.keyboard,parentVC: self)
    
        self.bottomView.isHidden = true
        
        self.keyboard.view.frame = CGRect(x: 0, y: screenHeight - 205 , width: screenWidth, height: 205)
        
    }
    
    
    
    func configureMakeItRain(emogiId : String){
        
        self.confettiView = SAConfettiView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        
        guard let imgArray = self.getImageArray(id: emogiId) else{
                    return
                }
        
         confettiView?.emogieImageArray.append(contentsOf: imgArray)
        
        confettiView?.intensity = 0.4
        confettiView?.type = .Diamond
        
        if self.rainTimer == nil {
            
        self.view.addSubview(confettiView!)
        
            confettiView?.startConfetti()
            
         // confettiView?.stoppingConfetti()
            
        CommonFunction.playSound(name: "rain",type: "mp3")
        self.rainTimer = Timer.scheduledTimer(timeInterval: 11, target: self, selector: #selector(VideoPlayerVC.stopRain), userInfo: nil, repeats: false)
        }
    }
    

   
    func getImageArray(id:String) -> [UIImage]?{
        
        let ids = DataBaseControler.getSmiliIds(emogieId: id)
        
        printDebug(object: "ids...\(ids)")
        
       
        
        
        printDebug(object: "components array...\(ids.components(separatedBy: ","))")
        
        
        
        _ = ids.components(separatedBy: ",").map { (obj)in
            
            
            if obj != ""{
                let path = DataBaseControler.getImagePath(emogieId: obj)
                
                printDebug(object: "path is...\(path)")
                
                guard let emogieImage = CommonFunction.getImage(pathName: path.0) else{
                    printDebug(object: "emogie image is nil")
                    return
                }
                
                printDebug(object: "emogie image is \(emogieImage)")
                
                self.emogiImageArray.append(emogieImage)
                
            }
        }
        return self.emogiImageArray
    }
    
    func stopRain(sender : Timer){
        printDebug(object: "time elapsed \(self.rainTimeElapsed)")
       // confettiView?.startConfetti()
        confettiView?.stopConfetti()
        confettiView?.removeFromSuperview()
        self.rainTimer?.invalidate()
        self.rainTimer = nil
        self.emogiImageArray.removeAll()
//        if !self.rainPendingArray.isEmpty{
//            self.configureMakeItRain(emogiId:self.rainPendingArray.first!)
//        self.rainPendingArray.removeFirst()
//        }
        
    }
}



//MARK:- Webservices
//======================
extension VideoPlayerVC{
    
    //MARK:- get comments UserService
    //=================================
    func getComments(isFirst : Bool){
        
        var params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject  ,"mediaId" : self.broadcastId as AnyObject ,"mediaType" : "1" as AnyObject]
        
        if let _ = self.streamedata{
            params["limit"] = self.streamedata.limit as AnyObject?
        }else{
            params["limit"] = "0" as AnyObject?
        }
        
        printDebug(object: "params are \(params)")
        
        if isFirst{
            
        CommonFunction.showLoader(vc: self)
        
         }
        self.serviceHit = false

        UserService.getCommentsApi(params: params) { (success, data, message) in
            self.serviceHit = true
            self.commentsTableView.isHidden = false

            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                   // self.comments.removeAll()
                    self.streamedata = data
                 //   self.comments.append(contentsOf: self.streamedata.comments!.reversed())
                    
                    
                _ = self.streamedata.comments!.map { (obj)  in
                    
                    self.comments.insert(obj, at: 0)
                    
                }
                    
                
                    printDebug(object: "comment count from service \(self.comments.count)")
                 //   self.comments = self.streamedata.comments!
                    
                self.commentsTableView.reloadData()
                self.setTableViewHeight()
                   
                    if isFirst{
                       
                    }
                    
          if self.comments.count > 1 && isFirst{
            self.commentsTableView.scrollToRow(at:IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.none, animated: false)
         }
        }
    }else{
                self.setTableViewHeight()
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
    
    func likeDisLikeFeed(broadcastId:String,like:String){
        
        CommonWebService.sharedInstance.likeDislikeFeed(vcObj: self, broadcastId: broadcastId, like: like) { (success, totalKikes) in
            if success{
                
                printDebug(object: "my count---...>>>>\(String(describing: totalKikes))")
                
                guard let total = totalKikes else{
                    return
                }
                
                self.feedObj.likes = totalKikes
                
                self.likeCountButton.setTitle(total, for: UIControlState.normal)
                
            }else{
                
            }
            CommonFunction.hideLoader(vc: self)
        }
        
    }
    
    
    func viewFeeds(){
        printDebug(object: "viee")
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "broadcastId" : self.broadcastId as AnyObject ]
        
        UserService.viewFeedApi(params: params) { (success, totalViews) in
            
            
            if success{
                
                guard let count = totalViews else{
                    return
                }
                
                printDebug(object: "vieeeeee\(count)")
                
                self.feedObj.views = count
                self.viewsButton.setTitle(self.feedObj.views, for: UIControlState.normal)
                
            }else{
                
                
            }
            CommonFunction.hideLoader(vc: self)
        }
        
        
    }
  
    
    
    func stopWatching(){
        printDebug(object: "viee")
        CommonFunction.hideLoader(vc: self)

        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject , "broadcastId" : self.broadcastId as AnyObject ]
        // CommonFunction.showLoader(vc: self)
        
        UserService.stopWatchingApi(params: params) { (success) in
            //  CommonFunction.hideLoader(vc: self)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
            }else{
                //   CommonFunction.hideLoader(vc: self)
                
            }
            
            // CommonFunction.hideLoader(vc: self)
        }
        
        
    }
    
}


extension VideoPlayerVC : ReportAbuse{
    
    func report(reason:String){
        self.blockUser(type: "2",reason: reason)
        
    }
   
    func blockUser(type : String,reason:String){
        
        var params : jsonDictionary = ["userId" : CurentUser.userId  as AnyObject , "blockUsersId" : self.followUserId as AnyObject , "blockType" : type as AnyObject , "reason" : "Blocked" as AnyObject]
        
        if type == "2"{
            
            params["reason"] = reason as AnyObject?
        }
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: self)
        UserService.blockApi(params: params) { (success) in
            
            printDebug(object: success)
            
            if success{
                CommonFunction.hideLoader(vc: self)
                printDebug(object: "before pop")

                if type != "2"{

                _ = self.navigationController?.popViewController(animated: true)
                }
                
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
}
