
import UIKit

internal typealias jsonDictionary = [String : AnyObject]
internal typealias jsonDictionaryArray = [jsonDictionary]
internal typealias StringArray = [String]


class UserService {
    
    internal typealias CompletionClosure = (_ success : Bool,_ data: jsonDictionary?) -> Void
    
    internal typealias ComplitionWithDictionary = (_ infoDict:[String:AnyObject])->()
    
    
    
    
    class func signupApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        
        Networking.POST(URLString: URLName.signUpUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let data = JSON["data"] as? jsonDictionary{
                    
                    _ = CurentUser(info: data)
                    
                    completionHandler(true, data)
                    
                    
                }
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
            
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
            //completionBlock(success: false, errorMessage: error.localizedDescription, data: nil)
        }
    }
    
    
    class func loginApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        Networking.POST(URLString: URLName.kLoginUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let data = JSON["data"] as? jsonDictionary{
                    
                    _ = CurentUser(info: data)
                    
                    completionHandler(true, data)
                }
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
            
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
            
        }
    }
    
    
    class func requestOtpApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        
        Networking.POST(URLString: URLName.krequestOtp, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                
                
                completionHandler(true, nil)
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
            
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
        }
    }
    
    class func confirmotpApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        
        Networking.POST(URLString: URLName.kconfirmOtp, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                
                completionHandler(true, nil)
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
        }
    }
    
    
    class func resetPasswordApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        Networking.PUT(URLString: URLName.knewPassword, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                
                completionHandler(true, nil)
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
        }
    }
    
    
    
    class func uploadImageApi(params:[String:AnyObject],imageData:NSData?,imageKey:String ,completionBlock:@escaping CompletionClosure){
        
        
        Networking.PUTWithImage(URLString: URLName.kImageUrl, parameters: params as AnyObject!, imagedata: imageData, imageKey: imageKey, successBlock: { (JSON) in
            if let code = JSON["code"] as? Int, code == 200{
                
                if let data = JSON["data"] as? jsonDictionary{
                    
                    printDebug(object: data)
                    
                    
                    
                    AppUserDefaults.save(value: data["image"] ?? "", forKey: AppUserDefaults.Key.User_Image)
                    
                    AppUserDefaults.save(value: data["gender"] ?? "", forKey: AppUserDefaults.Key.User_Gender)
                    
                    completionBlock(true, data)
                    
                }
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            
        }) { (error) in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            
        }
    }
    
    
    
    class func countryListApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: [CountryData]?) -> ())){
        
        
        Networking.POST(URLString: URLName.kcountryListUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let countryData = JSON["data"] as? jsonDictionaryArray{
                    
                    var countryDataArr:[CountryData] = []
                    for infoDict in countryData{
                        let countData = CountryData(countryData:infoDict)
                        countryDataArr.append(countData)
                    }
                    
                    completionBlock(true, countryDataArr)
                    
                }
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false, nil)
            
        }
    }
    
    
    class func tokenAmtListApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: StringArray?) -> ())){
        
        Networking.POST(URLString: URLName.kTokenAmtListUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let tokenData = JSON["data"] as? jsonDictionaryArray{
                    printDebug(object: tokenData)
                    
                    var tokenDataArr:StringArray = []
                    for infoDict in tokenData{
                        //let tokData = TokenAmount(tokenData:infoDict)
                       // tokenDataArr.append(infoDict["val"] as? String ?? "")
                        
                    
                        tokenDataArr.append("\(infoDict["val"]!)")

                        
                    }
                    
                    completionBlock(true, tokenDataArr)
                    
                }
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false, nil)
            
        }
    }
    
    
    class func newTokenAmtListApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: StringArray? , StringArray?) -> ())){
        
        Networking.GET(URLString: URLName.kNewTokenAmtListUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let tokenData = JSON["data"] as? jsonDictionary{
                    printDebug(object: tokenData)
                    
                    guard let onetime = tokenData["onetime"] as? jsonDictionaryArray else { return }
                    
                    guard let perminute = tokenData["perminute"] as? jsonDictionaryArray else { return }
                    
                    
                    var onetimeTokenArr:StringArray = []
                    for infoDict in onetime{
                        
                        onetimeTokenArr.append("\(infoDict["val"]!)")
                        
                    }
                    
                    
                    var perminuteTokenArr:StringArray = []
                    for infoDict in perminute{
                        
                        perminuteTokenArr.append("\(infoDict["val"]!)")
                        
                    }
                    
                    completionBlock(true, onetimeTokenArr , perminuteTokenArr)
                    
                }
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil , nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false, nil , nil)
            
        }
    }

    
    
    class func startStreamingApi(params:[String:AnyObject], completionHandler: @escaping CompletionClosure){
        
        Networking.POST(URLString: URLName.kStartStreaming, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            if let code = JSON["code"] as? Int, code == 200{
                printDebug(object: JSON["data"])
                
                if let result = JSON["data"] as? jsonDictionary{
                    printDebug(object: result)
                    completionHandler(true,result)
                }else{
                    printDebug(object: "not")
                    
                }
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionHandler(false, nil)

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false, nil)
            }
            
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
            //completionBlock(success: false, errorMessage: error.localizedDescription, data: nil)
        }
    }
    
    class func feedsApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FeedsData]?,_ message:String?) -> ())){
        
        Networking.GET(URLString: URLName.kFeedListUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let feeds = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                if let count = JSON["notificationCount"] as? Int{
                    if count > 9{
                        
                        printDebug(object: "push count is \(count)")
                        
                        CommonWebService.sharedInstance.pushCount = 9
                        
                    }else{
                        CommonWebService.sharedInstance.pushCount = count
                        
                    }
                }
                
                
                if let val = JSON["docUpload"] as? Int{
                    AppUserDefaults.save(value : "\(val)" , forKey:AppUserDefaults.Key.DocUpload)
                    
                }
                
                var feedDataArr:[FeedsData] = []
                for feedItem in feeds{
                    let feedObj = FeedsData(feed:feedItem)
                    feedDataArr.append(feedObj)
                }
                
                completionBlock(true, feedDataArr,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,JSON["message"] as? String ?? "")

                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 248{
                if let count = JSON["notificationCount"] as? Int{
                    if count > 9{
                        
                        printDebug(object: "push count is \(count)")
                        
                        CommonWebService.sharedInstance.pushCount = 9
                        
                    }else{
                        CommonWebService.sharedInstance.pushCount = count
                        
                    }
                }
                
                
                if let val = JSON["docUpload"] as? Int{
                    AppUserDefaults.save(value : "\(val)" , forKey:AppUserDefaults.Key.DocUpload)
                    
                }
                
                completionBlock(false, nil,JSON["message"] as? String ?? "")

            }else{
               // CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"There are no streams going on right now.")
            
        }
    }
    
    
    class func notificationListApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [NotificationData]?) -> ())){
        
        Networking.POST(URLString: URLName.kNotificationUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
        
            if let noti = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? String == "\(200)"{
                
                var notiDataArr:[NotificationData] = []
                for notiItem in noti{
                    let notiObj = NotificationData(notification:notiItem)
                    notiDataArr.append(notiObj)
                }
                
                completionBlock(true, notiDataArr)
                
            }else if let code = JSON["code"] as? Int , code  == 247{
                completionBlock(false, nil)

            }
            else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                printDebug(object: "Authentication Failedddddddddd")
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                self.logoutFromApp()
                completionBlock(false, nil)

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    class func hashTagstApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [TagData]?) -> ())){
        
        Networking.POST(URLString: URLName.ktagsUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let tags = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                printDebug(object: tags)
                
                var tagsDataArr:[TagData] = []
                for tagItem in tags{
                    let tagObj = TagData(tags:tagItem)
                    tagsDataArr.append(tagObj)
                }
                
                completionBlock(true, tagsDataArr)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                self.logoutFromApp()
                completionBlock(false, nil)

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    
    
    class func stopStreaming(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kStopWatching , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let tags = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                printDebug(object: tags)
                
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                self.logoutFromApp()
                completionBlock(false)

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    
    class func getUrlApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: jsonDictionary?) -> ())){
        
        Networking.GET(URLString: URLName.kGetUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            if let data = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                
                completionBlock(true, data)
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                self.logoutFromApp()
                completionBlock(false, nil)

            }else{
                //CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    class func notificationStatus(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.PUT(URLString: URLName.knotificationStatus, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            
            printDebug(object: JSON)
            
            if let _ = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                self.logoutFromApp()
                completionBlock(false)

            }else{
                //CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false)
            
            
        }
    }
    
    
    
    class func fetchLocationForNap(params:[String:AnyObject],text:String,completionBlock:@escaping ((_ success : Bool,_ data: [PlaceApiDtaa]?) -> ())){
        
        
        let url = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=\(text)&key=\("AIzaSyD7-E-GYlL5IDq75KQentJmHfBROVk8g0E")"
        
        Networking.POST(URLString: url, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let places = JSON["predictions"] as? jsonDictionaryArray{
                
                var venueDataArr:[PlaceApiDtaa] = []
                for infoDict in places{
                    let venueData = PlaceApiDtaa(placeData:infoDict)
                    venueDataArr.append(venueData)
                }
                
                completionBlock(true, venueDataArr)
                
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    class func getLocationLatLong(params:[String:AnyObject],completionBlock:@escaping CompletionClosure){
        
        let url = "https://maps.googleapis.com/maps/api/place/details/json"
        
        Networking.GET(URLString: url, parameters: params as AnyObject?, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            completionBlock(true, JSON)
            
        }) { (error) -> Void in
            completionBlock(false, nil)
            
            
        }
    }
    
    class func followersApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?,_ message:String) -> ())){
        
        Networking.POST(URLString: URLName.kFollowersUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData, JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int, code == 260{
             
                  completionBlock(false, nil,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                self.logoutFromApp()
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")


            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"No Followers")
            
        }
    }
    
    class func followingApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?,_ message:String?) -> ())){
        
        Networking.POST(URLString: URLName.kFollowingUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followingCount = JSON["totalFollowing"] as? Int{
                CommonWebService.sharedInstance.followingCount = followingCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int, code == 259{
                
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                
            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"No Following")
            
        }
    }
    
    class func followUnfollowApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kfollowUnfollow , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            print(JSON)
            if let code = JSON["code"] as? Int, code == 200{
                
                printDebug(object: JSON)
                
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")


            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    
    class func getTagsApi(params:[String:AnyObject],searchEnabled:Bool,completionBlock:@escaping ((_ success : Bool,_ data: [TagData]?,_ limit:Int?,_ next:Int?) -> ())){
        if searchEnabled{
            printDebug(object: "---------with search")

            self.hashTagstApi(params: params, completionBlock: { (success, data) in
                
                if success{
                    completionBlock(true, data,0, 0)
                }else{
                    completionBlock(false, data,0,0)
                }
                
            })
            
        }else{
            printDebug(object: "---------without search")
            Networking.GET(URLString: URLName.ktagsUrl , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
                
                printDebug(object: JSON)
                
                if let tags = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                    
                    printDebug(object: tags)
                    
                    var tagsDataArr:[TagData] = []
                    for tagItem in tags{
                        let tagObj = TagData(tags:tagItem)
                        tagsDataArr.append(tagObj)
                    }
                    
                    completionBlock(true, tagsDataArr,JSON["limit"] as? Int ?? 0,JSON["next"] as? Int ?? 0)
                    
                }else{
                    CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                    completionBlock(false, nil,0,0)
                }
                
                //completionBlock(true, JSON)
            }) { (error) -> Void in
                completionBlock(false, nil,0,0)
                
            }

            
        }
        
    
    
    }
    
    
    class func myProfileApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: ProfileData?) -> ())){
        
        Networking.POST(URLString: URLName.kMyProfile , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
          
            
            if let profile = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
              
                let profileData = ProfileData(profileData: profile)
                
                completionBlock(true, profileData)
            
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    
    class func profileTypeApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        print("--------type")
        Networking.POST(URLString: URLName.kProfileType , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            print("--------type\(JSON)")
            if let _ = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
             
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    
    class func editProfileApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        print("--------type")
        Networking.POST(URLString: URLName.kEditProfile , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            print("--------type\(JSON)")
            if let _ = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    
    class func addImageApi(params:[String:AnyObject],imgData : NSData?,imageKey : String , completionBlock:@escaping ((_ success : Bool,_ data: ImageData?) -> ())){
        printDebug(object: "///...........")

        Networking.POSTWithImage(URLString: URLName.kAddImage, parameters: params as AnyObject!, imagedata: imgData, imageKey: imageKey, successBlock: { (JSON) in
            
            
            printDebug(object: "add image json .. \(JSON)")
            if let profile = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                let profileData = ImageData(imageData: profile)
                
                completionBlock(true, profileData)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
        }) { (error) in
            completionBlock(false, nil)

        }
        

    }
    
    
    class func otherProfileApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: ProfileData?) -> ())){
        
        Networking.POST(URLString: URLName.kOtherProfile , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            
            if let profile = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                let profileData = ProfileData(profileData: profile)
                
                completionBlock(true, profileData)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    
    class func allImagesApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [ImageData]?) -> ())){
        
        Networking.POST(URLString: URLName.kAllImages , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
               
                if let images = data["userImages"] as? jsonDictionaryArray{
                    
                var imageData:[ImageData] = []
                
                for img in images{
                    let imgObj = ImageData(imageData:img)
                    imageData.append(imgObj)
                }
                
                completionBlock(true, imageData)
            }
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    class func blockApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kBlockUser , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: "JSON....\(JSON)")
            
            if let code = JSON["code"] as? Int, code == 200{
                printDebug(object: "code is success")
                    completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    
    
    class func blockUserApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [BlockedUsersData]?) -> ())){
        
        Networking.POST(URLString: URLName.kBlockUsers , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
           
            printDebug(object: JSON)
            
            if let users = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                  var blockedUsers:[BlockedUsersData] = []
                    
                    for user in users{
                        let userObj = BlockedUsersData(blockeduser:user)
                        blockedUsers.append(userObj)
                    }
                    
                    completionBlock(true, blockedUsers)
            
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)
                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else if let code = JSON["code"] as? Int, code == 294{
                completionBlock(false, nil)

            }
            
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
           
        }) { (error) -> Void in
            
            printDebug(object: error)
            
            completionBlock(false, nil)
            
        }
    }
    
    
    class func notifivationSettingsApi(params:[String:AnyObject], completionHandler: @escaping ((_ success : Bool,_ notificationIsEnabled:String?) -> ())){
        
        Networking.PUT(URLString: URLName.kNotificationSettings, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
                printDebug(object: "200")
                if let status = data["notificationSetting"] as? Int{
                    printDebug(object: "status")
                    completionHandler(true,"\(status)")

                }
            
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionHandler(false,nil)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false,nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false, nil)
            
        }
    }

    
    class func changePasswordApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.PUT(URLString: URLName.kChangepasswords , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else if let code = JSON["code"] as? Int, code == 294{
                completionBlock(false)
                
            }
                
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    class func unBlockUser(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kUnblockUser , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
//                var blockedUsers:[BlockedUsersData] = []
//                
//                for user in users{
//                    let userObj = BlockedUsersData(blockeduser:user)
//                    blockedUsers.append(userObj)
//                }
//                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                self.logoutFromApp()
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else if let code = JSON["code"] as? Int, code == 294{
                completionBlock(false)
                
            }
                
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    class func DocumentImageUploadApi(params:[String:AnyObject],imageData:NSData?,imageKey:String ,completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POSTWithImage(URLString: URLName.kDocUpload, parameters: params as AnyObject!, imagedata: imageData, imageKey: imageKey, successBlock: { (JSON) in
            
            printDebug(object: "json")
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
            
            if let info = JSON["data"] as? jsonDictionary {
                
                printDebug(object: "check.....\(info)")
                
                    _ = CurentUser(info: info)
            

                    printDebug(object: info["identityProofFront"])
                    
                  printDebug(object: info["country"])
                  printDebug(object: info["identityProofFront"] as? String ?? "")
                
                    completionBlock(true)
                }
        
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            
        }) { (error) in
            printDebug(object: error)
            completionBlock(false)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            
        }
    }
    
    
    class func DocumentPdfUploadApi(params:[String:AnyObject],imageData:NSData?,imageKey:String ,completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POSTWithPdf(URLString: URLName.kDocUpload, parameters: params as AnyObject!, imagedata: imageData, imageKey: imageKey, successBlock: { (JSON) in
            
            printDebug(object: "json")
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let info = JSON["data"] as? jsonDictionary {
                    
                    _ = CurentUser(info: info)
            
                    printDebug(object: info["identityProofFront"])
                    
                    printDebug(object: info["country"])
                    printDebug(object: info["identityProofFront"] as? String ?? "")
                    
                    completionBlock(true)
                }
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            
        }) { (error) in
            printDebug(object: error)
            completionBlock(false)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            
        }
    }


    class func emailDocumentApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.GET(URLString: URLName.kemailDocument , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                CommonFunction.showTsMessageSuccess(message: JSON["message"] as? String ?? "")
                
                completionBlock(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false)
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }
    
    class func searchFeedsApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FeedsData]?,_ message:String?) -> ())){
        
        Networking.GET(URLString: URLName.kfeedSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let feeds = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                if let count = JSON["notificationCount"] as? Int{
                    if count > 9{
                        CommonWebService.sharedInstance.pushCount = 9
                        
                    }else{
                        CommonWebService.sharedInstance.pushCount = count
                        
                    }
                }
                
                var feedDataArr:[FeedsData] = []
                for feedItem in feeds{
                    let feedObj = FeedsData(feed:feedItem)
                    feedDataArr.append(feedObj)
                }
                
                completionBlock(true, feedDataArr,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                printDebug(object: "Authentication Failedddddddddd")

                self.logoutFromApp()
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code  == 248{
                
                completionBlock(false, nil,JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"There are no streams going on right now.")
            
        }
    }

    class func searchFollowersApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?,_ message:String?) -> ())){
        
        Networking.GET(URLString: URLName.kFollowersSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData,JSON["message"] as? String ?? "")
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{                self.logoutFromApp()
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code  == 260{
            
                completionBlock(false, nil,JSON["message"] as? String ?? "")

            }
            
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"")
            
        }
    }

    
    class func searchFollowingApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?,_ message:String?) -> ())){
        
        Networking.GET(URLString: URLName.kFollowingSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followingCount = JSON["totalFollowing"] as? Int{
                CommonWebService.sharedInstance.followingCount = followingCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData,JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil,JSON["message"] as? String ?? "")
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code  == 259{
                completionBlock(false, nil,JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false,nil,JSON["message"] as? String ?? "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,"")
            
        }
    }

    class func searchBlockUserApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [BlockedUsersData]?) -> ())){
        
        Networking.GET(URLString: URLName.kblockUserSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let users = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var blockedUsers:[BlockedUsersData] = []
                
                for user in users{
                    let userObj = BlockedUsersData(blockeduser:user)
                    blockedUsers.append(userObj)
                }
                
                completionBlock(true, blockedUsers)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                
                self.logoutFromApp()
                completionBlock(false, nil)

                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else if let code = JSON["code"] as? Int, code == 294{
                completionBlock(false, nil)
                
            }
                
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    
    class func getCommentsApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: DisplayImageData?,_ message:String?) -> ())){
        
        Networking.GET(URLString: URLName.kGetComments , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{

                    let imgData = DisplayImageData(displayImage: data)
                    
                    completionBlock(true, imgData,JSON["message"] as? String ?? "")
             
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code  == 299{
                completionBlock(false, nil,nil)

                
            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
               
                completionBlock(false, nil, JSON["message"] as? String ?? "")
            }
            
            
        }) { (error) -> Void in
            completionBlock(false, nil,nil)
            
        }
    }
    
    class func postCommentApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data : ImageCommentData?,_ message:String?) -> ())){
        
        Networking.POST(URLString: URLName.kPostComment , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
                
             let cmt = ImageCommentData(commentsData: data)
                
                
                completionBlock(true, cmt, JSON["message"] as? String ?? "")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil , JSON["message"] as? String ?? "")

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }
                
            else{
              //  CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                
                completionBlock(false, nil , JSON["message"] as? String ?? "")
                
               
            }
            
            
        }) { (error) -> Void in
            completionBlock(false,nil,nil)
            
        }
    }
    
    class func likeApi(params:[String:AnyObject], completionHandler: @escaping ((_ success : Bool,_ totalLikes : String?) -> ())){
        
        printDebug(object: "myurl--------\(URLName.klikeFeed)")
        
        Networking.PUT(URLString: URLName.klikeFeed, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
            
                if let tot = data["totalLikes"] as? Int{
                    completionHandler(true,"\(tot)")

                }
                
           
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false,nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false,nil)
            
        }
    }

    
    class func likeImageApi(params:[String:AnyObject], completionHandler: @escaping ((_ success : Bool,_ totalLikes : String?) -> ())){
        
        printDebug(object: "myurl--------\(URLName.klikeImage)")
        
        Networking.PUT(URLString: URLName.klikeImage, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
                
                if let tot = data["totalLikes"] as? Int{
                    completionHandler(true,"\(tot)")
                    
                }
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionHandler(false,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false,nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false,nil)
            
        }
    }


    
    class func getlikelistApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?) -> ())){
        
        Networking.GET(URLString: URLName.klikeLikt , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let list = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
               
                var likeList:[FollowersFollowingData] = []
                for followItem in list{
                    let listObj = FollowersFollowingData(followData:followItem)
                    likeList.append(listObj)
                }
                
                completionBlock(true, likeList)

                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    
    
    class func getViewslistApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?) -> ())){
        
        Networking.GET(URLString: URLName.kViewList , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
        if let list = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var viewList:[FollowersFollowingData] = []
                for followItem in list{
                    let listObj = FollowersFollowingData(followData:followItem)
                    viewList.append(listObj)
                }
                
                completionBlock(true, viewList)
                
                
        }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
            completionBlock(false, nil)

            self.logoutFromApp()
            
            CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            
        }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    

    class func viewImageApi(params:[String:AnyObject], completionBlock:@escaping ((_ success : Bool,_ totalViews : String?) -> ())){
        
        Networking.PUT(URLString: URLName.kViewImage, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
                
                
                completionBlock(true , String(data["views"] as? Int ?? 0))
                
            }else   if let code = JSON["code"] as? Int, code == 303{
                
                completionBlock(false,nil)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false,nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false,nil)
            
        }
    }

    
    
    class func viewFeedApi(params:[String:AnyObject], completionBlock:@escaping ((_ success : Bool,_ totalViews : String?) -> ())){
        
        Networking.PUT(URLString: URLName.kViewFeed, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary,JSON["code"] as? Int == 200{
                
                  completionBlock(true , String(data["views"] as? Int ?? 0))
            }else   if let code = JSON["code"] as? Int, code == 303{
                
                completionBlock(false,nil)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false,nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false,nil)
            
        }
    }
    

    class func searchViewsApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?) -> ())){
        
        Networking.GET(URLString: URLName.kViewsSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData)
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    class func searchLikeApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?) -> ())){
        
        Networking.GET(URLString: URLName.kLikeSearch , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var followersData:[FollowersFollowingData] = []
                for followItem in followers{
                    let followObj = FollowersFollowingData(followData:followItem)
                    followersData.append(followObj)
                }
                
                completionBlock(true, followersData)
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    class func downloadImage(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data : String?) -> ())){
        
        Networking.POST(URLString: URLName.kDownloadImage , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            if let downCount = JSON["downloadCount"] as? Int,JSON["code"] as? Int == 200{
                
                
                printDebug(object: "dcount-----\(downCount)")
                
                completionBlock(true, "\(downCount)")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }
                
            else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false,nil)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false,nil)
            
        }
    }

    class func getEmogiesApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [EmogiesData]?,_ deleted:[EmogiesData]?) -> ())){
        
        Networking.GET(URLString: URLName.ksyncEmogies , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let followers = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var emogiesData:[EmogiesData] = []
                var deleted:[EmogiesData] = []

                for followItem in followers{
                    let emogieObj = EmogiesData(emogie:followItem)
                    emogiesData.append(emogieObj)
                }
                
                if let delArray = JSON["deletedArray"] as? jsonDictionaryArray{
                    
                    for followItem in delArray{
                        let emogieObj = EmogiesData(emogie:followItem)
                        deleted.append(emogieObj)
                    }

                }
                
                
                completionBlock(true, emogiesData,deleted)
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,nil)
            
        }
    }

    class func getEmogiesOrNotApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: Int?,_ emogieSequence:String?) -> ())){
        printDebug(object:"emogie or not")
        Networking.GET(URLString: URLName.kSyncEmogiesOrNot , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let followersCount = JSON["totalFollowers"] as? Int{
                CommonWebService.sharedInstance.followersCount = followersCount
            }
            
            if let ver = JSON["version"] as? Int, JSON["code"] as? Int == 200{
                
                if let arrayStr = JSON["data"] as? String{
                    
                    completionBlock(true, ver,arrayStr)

                }
                
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,nil)
            
        }
    }

    
    
    
    
    class func getStreamCommentsApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: DisplayImageData?) -> ())){
        printDebug(object: "called")
        Networking.GET(URLString: URLName.kGetStreamComments , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: "my comments json")
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                //  if let comments = data["comments"] as? jsonDictionaryArray{
                //                    var commentsArray:[ImageCommentData] = []
                //
                //                    for cmt in comments{
                //                        let cmtObj = ImageCommentData(commentsData:cmt)
                //                        commentsArray.append(cmtObj)
                //                    }
                
                let imgData = DisplayImageData(displayImage: data)
                
                completionBlock(true, imgData)
                // }
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }
    
    class func stopWatchingApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kStopWatching , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            
            printDebug(object: "stop.....")
        
            if let code = JSON["code"] as? Int , code == 200{
                printDebug(object: "stop.....2")
                 completionBlock(true)
        
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }
                
            else{
               // CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false)
            
        }
    }

    
    class func deductTokenApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ isTokenAvail : Bool?) -> ())){
        
        Networking.POST(URLString: URLName.kTokenDiduct , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            
            printDebug(object: JSON)
            printDebug(object: "diduct,,,,,,,,,,,,,,")
            
            if let data = JSON["data"] as? jsonDictionary , JSON["code"] as? Int == 200{
                
                guard let tok = data["tokensCount"] as? Int else{
                    return
                }
                
                printDebug(object: "token is \(tok)")
          
        AppUserDefaults.save(value: "\(tok)", forKey:AppUserDefaults.Key.TokenCount)
                if let tok = CurentUser.tokenCount{
                    
                    if Int(tok)! > 0{
                        completionBlock(true,true)

                    }else{
                        completionBlock(true,false)

                    }
                    
                }else{
                    
        
                }

            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(true,false)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int, code == 306{
                
                completionBlock(true,false)

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false,false)
            }
            
            
        }) { (error) -> Void in
            completionBlock(false,false)
            
        }
    }

 
    class func tokenPurchasedApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [TokenPurchasedData]?,_ nextTimeStame : Int?,_ nextAvailable : Int?) -> ())){
        
        Networking.GET(URLString: URLName.kTokenPurchased , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let tokens = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var tokenDataArr:[TokenPurchasedData] = []
                for feedItem in tokens{
                    let feedObj = TokenPurchasedData(purchasedToken:feedItem)
                    tokenDataArr.append(feedObj)
                }
                
                guard let timeStamp = JSON["timestamp"] as? Int else{
                    printDebug(object: "returned....")
                    return
                }
                
                guard let next = JSON["next"] as? Int else{
                    printDebug(object: "returned....")
                    return
                }
                
                printDebug(object: "not returned")
                completionBlock(true, tokenDataArr,timeStamp,next)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,nil,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,nil,nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil,nil,nil)
            
        }
    }
    

    
    class func tokenReceivedApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [TokenReceivedData]?,_ nextTimeStame : Int?,_ nextAvailable : Int?,_ remaingnToken:Int?) -> ())){
        
        Networking.GET(URLString: URLName.kTokenReceived , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let tokens = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var tokenDataArr:[TokenReceivedData] = []
                for feedItem in tokens{
                    let feedObj = TokenReceivedData(ReceiveToken:feedItem)
                    tokenDataArr.append(feedObj)
                }
                
                guard let timeStamp = JSON["timestamp"] as? Int else{
                    printDebug(object: "returned....")
                    return
                }
                
                guard let next = JSON["next"] as? Int else{
                    printDebug(object: "returned....")
                    return
                }
                
                guard let remaingnToken = JSON["remaingnToken"] as? Int else{
                    printDebug(object: "returned....")
                    return
                }
            
                printDebug(object: "totalToken......\(String(describing: JSON["totalToken"]))")
                
//                guard let total = JSON["totalToken"] as? Int else{
//                    printDebug(object: "total..return..")
//                    return
//                }
//                
//                printDebug(object: "total////////....\(total)")
                
                completionBlock(true, tokenDataArr,timeStamp,next,remaingnToken)
                
            
                printDebug(object: "not returned")
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil,nil,nil,nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil,nil,nil,nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false,nil,nil,nil,nil)
            
        }
    }
    
    class func otherUsersApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: [FollowersFollowingData]?) -> ())){
        
        Networking.GET(URLString: URLName.kOtherUsers , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
        
            if let others = JSON["data"] as? jsonDictionaryArray, JSON["code"] as? Int == 200{
                
                var otherssData:[FollowersFollowingData] = []
                for followItem in others{
                    let otherObjObj = FollowersFollowingData(followData:followItem)
                    otherssData.append(otherObjObj)
                }
                
                completionBlock(true, otherssData)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)
                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code == 342{
                
                completionBlock(false, nil)

                
            }else{
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil)
            
        }
    }

    
    
    class func addtokenInAppApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ token: String?) -> ())){
        
        
        Networking.POST(URLString: URLName.kaddTokeninApp, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                if let data = JSON["data"] as? jsonDictionary{
                    
                    
            guard let tok = data["tokensCount"] as? Int else{
                        
                        return
                    }
                    
            AppUserDefaults.save(value: "\(tok)", forKey:AppUserDefaults.Key.TokenCount)
                    
                    completionBlock(true, "\(tok)")
                    
            }
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false, nil)
            
        }
    }
    

    class func logoutApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kLogout, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                completionBlock(true)

                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                //self.logoutFromApp()
                
                CommonWebService.sharedInstance.setVC()
                
            //    CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false)
            
        }
    }
    
    
    class func addAccountApi(params:[String:AnyObject], completionBlock: @escaping ((_ success : Bool) -> ())){
        
        Networking.POST(URLString: URLName.kaddAccountInfo, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{

                
                //
//                if let data = JSON["data"] as? jsonDictionary{
//                    
//                }
                completionBlock(true)
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false)

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false)
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionBlock(false)
            
        }
    }
    
    class func getAccountApi(params:[String:AnyObject],completionBlock:@escaping ((_ success : Bool,_ data: AccountInfoData?,_ message:String?) -> ())){
        
        Networking.POST(URLString: URLName.kgetAccountInfo , parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let data = JSON["data"] as? jsonDictionary, JSON["code"] as? Int == 200{
                
                completionBlock(true, AccountInfoData(accountData: data), "")
            
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionBlock(false, nil, "")

                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else if let code = JSON["code"] as? Int , code == 352{
                completionBlock(false, nil, "")

            }else{
                 CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionBlock(false, nil, "")
            }
            
            //completionBlock(true, JSON)
        }) { (error) -> Void in
            completionBlock(false, nil, "")
            
        }
    }
    
    
    class func updateDeviceTokenApi(params:[String:AnyObject], completionHandler:@escaping ((_ success : Bool) -> ())){

        Networking.POST(URLString: URLName.kupdateDeviceToken, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                completionHandler(true)
                
            }else if let code = JSON["code"] as? Int , code  == 350 || code == 351 || code == 352 || code == 353 || code == 354{
                completionHandler(false)
                
                self.logoutFromApp()
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")

            }else{
                
                completionHandler(false)
            }
            
        }) { (error) -> Void in
            printDebug(object: error)
            completionHandler(false)
            
        }
    }

    
    class func logoutFromApp(){
        
        CommonWebService.sharedInstance.logoutService(complition: { (success) in
            
            if success{
                
            }else{
                
            }
        })
        
    }

    
    class func getHistoryApi(params:[String:AnyObject], completionHandler:@escaping ((_ success : Bool,_ message:String?) -> ())){
        
        Networking.PUT(URLString: URLName.kHistoryUrl, parameters: params as AnyObject!, successBlock: { (JSON) -> Void in
            printDebug(object: JSON)
            
            if let code = JSON["code"] as? Int, code == 200{
                
                completionHandler(true,JSON["message"] as? String ?? "")
                
            }else{
                
                CommonFunction.showTsMessageError(message: JSON["message"] as? String ?? "")
                completionHandler(false,"")
            }
        }) { (error) -> Void in
            printDebug(object: error)
            CommonFunction.showTsMessageError(message: error.localizedDescription)
            completionHandler(false,"")
            
        }
    }

    
}
