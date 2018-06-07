

import Foundation
import UIKit


//MARK:- Common Keys


let baseUrl = "http://54.83.173.30/v1/"

let preLoginTutorialScrollTimer = 6.0
let deviceTokenn = ""
let appBundleId = "com.whozoutLive"
let loogedInUserEmail = "loogedInUserEmail"
let loogedInUserPassword = "loogedInUserPassword"
let deviceType = "2"
let defaultDateFormat = "MM/dd/yyyy"
let TIMEOUT_INTERVAL = 30.0
let OS_PLATEFORM = "ios"

let LOCATION_UPDATED = "LOCATION_UPDATED"
let LOCATION_NOT_UPDATED = "LOCATION_NOT_UPDATED"
let PUSH_ACCESS_TOKEN_RECEIVED = "PUSH_ACCESS_TOKEN_RECEIVED"
let PUSH_ACCESS_TOKEN_NOT_RECEIVED = "PUSH_ACCESS_TOKEN_NOT_RECEIVED"
var isConnectedtoDropBox = false


//MARK:-

var pushCount = 0

let kgoogleServerKey = "AIzaSyD7-E-GYlL5IDq75KQentJmHfBROVk8g0E"


let IsIPhone = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
let IsIPad = UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad

public let USERID = CurentUser.userId

//MARK:- Storyboard Names
//MARK:-


struct  StoryboardName{
    
    static let Main = "Main"
    static let Streaming = "Streaming"
    static let TabBar = "TabBar"
    static let PostLoginTutorial = "PostLoginTutorial"
}

//MARK:- Static Keys
//MARK:-

struct  NSUserDefaultKey{
    
    static let LOGIN = "isLoggedIn"
    static let DeviceTokenn = "deviceTokenn"
    static let SystemVersion = "systemVersion"
    static let UserId = "userId"
    static let UserInfoDict = "userInfoDict"
    static let HomeTutorialShown = "homeTutorialShown"
    static let CoachMarkShown = "coachMarkShown"
    static let loginWith = "LoginWith"
}


//MARK:- Image Names
//MARK:-

struct ImageName{
    static let UNCHECK_IMAGE_STR = "UncheckRememberMe"
    static let CHECH_IMAGE_STR = "CheckRememberMe"
    static let MapPinImage = "map_pointer"
    static let StarUnselectImage = "star_unselect"
    static let StarSelectImage = "star_select"
    static let PlaceHolderImage = "user"
    static let CoachmarkImage = "coachmark2"
}

//MARK:- Static Fonts
//MARK:-

struct FontName{
    static let OpenSans_ExtraboldItalic = "OpenSans-ExtraboldItalic"
    static let OpenSans_SemiboldItalic = "OpenSans-SemiboldItalic"
    static let OpenSans_Extrabold = "OpenSans-Extrabold"
    static let OpenSans_BoldItalic = "OpenSans-BoldItalic"
    static let OpenSans_Italic = "OpenSans-Italic"
    static let OpenSans_Semibold = "OpenSans-Semibold"
    static let OpenSans_Light = "OpenSans-Light"
    static let OpenSans_Regular = "OpenSans"
    static let OpenSans_LightItalic = "OpenSansLight-Italic"
    static let OpenSans_Bold = "OpenSans-Bold"
}



//MARK:- Web Service URLs
//MARK:-



struct  URLName{

    
    //staging
//    
 //static let kBaseUrl = "http://whozoutlive.com:3002/apis/"
 //static let kSocketUrl = "ws://whozoutlive.com:3002/apis/ws"

    //live
    
    static let kBaseUrl = "http://whozoutlive.com:3000/apis/"
    static let kSocketUrl = "ws://whozoutlive.com:3000/apis/ws"
//
    static let demoUrl = "http://whozoutapp.com/public/img/users/demo.png"
    
    static let signUpUrl = URLName.kBaseUrl + "registerUser/userreg"
    
    static let kLoginUrl = URLName.kBaseUrl + "registerUser/login"
    
    static let krequestOtp = URLName.kBaseUrl + "registeruser/requestotp"
    
