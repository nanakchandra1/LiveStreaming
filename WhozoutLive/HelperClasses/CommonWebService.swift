
import UIKit
import SwiftyDropbox

enum StreamCanRun{
    case Yes
    case No
    
    static var canRun = StreamCanRun.No
}



protocol StreamNotAvailable{
    
    func noStreamFound(feedId:String)
    
    func getFollowStatusBack(useridToFollow:String)
    
    
}


protocol ScrollToLastDelegate{
    
    func scrollLast()
}

class CommonWebService{
    
    class var sharedInstance : CommonWebService {
        
        struct Static {
            static let instance : CommonWebService = CommonWebService()
        }
        return Static.instance
    }
    
    var addPopUpDelegate : StreamNotAvailable!
    var selectedPrivateFriend : String = ""
    var pushCount : Int = 0
    var followersCount : Int = 0
    var followingCount : Int = 0
    var userIdToFollow : String!
    var videoVC : VideoPlayerVC?
    var purchaseMoreTokenPopUp : PurchasemoreTokenVC?
    var emogiesSequenceArray : StringArray?
    weak var cutTokenWhileWatching : CutWhileWatchingDelegate?
    var videoData : jsonDictionary?
    
     var scroll : ScrollToLastDelegate?
    
    var videoAnimationCount : Int?{
        
        didSet{
            
            
            
        }
        
    }
    
    
    
    init() {
        
    }
    
    func getUrl(feedId:String,vcObj:UIViewController,description:String){
        
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject ,"chargeId": feedId as AnyObject]
        
        printDebug(object: params)
        CommonFunction.showLoader(vc: vcObj)
        
