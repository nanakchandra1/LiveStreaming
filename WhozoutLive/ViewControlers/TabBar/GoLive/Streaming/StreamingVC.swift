

protocol GetChargeIdBack {
    func getchargeId(id:String,shareUrl:String)
}

import UIKit
import AttributedTextView
import Starscream
import SAConfettiView


class StreamingVC: UIViewController,UIDocumentInteractionControllerDelegate{
    
    //MARK:- IBOutlets
    //===================
    @IBOutlet weak var broadcastButton: UIButton!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var flashButton: UIButton!
    @IBOutlet weak var bottomViewBottom: NSLayoutConstraint!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var hashTagTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var hashTagTableView: UITableView!
    @IBOutlet weak var addDescriptionLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var shareLabel: UILabel!
    @IBOutlet weak var commentTextView: KMPlaceholderTextView!
    @IBOutlet weak var commentsTableVoew: UITableView!
    @IBOutlet weak var commentsTableViewHeight: NSLayoutConstraint!
    @IBOutlet weak var emogieButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCountButton: UIButton!
    @IBOutlet weak var viewButton: UIButton!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var thumbButton: UIButton!
    
    @IBOutlet weak var descriptionTextViewBottom: NSLayoutConstraint!
    
    
    
    //MARK:- Variables
    //===================
    fileprivate var goCoder:WowzaGoCoder!
    fileprivate var goCoderCameraPreview : WZCameraPreview?
    fileprivate var goCoderConfig:WowzaConfig!
    fileprivate var first = true
    fileprivate var tagString = ""
    fileprivate var tags : [TagData] = []
    fileprivate var streamId = ""
    fileprivate var keyboard : EmogieKeyBoardVC!
    fileprivate var confettiView: SAConfettiView!
    fileprivate var commentFieldIsEmpty = true
    fileprivate var streamedata : DisplayImageData!
    fileprivate var comments : [ImageCommentData] = []
    fileprivate var timeElapsed : Int = 0
    fileprivate var isLiked : String = "0"
    fileprivate var rainTimer : Timer?
    fileprivate var rainTimeElapsed : Int = 0
    fileprivate var sharingUrl : String!
    fileprivate var ghostBanIds : StringArray = []
    fileprivate var hoursCompleteTimer : Timer?
    fileprivate var beforeComplitionTimer : Timer?
    fileprivate var rainPendingArray : StringArray = []
    fileprivate var broadcastConfig:WowzaConfig?
    fileprivate var emogiImageArray = [UIImage]()
    var disconnectedDelegate : ShowDisConnectionMessage?
    var documentController: UIDocumentInteractionController!

    
    //MARK:- deinit
    //================
    deinit {
    
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillResignActive, object:nil )
        
         NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIApplicationWillTerminate, object:nil )
    }
    
    
    //view life cycle
    //==================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpSubView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if first{
            // goCoder?.cameraPreview?.previewLayer?.frame = self.cameraView.frame
            goCoder?.cameraPreview?.previewLayer?.frame = self.view.frame
            self.setBroadcastProtocol(name: "")
            
        }else{
            
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.addKeyBoardSetup()

        if first{
            //  self.goCoder?.cameraView = self.cameraView
            self.goCoder?.cameraView = self.view
            self.goCoder.cameraPreview?.previewGravity = .resizeAspect
            self.goCoder?.cameraPreview?.start()
        }
        
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        
        UIApplication.shared.isStatusBarHidden = true
        
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        //  self.startCameraPreview()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        UIApplication.shared.isStatusBarHidden = false
        UIApplication.shared.isIdleTimerDisabled = false
        self.removeKeyBoardSetup()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //MARK:- IBActions
    //===================
    @IBAction func broadCastButtonTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        if Networking.isConnectedToNetwork{
            if goCoder?.status.state == .running{
                self.finishStream()
            }else{
                if !self.descriptionTextView.text.isEmpty {
                    let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SharingInformationID") as! SharingInformationVC
                    
                    vc.selectCountryVC = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SelectCountryID") as? SelectCountryVC
                    
                    vc.selectCountryVC?.getChargeIdBackDelegate = self
                    
                    //  vc.getChargeDelegate = self
                    self.first = false
                    
                    vc.sharingData["discription"] = self.descriptionTextView.text;
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }else{
                    CommonFunction.showTsMessageErrorInViewControler(message: "Please enter description", vc: self)
                }
        
            }
        }else{
            CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("internet connection", comment: ""), vc: self)
            
        }
    }
    
    @IBAction func switchCameraButtonTapped(_ sender: UIButton) {
        
        if let _ = goCoder?.cameraPreview?.otherCamera() {
            
            goCoder?.cameraPreview?.switchCamera()
            // self.cameraButton.setImage(UIImage(named: "torch_on_button"), for: UIControlState())
            //  self.updateUIControls()
            
            if  (goCoder?.cameraPreview?.camera?.isFront())!{
                self.cameraButton.setImage(UIImage(named: "frontCamera"), for: UIControlState())
            }else{
                self.cameraButton.setImage(UIImage(named: "backCamera"), for: UIControlState())
            }
        }
    }
    
    
    
    @IBAction func flashButtontapped(_ sender: UIButton) {
        var newTorchState = goCoder?.cameraPreview?.camera?.isTorchOn ?? true
        newTorchState = !newTorchState
        goCoder?.cameraPreview?.camera?.isTorchOn = newTorchState
        self.flashButton.setImage(UIImage(named: newTorchState ? "flashOn" : "flashOff"), for: .normal)
    
    }
    
    @IBAction func sharingButtontapped(_ sender: UIButton) {
    
        CommonFunction.shareWithSocialMedia(message: self.sharingUrl,vcObj:self)
    
        
      //self.shareOnInstaGram()

        
    }
    
    
    @IBAction func emogieButtonTapped(_ sender: UIButton) {
        
            self.view.endEditing(true)
            
            if Networking.isConnectedToNetwork{
                if !self.commentTextView.text.isEmpty{
                self.postCommentService(type: "0", comment: self.commentTextView.text, emojiOrRain: "0")
                }
                self.commentTextView.text = ""
            }else{
                CommonFunction.showTsMessageError(message: NSLocalizedString("internet connection", comment: ""))
            }
    }
    
    
    @IBAction func commentButtontapped(_ sender: UIButton) {
  
    }
    
    @IBAction func likeButtonTapped(_ sender: UIButton) {
    
        if isLiked == "1"{
            self.isLiked = "0"
            self.setLikeButtonImage(isLiked: "0")
            //self.likeDisLikeFeed(broadcastId: self.broadcastId, like: "0")
            
            let likeCount = Int((self.likeCountButton.titleLabel?.text)!)! - 1
            
            self.likeCountButton.setTitle("\(likeCount)", for: UIControlState.normal)
            
            self.likeFeed(like: "0")

    
        }else{
            self.isLiked = "1"
            self.setLikeButtonImage(isLiked: "1")
            //self.likeDisLikeFeed(broadcastId: self.broadcastId, like: "1")
            
           let likeCount = Int((self.likeCountButton.titleLabel?.text)!)! + 1
            self.likeCountButton.setTitle("\(likeCount)", for: UIControlState.normal)
            
            self.likeFeed(like: "1")
            
        }
    }
    
    @IBAction func likeCountButtonTapped(_ sender: UIButton) {
        
        
    }
    
    
    @IBAction func thumbButtonTapped(_ sender: UIButton) {
        
        self.view.endEditing(true)

        self.postCommentService(type: "1", comment: "58d518d2da283dbc99932e82", emojiOrRain: "0")
        
        CommonFunction.floatEmogie(id: "58d518d2da283dbc99932e82",isPlaySound: false,animationStartPosition: Float(Float(self.commentsTableVoew.frame.origin.y)),vcObj: self)

    }
    
    
    @IBAction func viewButtonTapped(_ sender: UIButton) {
        
        
        
    }
    
  
    
    @IBAction func backButtonTapped(_ sender: UIButton) {
        
        if goCoder?.status.state == .running {
            
            self.finishStream()
            
        }else{
            self.dismiss(animated: true, completion: nil)
            
        }
    }
    
    func handleEnteredBackground(sender:NSNotification){
        print("resign called")
        self.start()
        self.finishBroadcast()
        self.dismiss(animated: true, completion: nil)
    }
}


//MARK:- Keyboard setup
//=========================
extension StreamingVC{
    
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
            
             if self.goCoder?.status.state == .running {
                
                self.bottomViewBottom.constant = keyboardHeight
             }else{
                self.descriptionTextViewBottom.constant = keyboardHeight + 5
            }
            
            
            self.view.layoutIfNeeded()
            
        })
        
        
    }
    
    func keyboardWillHide(notification:NSNotification){
        
        printDebug(object: "keyboard hidden")
        
        UIView.animate(withDuration: 0.33, animations: { () -> Void in
            
            if self.goCoder?.status.state == .running {

                self.bottomViewBottom.constant = 0

            }else{
                
                self.descriptionTextViewBottom.constant = 5

            }
            self.view.layoutIfNeeded()
        })
        
    }
}