    static let kconfirmOtp = URLName.kBaseUrl + "registeruser/confirmotp"
    
    static let knewPassword = URLName.kBaseUrl + "registeruser/userchangepassword"
    
    static let kImageUrl = URLName.kBaseUrl + "user/userreg"
    
    static let kcountryListUrl = URLName.kBaseUrl + "hashtag/countrylist"
    
    static let kTokenAmtListUrl = URLName.kBaseUrl + "hashtag/tariffdropdownlist"
    
    static let kStartStreaming = URLName.kBaseUrl + "broadcast/start-streeming"
    
    static let kFeedListUrl = URLName.kBaseUrl + "broadcast/livefeeds"
    
    static let kNotificationUrl = URLName.kBaseUrl + "notification/my-notifications"
    
    static let ktagsUrl = URLName.kBaseUrl + "hashtag/search"
    
    static let kGetUrl = URLName.kBaseUrl + "broadcast/chargeCode"

    static let knotificationStatus = URLName.kBaseUrl + "notification/view-notification"
    
   static let kfollowUnfollow = URLName.kBaseUrl + "follow/follow-user"
    
    static let kFollowersUrl = URLName.kBaseUrl + "follow/followers"
    
    static let kFollowingUrl = URLName.kBaseUrl +  "follow/following"
    
    static let kOtherProfile = URLName.kBaseUrl + "user/view-user"
    
    static let kMyProfile = URLName.kBaseUrl + "user/view-profile"

    static let kProfileType = URLName.kBaseUrl + "user/edit-profile-type"
    
    static let kEditProfile = URLName.kBaseUrl + "user/edit-profile"

    static let kAddImage = URLName.kBaseUrl + "user/add-images"
    
    static let kAllImages = URLName.kBaseUrl + "user/find-user-images"
    
    static let kBlockUser = URLName.kBaseUrl + "user/block-users"
   
    static let kBlockUsers = URLName.kBaseUrl + "user/my-block-users"

    static let kNotificationSettings = URLName.kBaseUrl + "user/notification-setting"
    
    static let kChangepasswords = URLName.kBaseUrl + "user/change-password"
    
    static let kUnblockUser = URLName.kBaseUrl +  "user/unblock-users"
    
    static let kDocUpload = URLName.kBaseUrl + "user/upload-doc"
    
    static let kemailDocument = URLName.kBaseUrl + "user/document-on-mail"
    
    static let kfeedSearch = URLName.kBaseUrl + "broadcast/broadcast-searching"
    
     static let kFollowersSearch = URLName.kBaseUrl + "follow/search-follower"
    
      static let kFollowingSearch = URLName.kBaseUrl + "follow/search-following"
    
     static let kblockUserSearch = URLName.kBaseUrl + "user/block-users-search"
    
    static let kPostComment = URLName.kBaseUrl + "comment/comment-image"
    
    static let kGetComments = URLName.kBaseUrl + "comment/comments-image"

    static let klikeFeed = URLName.kBaseUrl + "broadcast/like-feed"
    
    static let klikeImage = URLName.kBaseUrl + "broadcast/like-image"
    
    static let klikeLikt = URLName.kBaseUrl + "broadcast/likes-list"
    
    static let kViewImage = URLName.kBaseUrl + "broadcast/view-image"
    
    static let kViewList = URLName.kBaseUrl + "broadcast/views-list"
    
    static let kViewFeed = URLName.kBaseUrl + "broadcast/view-feed"
    
     static let kLikeSearch = URLName.kBaseUrl + "user/like-users-search"
    
     static let kViewsSearch = URLName.kBaseUrl + "user/view-users-search"
    
    static let kDownloadImage = URLName.kBaseUrl + "user/download-image"
    
      static let ksyncEmogies = URLName.kBaseUrl + "smiley/smilies"
    
    static let kSyncEmogiesOrNot = URLName.kBaseUrl + "smiley/api-sync"

   static let kTokenPurchased = URLName.kBaseUrl + "user/add-tokens"
    
    static let kNewTokenAmtListUrl = URLName.kBaseUrl + "hashtag/new-tariffdropdownlist"

    
    static let kTokenDiduct = URLName.kBaseUrl + "user/deduction"

