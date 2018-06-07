
import UIKit

class SocketService: NSObject {

    
    class func postComment(json:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: ImageCommentData) -> ())){

        if let code = json["code"] as? Int , code == 200{
            
                           
                guard let data = json["data"] as? jsonDictionary else{
                    
                    return
                }
                
                guard let cmt = data["comments"] as? jsonDictionaryArray else{
                    
                    return
                }
                
                let curentCmt = ImageCommentData(commentsData: cmt[0])
                
                      completionBlock(true, curentCmt)
            
            
        }else{
            
            
            
        }
        

        
    }
    
    
    class func likeFeed(json:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: Int) -> ())){
        
        
        if let code = json["code"] as? Int , code == 200{
            
            
            guard let data = json["data"] as? jsonDictionary else{
                
                return
            }
            
            guard let count = data["likesCount"] as? Int else{
                
                return
            }
            
           
            
            completionBlock(true, count)
            
            
        }else{
            
            
            
        }
        
        
        
    }

    
    class func viewFeed(json:[String:AnyObject], completionBlock: @escaping ((_ success : Bool,_ data: Int) -> ())){
        
        
        if let code = json["code"] as? Int , code == 200{
            
            
            guard let data = json["data"] as? jsonDictionary else{
                
                return
            }
            
            guard let count = data["viewsCount"] as? Int else{
                
                return
            }
            
            
            
            completionBlock(true, count)
            
            
        }else{
            
            
        }
        
    }
    

}