private extension StreamingVC{
    func setUpSubView(){
        self.commentTextView.keyboardType = .asciiCapable
        self.descriptionTextView.autocorrectionType = .no
        self.commentTextView.autocorrectionType = .no
        self.descriptionTextView.delegate = self
        self.descriptionTextView.layer.borderWidth = 1.0
        self.descriptionTextView.layer.borderColor = UIColor.white.cgColor
        let goCoderLicensingError : Error? = WowzaGoCoder.registerLicenseKey("GOSK-0C43-0100-DD26-1A17-8E42")
        self.broadcastButton.layer.cornerRadius = 3.0
        self.broadcastButton.layer.borderWidth = 1.0
        self.broadcastButton.clipsToBounds = true
        self.broadcastButton.layer.borderColor = UIColor.white.cgColor
        self.broadcastButton.clipsToBounds = true
        self.descriptionTextView.isHidden = false
        self.descriptionLabel.isHidden = true
        self.self.descriptionTextView.textColor = UIColor.white
        
        SocketHelper.sharedInstance.socket.delegate = self

        
        if goCoderLicensingError != nil{
            printDebug(object: goCoderLicensingError?.localizedDescription)
        }else{
            self.goCoder = WowzaGoCoder.sharedInstance()
        }
        
        self.commentsTableViewHeight.constant = 0
        
        let cellNib = UINib(nibName: "CommentCell", bundle: nil)
        self.commentsTableVoew.register(cellNib, forCellReuseIdentifier: "commentCell")

        self.commentTextView.delegate = self
        self.commentsTableVoew.delegate = self
        self.commentsTableVoew.dataSource = self
        CommonWebService.sharedInstance.scroll = self
        
        self.hashTagTableView.delegate = self
        self.hashTagTableView.dataSource = self
        self.bottomViewBottom.constant = -75
        self.backButton.isHidden = false
        self.shareButton.isHidden = true
        self.shareLabel.isHidden = true
        self.flashButton.setImage(UIImage(named : "flashOff"), for: .normal)
        
        self.commentsTableVoew.estimatedRowHeight = 50
        self.commentsTableVoew.rowHeight = UITableViewAutomaticDimension
        self.commentsTableVoew.backgroundColor = UIColor.clear
      
        self.commentTextView.placeholder = "Write a comment"
        
        NotificationCenter.default.addObserver(self, selector: #selector(StreamingVC.handleEnteredBackground), name: NSNotification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(StreamingVC.handleEnteredBackground), name: NSNotification.Name.UIApplicationWillTerminate, object: nil)
       
    }
    
    
    func finishStream(){
        
        _ = VKCAlertController.alert(title: "Finish Streaming", message: "Are you sure you want to finish Streaming?", buttons: ["Yes","No"], tapBlock: { (_, index) in
            
            if index == 0{
                self.start()
                
                self.dismiss(animated: true, completion: nil)
                
            }
            
        })
    
    }
    
   @objc func streamAboutToEnd(){
   
    
    _ = VKCAlertController.alert(title: "Stream Ending", message: "Your stream is about to end in 15 minutes.", buttons: ["Ok"], tapBlock: { (_, index) in
        
        if index == 0{
            
        }
        
    })

    }
    
    
     @objc func timeLimitExceeded(){
        self.start()
        CommonFunction.showTsMessageSuccess(message: "Your stream has ended.")
    }
    
    //MARK:- set broadcast protocol
    //===============================
    func setBroadcastProtocol(name:String){
        if self.goCoder != nil {
             self.broadcastConfig = self.goCoder.config
        broadcastConfig?.load(WZFrameSizePreset.preset1280x720)
        broadcastConfig?.hostAddress = StreamingConstants.url
        broadcastConfig?.portNumber = UInt(StreamingConstants.port)
        broadcastConfig?.username = StreamingConstants.userNamae
        broadcastConfig?.password = StreamingConstants.password
        broadcastConfig?.applicationName = StreamingConstants.applicationName
        broadcastConfig?.videoFrameRate = UInt(StreamingConstants.frameRate)
        broadcastConfig?.streamName = name
            self.streamId = name
        self.goCoder.config = broadcastConfig!
        }
        
      //  printDebug(object: "framesize is....\(broadcastConfig?.frameSize)")
    }
    
  
    
    //MARK:- Start camera
    //======================
    func startCameraPreview(){
        if self.goCoder != nil {
            // Associate the U/I view with the SDK camera preview
            //  self.goCoder.cameraView = self.cameraView
            
            //self.goCoder.cameraView = self.cameraView
            self.goCoder.cameraView = self.view
            // Start the camera preview
            
            self.goCoderCameraPreview?.start()
        }
    }
    
    //MARK:- update controls
    //===========================
    func updateUIControls() {
        
        printDebug(object: self.goCoder?.status.state)
        
        if self.goCoder?.status.state != .idle && self.goCoder?.status.state != .running {
            
        }
        else {
           
            
        }
    }
    
    
    func setTableViewHeight(){
    
            if  self.comments.count < 4{
                
                var tableHeight = 0
                
                for item in self.comments{
                    
                    if item.commentType == "1"{
                        tableHeight = tableHeight + 30
                    }else{
                     //   let timeStampValue = Double(item.dateCreated ?? "0.0")! / 1000.0
                       // let date =  Date.init(timeIntervalSince1970:timeStampValue)
                        
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
            self.commentsTableVoew.scrollToRow(at:
                IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
        }
    }

    
    func showAlert(_ title:String, error:NSError) {
        let alertController = UIAlertController(title: title, message: error.localizedDescription, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    
    func setLikeButtonImage(isLiked:String){
        if isLiked == "1"{
            self.likeButton.setImage(UIImage(named : "liked"), for: UIControlState.normal)
            
        }else{
            self.likeButton.setImage(UIImage(named : "like"), for: UIControlState.normal)
            
        }
    }
    
}

extension StreamingVC: WZStatusCallback,WZAudioSink {
    
    //MARK: - WZStatusCallback Protocol Instance Methods
    
    func onWZStatus(_ status: WZStatus!) {
        printDebug(object: status.state)
        switch (status.state) {
        case .idle:
            DispatchQueue.main.async { () -> Void in
                
                printDebug(object: "The broadcast is stopped")
                CommonFunction.hideLoader(vc: self)
                
                self.updateUIControls()
            }
            
        case .starting:
            DispatchQueue.main.async { () -> Void in
                self.updateUIControls()
                printDebug(object: "Broadcast initialization")
                //CommonFunction.showLoader(vc: self)
            }
            
        case .running:
            DispatchQueue.main.async { () -> Void in
                self.broadcastButton.setTitle("Finish", for: UIControlState.normal)
                self.addDescriptionLabel.isHidden = true
                self.broadcastButton.setImage(UIImage(named:"ic_live_finishdot"), for: UIControlState.normal)
                CommonFunction.hideLoader(vc: self)
                self.descriptionTextView.isHidden = true
                self.descriptionLabel.isHidden = false
                
                self.descriptionLabel.attributedText = self.descriptionTextView.attributedText
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomViewBottom.constant = 0
                    
                    self.view.layoutIfNeeded()
                })
                
                self.shareButton.isHidden = false
                self.shareLabel.isHidden = false
                self.comments.removeAll()
                self.setTableViewHeight()
                self.getComments(isFirst : true)
                
                 self.hoursCompleteTimer = Timer.scheduledTimer(timeInterval: 21600, target: self, selector: #selector(StreamingVC.timeLimitExceeded), userInfo: nil, repeats: false)
                
                self.beforeComplitionTimer = Timer.scheduledTimer(timeInterval: 21585, target: self, selector: #selector(StreamingVC.streamAboutToEnd), userInfo: nil, repeats: false)

                
                self.updateUIControls()
            }
        case .stopping:
            DispatchQueue.main.async { () -> Void in
                self.updateUIControls()
                self.broadcastButton.setTitle("Start", for: UIControlState.normal)
                
                self.addDescriptionLabel.isHidden = false
                self.broadcastButton.setImage(UIImage(named:""), for: UIControlState.normal)
                self.descriptionTextView.isUserInteractionEnabled = true
                self.descriptionTextView.isHidden = false
                self.descriptionLabel.isHidden = true
                self.descriptionTextView.text = ""
                
                self.hoursCompleteTimer?.invalidate()
                self.rainTimer?.invalidate()
                self.beforeComplitionTimer?.invalidate()
                self.hoursCompleteTimer = nil
                self.rainTimer = nil
                self.beforeComplitionTimer = nil
                CommonWebService.sharedInstance.videoAnimationCount = 0
                SocketHelper.sharedInstance.socket.delegate = nil

                self.dismiss(animated: true, completion: nil)
                
                self.shareButton.isHidden = true
                self.shareLabel.isHidden = true
                
                CommonFunction.hideLoader(vc: self)
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.bottomViewBottom.constant = -75
                    
                    self.view.layoutIfNeeded()
                })
                //stop
                self.finishBroadcast()
                //CommonFunction.showLoader(vc: self)
                printDebug(object: "Broadcast shutting down")
            }
            
            
        default:
            printDebug(object: "failed")
        }
    }
    
    
    func onWZError(_ status: WZStatus!) {
        // If an error is reported by the GoCoder SDK, display an alert dialog containing the error details
    
        printDebug(object: "status data\(String(describing: status.data))")
        printDebug(object: "status error\(String(describing: status.error))")
        printDebug(object: "status description\(status.description)")
        printDebug(object: "status description\(status)")

 
        
        DispatchQueue.main.async { () -> Void in
            printDebug(object: status)
            
            
    if status.description == "Status is idle  , with error \"An error occurred when trying to connect to host: whozoutlive.com\" (code = 14)"{
        
        printDebug(object: "hello found")
        CommonFunction.showTsMessageErrorInViewControler(message: NSLocalizedString("stream stop due to internet", comment: ""), vc: sharedAppdelegate.parentNavigationController)
                
            }
            
            CommonFunction.hideLoader(vc: self)
      
        }
    }
    
    func start(){
        if Networking.isConnectedToNetwork{
          //  CommonFunction.showLoader(vc: self)
            if let configError = goCoder?.config.validateForBroadcast() {
                self.showAlert("Incomplete Streaming Settings", error: configError as NSError)
            }
            else {
                
                if goCoder?.status.state == .running {
                    goCoder.endStreaming(self)
                    //                    self.stopStream()
                }
                else {
                    goCoder?.startStreaming(self)
                    
                }
            }
            
        }else{
            CommonFunction.showTsMessageError(message: "Please check your internet connection.")
        }
    }
    
    
}


extension StreamingVC : UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let  char = text.cString(using: String.Encoding.utf8)!
        let isBackSpace = strcmp(char, "\\b")
        if text == " " && range.location == 0{
            
            return false
        }
        if textView === self.commentTextView{
            if (textView.text?.characters.count)! == 100 && isBackSpace != -92{
                return false
            }else{
            return true
            }
        }else{
            
        if (textView.text?.characters.count)! == 100 && isBackSpace != -92{
            return false
        }else if textView.text.characters.last == "#" && text == "#"{
            
            return false
        
        }else{
            if textView.text.characters.last == "#" && isBackSpace == -92{
                
                self.descriptionTextView.attributedText = CommonFunction.attributedHashTagString(main_string: textView.text, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white,withFont: AppFonts.lotoMedium.withSize(14))
                
            UIView.animate(withDuration: 0.5, animations: {
                    self.hashTagTableViewHeight.constant = 0
                    self.view.layoutIfNeeded()
                })
                
            }else{
                CommonFunction.delayy(delay: 0.1, closure: {
                    
                    let arr = textView.text.components(separatedBy: " ")
                    
                    
                    if text == "#"{
                        
                        
                        self.descriptionTextView.attributedText = CommonFunction.attributedHashTagString(main_string: textView.text, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white,withFont: AppFonts.lotoMedium.withSize(14))
                        
                        
                    }else if (arr.last?.contains("#"))! && (arr.last?.characters.count)! > 1{
                        
                        self.tags.removeAll()
                        
                        self.getHashTags(tagName:  arr.last!)
                        
                        self.descriptionTextView.attributedText = CommonFunction.attributedHashTagString(main_string: textView.text, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white,withFont: AppFonts.lotoMedium.withSize(14))
                        
                    }else{
                        UIView.animate(withDuration: 0.5, animations: {
                            self.hashTagTableViewHeight.constant = 0
                            
                            self.view.layoutIfNeeded()
                        })
                        
                        self.descriptionTextView.attributedText = CommonFunction.attributedHashTagString(main_string: textView.text, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white,withFont: AppFonts.lotoMedium.withSize(14))
                        
                    }
                })
            }
            
            
        }
        
        return true
        
        }
    }
    
    func setTextInTextview(text:String){
        self.descriptionTextView.text = ""
        let txtArray = text.components(separatedBy: " ")
        for item in txtArray{
            if item.contains("#"){
                //self.descriptionTextView.attributer = "".append(item.red)
            }else{
                //  self.descriptionTextView.attributer = "".append(item.white)
            }
        }
    }
}

extension StreamingVC : UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView === self.commentsTableVoew{
            return self.comments.count
        }else{
            return self.tags.count

        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if tableView === self.commentsTableVoew{

            if self.comments[indexPath.row].commentType == "1"{
                return 30
            }else{
                return UITableViewAutomaticDimension
            }

        }else{
            
            return 30

        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        if tableView === self.commentsTableVoew{

            let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath) as! CommentCell
           cell.backgroundColor = UIColor.clear
            cell.commentLabel.textColor = UIColor.white
            cell.dotView.backgroundColor = UIColor.white
            
            cell.backView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            
            cell.caleulateNameWidth(name: self.comments[indexPath.row].name!,type: self.comments[indexPath.row].commentType!)
            
            cell.nameLabel.text = self.comments[indexPath.row].name
           cell.commentLabel.text = self.comments[indexPath.row].comment
            
            cell.showEmogieOrText(type: self.comments[indexPath.row].commentType!, emogieId: self.comments[indexPath.row].comment!, emojiOrRain: self.comments[indexPath.row].emojiOrRain!)
        
            cell.ghostBanButton.addTarget(self, action: #selector(StreamingVC.ghostBantapped), for: UIControlEvents.touchUpInside)
            cell.myCommentOrNot(userId:self.comments[indexPath.row].userId!)
            cell.timeLabel.textAlignment = .center

            let timeStampValue = Double(self.comments[indexPath.row].dateCreated ?? "0.0")! / 1000.0
            let date =  Date.init(timeIntervalSince1970:timeStampValue)
            cell.timeLabel.text = Date().timeFrom(date:date as Date)
            
            
            return cell

            
        }
        else{
        let cell = tableView.dequeueReusableCell(withIdentifier: "hashTagCell") as! HashTagCell
     
        cell.backgroundColor = UIColor.white
        cell.tagLavel.text = self.tags[indexPath.row].tagName
        return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === self.commentsTableVoew{
            
    }else{
        var arr = self.descriptionTextView.text.components(separatedBy : " ")
        
        printDebug(object: arr)
        
        arr.remove(at: arr.endIndex - 1)
        
        self.descriptionTextView.text =   "\(arr.joined(separator: " ")) #\(self.tags[indexPath.row].tagName!)"
        
        self.descriptionTextView.attributedText = CommonFunction.attributedHashTagString(main_string: self.descriptionTextView.text, attributedColor: AppColors.pinkColor, mainStringColor: UIColor.white,withFont: AppFonts.lotoMedium.withSize(14))
        
        self.hashTagTableView.isHidden = true
      }
    }
    
    

    func ghostBantapped(sender:UIButton){
        
        let indx = sender.tableViewIndexPath(tableView: commentsTableVoew)
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


extension StreamingVC : GetChargeIdBack{
    func getchargeId(id: String,shareUrl:String) {
        printDebug(object: id)
        self.sharingUrl = shareUrl
        self.setBroadcastProtocol(name: id)
        
        self.start()
    }
}


// MARK: - WebSocketDelegate
extension StreamingVC : WebSocketDelegate {
    
    func fireTimer(sender : Timer){
        
//        
//        self.timeElapsed += 1
//        
//        printDebug(object: "\(self.timeElapsed)......\(self.streamType)")
//        if self.timeElapsed >= 5{
//            
//            //self.totalTokens =  self.totalTokens  - 1
//            
//            self.tokenleftlabel.text = "\(self.totalTokens) Tokens Left"
//            
//            
//            if self.streamType! == "2"{
//                CommonWebService.sharedInstance.diductToken(broadCastId: self.broadcastId)
//            }
//            
//            if let tokens = CurentUser.tokenCount{
//                
//                self.totalTokens = Int(tokens)!
//                
//            }
//            
//            self.tokenleftlabel.text = "\(self.totalTokens) Tokens Left"
//            
//            
//            self.timeElapsed = 0
//            
//        }
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
    
    public func websocketDidReceiveMessage(_ socket: Starscream.WebSocket, text: String) {
        printDebug(object: "receivedJsonText\(text)")
        let returnedDict = SocketHelper.sharedInstance.convertTextToJson(text: text)
        
        printDebug(object: "returnedDict===\(returnedDict)")
        
        if let socketType = returnedDict["socketType"] as? String , socketType ==  "broadcastComment"{
            
            SocketService.postComment(json: returnedDict) { (success, comment) in
                
                print("am in here....")
                
                self.comments.append(comment)
                
              //  self.commentsTableVoew.reloadData()
                
                self.commentsTableVoew.insertRows(at: [IndexPath(row: self.self.comments.count - 1, section: 0)], with: UITableViewRowAnimation.none)
                
                self.commentsButton.setTitle("\(self.comments.count)", for: UIControlState.normal)

                self.setTableViewHeight()
                
                self.commentTextView.text = ""
                
                self.view.endEditing(true)
               
                self.commentFieldIsEmpty = true
                
                if self.comments.last?.commentType == "1"{
                    
                 //   let catagory = DataBaseControler.getCatagory(emogieId:(self.comments.last?.comment)!)
                    
                   //  let smileyType = DataBaseControler.getSmileyType(emogieId:(self.comments.last?.comment)!)
                    
                    
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
                            
                            self.commentsTableVoew.scrollToRow(at:IndexPath(row: self.comments.count - 1, section: 0), at:UITableViewScrollPosition.bottom, animated: false)
                        }
                    }else{
                        
//                        let originy : Float = Float(self.commentsTableVoew.frame.origin.y)
                        
                       // let random = arc4random_uniform(UInt32(originy - 300)) + UInt32(Float(originy - 150))

                CommonFunction.floatEmogie(id: (self.comments.last?.comment)!,isPlaySound: false,animationStartPosition: Float(self.commentsTableVoew.frame.origin.y),vcObj: self)
                    }
                }else{
                    
                    if self.comments.count > 1{
                        
                        self.commentsTableVoew.scrollToRow(at:IndexPath(row: self.comments.count - 1, section: 0), at:UITableViewScrollPosition.bottom, animated: false)
                    }
                }
            }
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "likeFeed"{
            
            SocketService.likeFeed(json: returnedDict, completionBlock: { (success, count) in
                
                self.likeCountButton.setTitle("\(count)", for: UIControlState.normal)
            })
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "viewFeed"{
            
            SocketService.viewFeed(json: returnedDict, completionBlock: { (success, count) in
                
                self.viewButton.setTitle("\(count)", for: UIControlState.normal)
                
            })
            
        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "stopstreemingadmin"{
            if let message = returnedDict["message"]{
                
                CommonFunction.showTsMessageError(message: message as? String ?? "")
            }
            
            CommonWebService.sharedInstance.videoAnimationCount = 0

            self.finishBroadcast()
            self.start()
            self.dismiss(animated: true, completion: nil)

        }else if let socketType = returnedDict["socketType"] as? String , socketType ==  "blockbandeleteadmin" || socketType == "Blockbyadmin" || socketType == "Banbyadmin" || socketType == "Deletebyadmin" {
            
                if let message = returnedDict["message"]{
                    
                    CommonFunction.showTsMessageError(message: message as? String ?? "")
                }
            
            CommonWebService.sharedInstance.videoAnimationCount = 0

            self.finishBroadcast()
            self.start()
            self.dismiss(animated: true, completion: nil)
            UserService.logoutFromApp()
        }

        printDebug(object: "returnedDict===\(String(describing: returnedDict["data"]))")
        
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        
    }
    
  
    func addTokenSocketService(){
        
        let addTokenServiceDict : jsonDictionary = ["socketType": SocketUrl.addToken as AnyObject,"data":["userId":CurentUser.userId,"token" : "500"] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: addTokenServiceDict)
        
        printDebug(object: "jsonStr---\(jsonStr)")
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
    func postCommentService(type:String,comment : String,emojiOrRain:String){
        DispatchQueue.main.async {

        if !SocketHelper.sharedInstance.socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
        }
        
            let postCommentServiceDict : jsonDictionary = ["socketType": SocketUrl.postComment as AnyObject,"data":["userId":CurentUser.userId as AnyObject ,"broadcastId" : self.streamId as AnyObject, "commentType" : type as AnyObject , "comment" : comment as AnyObject,"emojiOrRain" : emojiOrRain as AnyObject] as AnyObject]
        
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: postCommentServiceDict)
        
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
            let cmt = ["comment":comment,"commentType" : type,"dateCreated":"\( CommonFunction.getTimeStampFromDate(date: Date()) * 1000)","commentId" : "", "imageUrl":"","name" : CurentUser.userName,"userId" : CurentUser.userId,"emojiOrRain" : emojiOrRain]
        
        
    printDebug(object: "cmt is \(cmt)")
        
        let curentCmt = ImageCommentData(commentsData: cmt as jsonDictionary)
        
        self.comments.append(curentCmt)
        self.commentsTableVoew.reloadData()
        
        self.commentsButton.setTitle("\(self.comments.count)", for: UIControlState.normal)

        self.setTableViewHeight()
        
        if self.comments.count > 1 && type != "1"{
            self.commentsTableVoew.scrollToRow(at:
                IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
            
        }
        }
    }
    
    func likeFeed(like : String){
        
        let likeDict = ["socketType" : "likeFeed" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.streamId as AnyObject,"like" : like as AnyObject ] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: likeDict)
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
    
    
    func ghostBan(banUserId:String){
        
        let ghostBanDict = ["socketType" : "ghostban" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.streamId as AnyObject,"ghostBanUserId" : banUserId as AnyObject ] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: ghostBanDict)
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        self.ghostBanIds.append(banUserId)
        
        _ = self.comments.map { (obj)  in
            
            if obj.userId == banUserId{
                self.comments.remove(at: self.comments.indexOfObject(object: obj))
            }
        }
        self.commentsTableVoew.reloadData()
        self.setTableViewHeight()
        
    }
    
    
    func finishBroadcast(){
    
        let finishDict = ["socketType" : "stopBroadcast" as AnyObject ,"data" : ["userId": CurentUser.userId as AnyObject, "broadcastId" : self.streamId as AnyObject] as AnyObject]
        
        let jsonStr = SocketHelper.sharedInstance.convertDictionaryToString(dict: finishDict)
        
        SocketHelper.sharedInstance.writeToSocket(text: jsonStr)
        
    }
}


extension StreamingVC : ScrollToLastDelegate{
    
    func scrollLast() {
        self.scrollTableViewToLast()
    }
}

extension StreamingVC{
    
    func configureMakeItRain(emogiId : String){
        
        confettiView = SAConfettiView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 200))
        
        
                guard let imgArray = self.getImageArray(id: emogiId) else{
                    return
                }
        
        
        confettiView?.emogieImageArray.append(contentsOf: imgArray)
        
        confettiView?.intensity = 0.4
        confettiView?.type = .Diamond
        
        if self.rainTimer == nil {
            
            self.view.addSubview(confettiView)
            
            confettiView?.startConfetti()
            
            self.rainTimer = Timer.scheduledTimer(timeInterval: 11, target: self, selector: #selector(VideoPlayerVC.stopRain), userInfo: nil, repeats: false)
        }
        
    }
    
    func stopRain(sender : Timer){
        printDebug(object: "time elapsed \(self.rainTimeElapsed)")
        // confettiView?.startConfetti()
        confettiView?.stopConfetti()
        confettiView?.removeFromSuperview()
        self.rainTimer?.invalidate()
        self.rainTimer = nil
        self.emogiImageArray.removeAll()
    }
    
//    func getImageArray(id:String) -> [UIImage]?{
//        
//        let ids = DataBaseControler.getSmiliIds(emogieId: id)
//        
//        
//        
//        _ = ids.components(separatedBy: ",").map { (obj)in
//            
//            let path = DataBaseControler.getImagePath(emogieId: obj)
//            
//            guard let emogieImage = CommonFunction.getImage(pathName: path.0) else{
//                return
//            }
//            
//            self.emogiImageArray.append(emogieImage)
//            
//        }
//        
//        return self.emogiImageArray
//    }
    
    
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

    
    
    func stopTain(sender : Timer){
        printDebug(object: "time elapsed \(self.rainTimeElapsed)")
        confettiView?.stopConfetti()
        confettiView?.removeFromSuperview()
        self.rainTimer?.invalidate()
        self.rainTimer = nil ;
        
        if !self.rainPendingArray.isEmpty{
            
            self.configureMakeItRain(emogiId:self.rainPendingArray.first!)
            self.rainPendingArray.removeFirst()
        }
        
    }
    
    
    
}


//MARK:- Webservices
//=======================
extension StreamingVC{
    
    
    func getComments(isFirst : Bool){
        
       let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject  ,"mediaId" : self.streamId as AnyObject,"limit" : "0" as AnyObject,"mediaType" : "1" as AnyObject]
        //if isFirst{
        CommonFunction.showLoader(vc: self)
        // }
        UserService.getStreamCommentsApi(params: params) { (success, data) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
                
                if let data = data{
                    self.comments.removeAll()
                    self.streamedata = data
                    self.comments = self.streamedata.comments!
                    
                    self.commentsTableVoew.reloadData()
                    
                    self.setTableViewHeight()
                    if self.comments.count > 0{
//                        self.commentsTableVoew.scrollToRow(at:
//                            IndexPath(row: self.comments.count - 1, section: 0), at: UITableViewScrollPosition.bottom, animated: false)
                        
                    }
                }
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }

    
    
    func getHashTags(tagName : String){
        
        let params : jsonDictionary = ["tag" : tagName.replacingOccurrences(of: "#", with: "") as AnyObject]
        
        UserService.hashTagstApi(params: params) { (success, data) in
            
            if success{
                
                if let data = data{
                    
                    printDebug(object: data)
                    self.tags = data
                    self.hashTagTableView.isHidden = false
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        
                        if self.tags.count < 4{
                            self.hashTagTableViewHeight.constant = 30.0 * CGFloat(self.tags.count)
                            
                        }else{
                            self.hashTagTableViewHeight.constant = 120
                        }
                        self.view.layoutIfNeeded()
                    })
                    self.hashTagTableView.reloadData()
                    
                }else{
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        self.hashTagTableViewHeight.constant = 0
                        
                        self.view.layoutIfNeeded()
                    })
                    
                }
            }else{
                
                UIView.animate(withDuration: 0.5, animations: {
                    self.hashTagTableViewHeight.constant = 0
                    
                    self.view.layoutIfNeeded()
                })
            }
        }
        
    }
    
    
    func stopStream(){
        let params : jsonDictionary = ["streamId": self.streamId as AnyObject]
        printDebug(object: params)
       // CommonFunction.showLoader(vc: self)
        UserService.stopStreaming(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: self)
            }else{
                CommonFunction.hideLoader(vc: self)
            }
        }
    }
    
    
    
    func shareOnInstaGram(){
        // var selectedImage = UIImage()
        //        var imageData = NSData()
        //
        //        if let imagedtl :[String: AnyObject] = self.imageDetail {
        //            if let url = imagedtl["imagePath"] as? String{
        //                let urll = NSURL(string: url)
        //                print(urll)
        //                //let data:NSData =  NSData(contentsOfURL: urll!)!
        //                let data:NSData = UIImageJPEGRepresentation(self.tappedImage,1)!
        //                imageData = data
        //            }
        //        }
        
        
        let imgData:Data = UIImageJPEGRepresentation(UIImage(named: "emogie")!,1)!
        
        let instagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(instagramURL!)) {
            
            let captionString = "caption"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            
            do {
                // try imgData.write(to: URL(string: writePath)!)
                
                try imgData.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                self.documentController = UIDocumentInteractionController(url: fileURL)
                
                self.documentController.delegate = self
                
                self.documentController.uti = "com.instagram.exclusivegram"
                
                self.documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                
                self.documentController.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
                
                
            } catch {
                printDebug(object: "catch block")
            }
            
            
        } else {
            print(" Instagram is not installed ")
        }
        
    }

    
    
    
}


class HashTagCell : UITableViewCell{
    @IBOutlet weak var tagLavel: UILabel!
    
}
