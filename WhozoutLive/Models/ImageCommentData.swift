
import UIKit

class ImageCommentData{

    
    private var imageComments : jsonDictionary
    
    init(commentsData:jsonDictionary){
        self.imageComments = commentsData
    }
    
    
    var name : String? {
        get{
            if let name = self.imageComments["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.imageComments["name"] = newValue as AnyObject?
        }
    }
    
    
    var comment : String? {
        get{
            if let comment = self.imageComments["comment"]{
                return "\(comment)"
            }
            return ""
        }
        
        set{
            self.imageComments["comment"] = newValue as AnyObject?
        }
    }
    
    var commentId : String? {
        get{
            if let commentId = self.imageComments["commentId"]{
                return "\(commentId)"
            }
            return ""
        }
        
        set{
            self.imageComments["commentId"] = newValue as AnyObject?
        }
    }
    
    
    var userId : String? {
        get{
            if let userId = self.imageComments["userId"]{
                return "\(userId)"
            }
            return ""
        }
        
        set{
            self.imageComments["userId"] = newValue as AnyObject?
        }
    }

    
    var commentType : String? {
        get{
            if let commentType = self.imageComments["commentType"]{
                return "\(commentType)"
            }
            return ""
        }
        
        set{
            self.imageComments["commentType"] = newValue as AnyObject?
        }
    }
    
    var dateCreated : String? {
        get{
            if let dateCreated = self.imageComments["dateCreated"]{
                return "\(dateCreated)"
            }
            return ""
        }
        
        set{
            self.imageComments["dateCreated"] = newValue as AnyObject?
        }
    }
    
    var imageUrl : String? {
        get{
            if let imageUrl = self.imageComments["imageUrl"]{
                return "\(imageUrl)"
            }
            return ""
        }
        
        set{
            self.imageComments["imageUrl"] = newValue as AnyObject?
        }
    }
    
    var downloadCount : String? {
        get{
            if let downloadCount = self.imageComments["downloadCount"]{
                return "\(downloadCount)"
            }
            return ""
        }
        
        set{
            self.imageComments["downloadCount"] = newValue as AnyObject?
        }
    }
    
    var emojiOrRain : String? {
        get{
            if let emojiOrRain = self.imageComments["emojiOrRain"]{
                return "\(emojiOrRain)"
            }
            return ""
        }
        
        set{
            self.imageComments["emojiOrRain"] = newValue as AnyObject?
        }
    }

    
    
    
}
