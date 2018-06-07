

import Foundation
import SystemConfiguration
import AFNetworking

let NO_INTERNET_MSG = "No Internet Connection Found"
let NO_INTERNET_ERROR_CODE = -100
let PARSING_ERROR_CODE = -101
let TimeOutInterval : TimeInterval = 10.0
let api_access_token = ""
let api_key = ""

public final class Networking
{
    
    internal typealias webServiceSuccess = (_ json : AnyObject) -> Void
    internal typealias webServiceFailure = (_ error : NSError) -> Void
    class var isConnectedToNetwork : Bool
    {
        
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        //CommonFunction.showTsMessageError(message: "Please Check your Internet connection.")
        
        return (isReachable && !needsConnection)
    }
    
    internal typealias WebServiceSuccess = (_ JSON : [String : AnyObject]) -> Void
    internal typealias WebServiceFailure = (_ error : NSError) -> Void
    
    
   
    
    class func POST(URLString: String!, parameters: AnyObject! ,successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        printDebug(object: "Post")
        if !Networking.isConnectedToNetwork {
              printDebug(object: "Post2")
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
        
            return
        }
        
        printDebug(object: "url string is \(URLString)")
  
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFHTTPRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        
        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")
        
        
      printDebug(object: "header......\(manager.requestSerializer.httpRequestHeaders)")

        manager.post(URLString, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject) -> Void in
            
            let decodedStr = NSString(data: (responseObject as! NSData) as Data, encoding: 4)
            printDebug(object : "gadbad")
            printDebug(object : decodedStr)
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let jsonDict = jsonObject as? [String: AnyObject] {
                   
                    successBlock(jsonDict)
                }
                else {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        }){ (task: URLSessionDataTask?, error) -> Void in
            failureBlock((error as NSError))
        }
    }
    
    
    
    
    class func POSTWITHOUTENCODE(URLString: String!, parameters: AnyObject! ,successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        
        if !Networking.isConnectedToNetwork{
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
            return
        }
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        
        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        
        manager.post(URLString, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject) -> Void in
           
            let decodedStr = NSString(data: (responseObject as! NSData) as Data, encoding: 4)
            
            printDebug(object: decodedStr)
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                

                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        }){ (task: URLSessionDataTask?, error) -> Void in
            failureBlock((error as NSError))
        }
    }
    
    
    class func POSTWithImage(URLString: String!, parameters: AnyObject!, imagedata: NSData?, imageKey: String!, successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure)
    {
        
        if !Networking.isConnectedToNetwork {
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
            
            return
        }
        
            let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue(api_key, forHTTPHeaderField: "Api-Key")

        if let accessToken = CurentUser.accessToken{

            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        
        manager.post(URLString, parameters: parameters, constructingBodyWith: { (multipartFormData: AFMultipartFormData!) -> Void in
            if imagedata != nil {
                multipartFormData.appendPart(withFileData: imagedata! as Data, name: imageKey, fileName:"img.jpg", mimeType:"image/jpeg")
            }
            }, progress: { (progress) -> Void in
            }, success: { (task, result) -> Void in
                
            
                do{
                    let jsonObject =  try JSONSerialization.jsonObject(with: (result as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                    if let jsonDict = jsonObject as? [String: AnyObject]
                    {
                        successBlock(jsonDict)
                    }
                    else
                    {
                        
                        printDebug(object: "...........failed")
                        failureBlock(NSError.jsonParsingError(urlString: URLString))
                    }
                    
                }catch{
                    printDebug(object: "...........completely failed")

                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
        }) { (task, error) -> Void in
            printDebug(object: "...........more theen completely failed \(error.localizedDescription)")

            failureBlock((error as NSError))
            
        }
    }
    
    
    
    class func POSTWithPdf(URLString: String!, parameters: AnyObject!, imagedata: NSData?, imageKey: String!, successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure)
    {
        
        if !Networking.isConnectedToNetwork {
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
            
            return
        }
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue(api_key, forHTTPHeaderField: "Api-Key")
        
        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        
        // manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(api_username, password: api_password)
        
        manager.post(URLString, parameters: parameters, constructingBodyWith: { (multipartFormData: AFMultipartFormData!) -> Void in
            if imagedata != nil {
                multipartFormData.appendPart(withFileData: imagedata! as Data, name: imageKey, fileName:"doc.pdf", mimeType:"application/pdf")
            }
        }, progress: { (progress) -> Void in
        }, success: { (task, result) -> Void in
            
            _ = NSString(data: (result as! NSData) as Data, encoding: 4)
            //printlnDebug(decodedStr)
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (result as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
            
        }) { (task, error) -> Void in
            failureBlock((error as NSError))
            
        }
    }

    
    
    class func PUTWithImage(URLString: String!, parameters: AnyObject!, imagedata: NSData?, imageKey: String!, successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        
        
        if !Networking.isConnectedToNetwork {
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
            
            return
        }
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue(api_key, forHTTPHeaderField: "Api-Key")
        // manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(api_username, password: api_password)
        
        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        
        manager.put_GURPREET(URLString, parameters: parameters, constructingBodyWith: { (multipartFormData: AFMultipartFormData!) -> Void in
            if imagedata != nil {
                multipartFormData.appendPart(withFileData: imagedata! as Data, name: imageKey, fileName:"img.jpg", mimeType:"image/jpeg")
            }
        }, progress: { (progress) -> Void in
        }, success: { (task, result) -> Void in
            
            _ = NSString(data: (result as! NSData) as Data, encoding: 4)
            //printlnDebug(decodedStr)
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (result as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
            
        }) { (task, error) -> Void in
            failureBlock((error as NSError))
            
        }
        
           }

    
    //Mark : Get Request
    class func GET(URLString: String!, parameters: AnyObject? ,successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        printDebug(object: "here///")
        if !Networking.isConnectedToNetwork{
            
            printDebug(object: "here///2")

            
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
           
            
            return
        }
        
        printDebug(object: "here///3")

        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
       // manager.requestSerializer.setAuthorizationHeaderFieldWithUsername(api_username, password: api_password)
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue(api_key, forHTTPHeaderField: "Api-Key")

        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
    manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        printDebug(object: URLString)
        printDebug(object: parameters)
        printDebug(object: "header is \(manager.requestSerializer.httpRequestHeaders)")
        manager.get(URLString, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject) -> Void in
            
            let decodedStr = NSString(data: (responseObject as! NSData) as Data, encoding: 4)
            
           
            printDebug(object: "decodedStr-----")
            printDebug(object: decodedStr)
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                
            
                if let jsonDict = jsonObject as? [String: AnyObject]
                {
                    
                   
                    
                    successBlock(jsonDict)
                }
                else
                {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                
                printDebug(object: "fail///1")
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        }){ (task: URLSessionDataTask?, error) -> Void in
            
            printDebug(object: "fail///2")
            printDebug(object: error.localizedDescription)
            failureBlock((error as NSError))
            
        }
    }
    
    
    class func POSTWITHJSON(URLString: String!, parameters: AnyObject! ,successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        
        if !Networking.isConnectedToNetwork {
            
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
           
            
            return
        }
        
      
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval
        manager.requestSerializer.setValue("application/json" , forHTTPHeaderField: "Accept")
        manager.requestSerializer.setValue("application/json" , forHTTPHeaderField: "Content-Type")

        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

        manager.post(URLString, parameters: parameters, progress: nil, success: { (task: URLSessionDataTask, responseObject) -> Void in
            
           // let decodedStr = NSString(data: (responseObject as! NSData) as Data, encoding: 4)
            
            
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let jsonDict = jsonObject as? [String: AnyObject] {
                   
                    
                    successBlock(jsonDict)
                }
                else {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        }){ (task: URLSessionDataTask?, error) -> Void in
            failureBlock((error as NSError))
        }
    }
    
    class func PUT(URLString: String!, parameters: AnyObject! ,successBlock: @escaping WebServiceSuccess , failureBlock: @escaping WebServiceFailure){
        
        if !Networking.isConnectedToNetwork {
            
            let errorUserInfo =
                [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                    NSURLErrorFailingURLErrorKey : "\(URLString)"
            ]
            
            let noInternetError =  NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
            
            failureBlock(noInternetError)
            
//            VKCCommon.showNotificationInViewControllr(msg: noInternetError.localizedDescription)
            
            return
        }
        
        let manager = AFHTTPSessionManager(baseURL: NSURL(string: URLString) as URL?)
        manager.responseSerializer = AFHTTPResponseSerializer()
        manager.requestSerializer = AFJSONRequestSerializer()
        manager.requestSerializer.timeoutInterval = TimeOutInterval

        if let accessToken = CurentUser.accessToken{
            manager.requestSerializer.setValue(accessToken, forHTTPHeaderField: "accesstoken")
        }
        manager.requestSerializer.setValue("592c288eb6177c11d85d470a", forHTTPHeaderField: "appversion")

         manager.put(URLString, parameters: parameters, success: { (task: URLSessionDataTask, responseObject) -> Void in
            
           // let decodedStr = NSString(data: (responseObject as! NSData) as Data, encoding: 4)
            
          
            
            do{
                let jsonObject =  try JSONSerialization.jsonObject(with: (responseObject as! NSData) as Data, options: JSONSerialization.ReadingOptions.mutableContainers)
                
                if let jsonDict = jsonObject as? [String: AnyObject] {
                    
                    
                    successBlock(jsonDict)
                }
                else {
                    failureBlock(NSError.jsonParsingError(urlString: URLString))
                }
                
            }catch{
                failureBlock(NSError.jsonParsingError(urlString: URLString))
            }
        }){ (task: URLSessionDataTask?, error) -> Void in
            failureBlock((error as NSError))
        }
    }
    
}


extension NSError{
    
    class func networkConnectionError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : NO_INTERNET_MSG,
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: NO_INTERNET_ERROR_CODE, userInfo:errorUserInfo)
    }
    
    class func jsonParsingError(urlString: String) -> NSError{
        let errorUserInfo =
            [   NSLocalizedDescriptionKey : "Error In Parsing JSON",
                NSURLErrorFailingURLErrorKey : "\(urlString)"
        ]
        return NSError(domain: NSCocoaErrorDomain, code: PARSING_ERROR_CODE, userInfo:errorUserInfo)
    }
}