        UserService.getUrlApi(params: params) { (success, data) in
            printDebug(object: data)
            
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                self.videoData = data
                
              //  self.proceedToVideoVC(data: self.videoData,feedId:feedId,vcObj:vcObj)
                
                if let shareType = data?["shareType"] as? String , shareType == "Public"{
                    self.proceedToVideoVC(feedId: feedId, vcObj: vcObj)
                }else if let type = data?["broadcastType"] as? Int , type == 1 , data?["isView"] as? Int == 1{
                     self.proceedToVideoVC(feedId: feedId, vcObj: vcObj)
                }else{
                    self.joinStreamPopUp(feedId:feedId,vcObj:vcObj)
                }
                
          
            }else{
                printDebug(object: feedId)
                self.addPopUpDelegate.noStreamFound(feedId: feedId)
                CommonFunction.hideLoader(vc: vcObj)
            }
        }
    }
    
    
    func joinStreamPopUp(feedId:String,vcObj:UIViewController){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "JoinStreamID") as! JoinStreamVC
        
        vc.price = "\(self.videoData?["broadcastPrice"] as? Int ?? 0)"
        vc.streamType = "\(self.videoData?["broadcastType"] as? Int ?? 1)"
        vc.vcObj = vcObj
        vc.feedId = feedId
        vc.joinDelegate = self
        CommonFunction.addChildVC(childVC: vc,parentVC: sharedAppdelegate.parentNavigationController)
    }
    
    
    func proceedToVideoVC(feedId:String,vcObj:UIViewController){
        
        
        if let data = self.videoData{
            
            if let _ = self.videoVC{
                
                
            }else{
                
                self.videoVC = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "VideoPlayerID") as? VideoPlayerVC
            }
            
            self.videoVC?.name = data["broadcastUserName"] as? String ?? ""
            
            self.videoVC?.imgUrl = data["imageId"] as? String ?? ""
            self.videoVC?.videoUrl = data["enurl"] as? String ?? ""
            self.videoVC?.videoDescription = data["videoDiscription"] as? String ?? ""
            
            self.videoVC?.isFollow = data["isfollowed"] as? Int ?? 0
            self.videoVC?.followUserId = data["broadcastUserId"
                ] as? String ?? ""
            self.userIdToFollow = data["broadcastUserId"] as? String ?? ""
            self.videoVC?.broadcastId = feedId
            // self.videoVC?.streamType = "2"
            
            self.videoVC?.streamType = String(data["broadcastType"] as? Int ?? 0)
            
            self.videoVC?.perMinuteToken = data["broadcastPrice"] as? Int ?? 0
            
            let deedData : jsonDictionary = ["isliked" : data["isliked"] as AnyObject? ?? "" as AnyObject,"likes" : data["likesCount"] as AnyObject? ?? "" as AnyObject,
                "views" : data["viewsCount"] as AnyObject ,"commentCount" : data["commentCount"] as AnyObject
            ]
            
            let obj = FeedsData(feed: deedData)
            self.videoVC?.feedObj = obj
            
            if let shareType = data["shareType"] as? String , shareType == "Public"{
                
                self.videoVC?.streamType = "3"
                
                sharedAppdelegate.parentNavigationController.pushViewController(self.videoVC!, animated: true)
            }else if let type = data["broadcastType"] as? Int , type == 1{
                
                if let isView = data["isView"] as? Int , isView == 1{
                    
                    self.videoVC?.streamType = "3"
                    
                sharedAppdelegate.parentNavigationController.pushViewController(self.videoVC!, animated: true)

                    
                }else{
                self.diductToken(broadCastId: feedId, vcObj: vcObj, type: "1", from: .Feed, completionBlock: { (success) in
                    
                })
                }
            }
            
            else{
                CommonFunction.hideLoader(vc: vcObj)
                
                sharedAppdelegate.parentNavigationController.pushViewController(self.videoVC!, animated: true)
                
            }
            
            
        }else{
            
        }
        self.videoData = nil
        
    }
    
    
    
    func diductToken(broadCastId : String,vcObj:UIViewController,type:String,from:PurchaseFrom,completionBlock:@escaping ((_ success : Bool) -> ())){
        
        let params : jsonDictionary = ["userId":CurentUser.userId as AnyObject, "broadcastId" : broadCastId as AnyObject]
        
        UserService.deductTokenApi(params: params) { (success,isTokenAvail) in
            
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                
                if isTokenAvail!{
                    if type == "1"{
                        sharedAppdelegate.parentNavigationController.pushViewController(self.videoVC!, animated: true)
                    }else{
                        //  sharedAppdelegate.time?.invalidate()
                   //     completionBlock(true)
                    }
                }else{
                    sharedAppdelegate.time?.invalidate()
                    self.tokenLess(from: from)
                }
                completionBlock(true)
            }else{
                printDebug(object: "not success")
                CommonFunction.hideLoader(vc: vcObj)
                completionBlock(false)

            }
            
        }
        
    }
    
    
    func tokenLess(from:PurchaseFrom) {
        
        let purchaseMoreToken = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "PurchasemoreTokenID") as? PurchasemoreTokenVC
        
        if from == PurchaseFrom.WatchingVideo {
            purchaseMoreToken?.message = "Do you want to go ahead with this?"
        }else if from == PurchaseFrom.EmogieKeyBoard{
         
            purchaseMoreToken?.message = "Please purchase more token to send this emogie."
            
        }else{ purchaseMoreToken?.message = "Please purchase more token to see this broadcast."
        }
        
        purchaseMoreToken?.purchaseFrom = from
        
        CommonFunction.addChildVC(childVC: purchaseMoreToken!, parentVC:  sharedAppdelegate.parentNavigationController)
        
    }
    
    func addChildPurchaseToken(){
        let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
        
        vc.purchaseFrom = .Feed
        
        CommonFunction.addChildVC(childVC: vc,parentVC: sharedAppdelegate.parentNavigationController)
    }
    
    
    func pushPurchaseToken(from:PurchaseFrom){
        let vc = StoryBoard.TokenManagement.instance.instantiateViewController(withIdentifier: "PurchaseTokensID") as! PurchaseTokensVC
        
        vc.purchaseFrom = from
        
        sharedAppdelegate.parentNavigationController.pushViewController(vc, animated: true)
    }
    
    
    func navigatToVideoVC(){
        
        sharedAppdelegate.parentNavigationController.pushViewController(self.videoVC!, animated: true)
        
    }
    
    
    func followUnFollowService(userId:String,followId:String,followType:String,name:String,vcObj:UIViewController,isFollowFromFeed : Bool,complition:@escaping (_ success:Bool) -> ()){
        
        //  5891eabda552d8710a347f5f
        
        let params : jsonDictionary = ["userId" : userId as AnyObject , "followId" : followId as AnyObject,
        "followType" : followType as AnyObject,"name" : CurentUser.userName as AnyObject]
        
        printDebug(object: params)
        
        CommonFunction.showLoader(vc: vcObj)
        UserService.followUnfollowApi(params: params) { (success) in
            
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                
        if let userId = self.userIdToFollow , !isFollowFromFeed{
                    self.addPopUpDelegate.getFollowStatusBack(useridToFollow: userId)
            }
                complition(true)
            }else{
                complition(false)
                CommonFunction.hideLoader(vc: vcObj)
                
            }
        }
    }
    
    
    func docImageUploadService(params:jsonDictionary,imgData:NSData?,imgKey:String,vcObj:UIViewController,complition:@escaping (_ success:Bool) -> ()){
        
        UserService.DocumentImageUploadApi(params: params, imageData: imgData, imageKey: imgKey) { (success) in
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                
                complition(true)
                
            }else{
                CommonFunction.hideLoader(vc: vcObj)
                complition(false)
                
            }
            
        }
        
    }
    
    
    
    func docPdfeUploadService(params:jsonDictionary,imgData:NSData?,imgKey:String,vcObj:UIViewController,complition:@escaping (_ success:Bool) -> ()){
        
        CommonFunction.showLoader(vc: vcObj)
        UserService.DocumentPdfUploadApi(params: params, imageData: imgData, imageKey: imgKey) { (success) in
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                
                complition(true)
                
            }else{
                CommonFunction.hideLoader(vc: vcObj)
                complition(false)
                
            }
            
        }
        
    }
    
    
    func likeDislikeFeed(vcObj:UIViewController,broadcastId : String,like:String,complition:@escaping (_ success:Bool,_ totalLikes:String?) -> ()){
        
        
        let params : jsonDictionary = ["userId":CurentUser.userId as AnyObject,"broadcastId" : broadcastId as AnyObject,"like" : like as AnyObject]
        printDebug(object: params)
        //CommonFunction.showLoader(vc: vcObj)
        
        UserService.likeApi(params: params) { (success, totalLikes) in
            
            if success{
                complition(true,totalLikes)
            }else{
                complition(false,nil)
                
            }
        }
        
    }
    
    
    func likeDislikeImage(vcObj:UIViewController,imagesId : String,like:String,complition:@escaping (_ success:Bool,_ totalLikes:String?) -> ()){
        
        
        let params : jsonDictionary = ["userId":CurentUser.userId as AnyObject,"imagesId" : imagesId as AnyObject,"like" : like as AnyObject,"name" : CurentUser.userName as AnyObject]
        printDebug(object: params)
        
        
        UserService.likeImageApi(params: params) { (success, totalLikes) in
            
            if success{
                CommonFunction.hideLoader(vc: vcObj)
                complition(true,totalLikes)
            }else{
                CommonFunction.hideLoader(vc: vcObj)
                complition(false,nil)
                
            }
            
            CommonFunction.hideLoader(vc: vcObj)
            
        }
        
    }
    
    
     func logoutService(complition:@escaping (_ success:Bool) -> ()){

        printDebug(object: "logout called.....")
        let params : jsonDictionary = ["userId" : CurentUser.userId as AnyObject]
        
        printDebug(object: "params is \(params)")
        
        UserService.logoutApi(params: params) { (success) in
            
            if success{
                
            self.setVC()
                
                complition(true)
                
            }else{
                
                 self.setVC()
                complition(false)

            }
        }
    }
    
    
    func setVC(){
       // SocketHelper.sharedInstance.socket.disconnect()

        sharedAppdelegate.agePopUpShown = false
        
        SocketHelper.sharedInstance.socket.disconnect()
        sharedAppdelegate.fromLogout = true
        
        VKCTabBarControllar.sharedInstance.streamingNavigation = nil
        
        VKCTabBarControllar.sharedInstance.streamingVC = nil
        
        sharedAppdelegate.tabBar = nil
        
        SocketHelper.sharedInstance.socket.delegate = nil
        
     let deviceToken =  AppUserDefaults.value(forKey: AppUserDefaults.Key.DevideToken)
        printDebug(object: "deviceToken is \(deviceToken)")
        AppUserDefaults.removeAllValues()
        
        AppUserDefaults.save(value: "1", forKey: AppUserDefaults.Key.User_UserId)
        AppUserDefaults.save(value: "\(deviceToken)", forKey: AppUserDefaults.Key.DevideToken)
        
        DropboxClientsManager.unlinkClients()
        DropboxClientsManager.resetClients()
        CommonFunction.setLoginToRoot()
    }
}


extension CommonWebService : JoinStream{
    
    func join() {
        
    }
    
    func joining(feedid: String, vcObj: UIViewController) {
        self.proceedToVideoVC(feedId: feedid, vcObj: vcObj)
        
    }
    
}