    static let kGetStreamComments = URLName.kBaseUrl + "comment/comments-broadcast"

    static let kStopWatching = URLName.kBaseUrl + "user/stop-watching"
   
    static let kTokenPurchasedService = URLName.kBaseUrl + "registerUser/add-tokens"
    
    static let kTokenReceived = URLName.kBaseUrl + "user/recive-tokens"
    
    static let kOtherUsers = URLName.kBaseUrl + "follow/users-list"

   static let kaddTokeninApp = URLName.kBaseUrl + "user/add-token-inapp"
    
    static let kLogout = URLName.kBaseUrl + "user/user-logout"
    
    static let kaddAccountInfo = URLName.kBaseUrl + "user/add-account"
    
    static let kgetAccountInfo = URLName.kBaseUrl + "user/user-account-details"

    static let kupdateDeviceToken = URLName.kBaseUrl + "user/update-device-token"

    static let kHistoryUrl = URLName.kBaseUrl + "user/account-report"
      static let kStopStreaming = URLName.kBaseUrl +  "broadcast/stop-streeming"
   
    
    static let kDownloadPdf = "http://whozoutlive.com/tax-document-non-us.pdf"
    
}

struct StreamingConstants {
    static let url = "whozoutlive.com"
    static let port = 1935
    static let userNamae = "test"
    static let password = "test123"
    static let applicationName = "live"
    static let frameRate = 60
}

struct PolicyUrl{
    
    static let policyBase = "http://eolith.live/appcontent/"
    static let about =  PolicyUrl.policyBase + "about"
    static let terms =  PolicyUrl.policyBase + "terms"
    static let faq =  PolicyUrl.policyBase + "faq"
    static let privacy =  PolicyUrl.policyBase + "privacypolicy"
}


struct InAppPurchasePecks{
    static let plan1 = "com.whozout.whozoutlive_25for5.99"
    static let plan2 = "com.whozout.whozoutlive_65for13.99"
    static let plan3 = "com.whozout.whozoutlive_150for29.99"
    static let plan4 = "com.whozout.whozoutlive_260for49.99"
    static let plan5 = "com.whozout.whozoutlive_375for69.99"
    static let plan6 = "com.whozout.whozoutlive_575for99.99"
    static let plan8 = "com.whozout.whozoutlive_2200for349.99"
    static let plan7 = "com.whozout.whozoutlive_1075for179.99"
}


struct SocketUrl {
    
    static let addToken = "addTokens"
    static let postComment = "broadcastComment"

    
}

struct AppColors{
    static let placeHolderColor = CommonFunction.rgbColor(red: 82, green: 90, blue: 103, alpha: 1)
   
    static let pinkColor = CommonFunction.rgbColor(red: 165, green: 70, blue: 134, alpha: 1)
   
    static let seperatorGreyColor = CommonFunction.rgbColor(red: 82, green: 90, blue: 103, alpha: 0.5)
   
    static let pinkPurpleColor = CommonFunction.rgbColor(red: 210, green: 48, blue: 100, alpha: 1)
   
    static let blueColor = CommonFunction.rgbColor(red: 28, green: 158, blue: 196, alpha: 1)
    
    static let headerColor = CommonFunction.rgbColor(red: 241, green: 241, blue: 241, alpha: 1.0)
    
    static let borderColor = CommonFunction.rgbColor(red: 82, green: 90, blue: 103, alpha: 1.0)

    static let femaleTextColor = CommonFunction.rgbColor(red: 165, green: 70, blue: 134, alpha: 1.0)
    
    static let goLiveBorderColor = CommonFunction.rgbColor(red: 129, green: 44, blue: 101, alpha: 1.0)
    
    static let blackColor = CommonFunction.rgbColor(red: 40, green: 40, blue: 40, alpha: 1.0)

    static let lightGrey = CommonFunction.rgbColor(red: 166, green: 174, blue: 187, alpha: 1.0)
    
    static let lightSeperatorColor = CommonFunction.rgbColor(red: 223, green: 223, blue: 223, alpha: 1.0)
}


