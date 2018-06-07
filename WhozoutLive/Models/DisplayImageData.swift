
import UIKit

class DisplayImageData{

    
    private var displayImage : jsonDictionary
    
    init(displayImage:jsonDictionary){
        self.displayImage = displayImage
    }
    
    var viewCount : String? {
        get{
            if let viewCount = self.displayImage["viewCount"]{
                return "\(viewCount)"
            }
            return ""
        }
        
        set{
            self.displayImage["viewCount"] = newValue as AnyObject?
        }
    }

    var likeCount : String? {
        get{
            if let likeCount = self.displayImage["likeCount"]{
                return "\(likeCount)"
            }
            return ""
        }
        
        set{
            self.displayImage["likeCount"] = newValue as AnyObject?
        }
    }

    var downloadCount : String? {
        get{
            if let downloadCount = self.displayImage["downloadCount"]{
                return "\(downloadCount)"
            }
            return ""
        }
        
        set{
            self.displayImage["downloadCount"] = newValue as AnyObject?
        }
    }

    
    var commentCount : String? {
        get{
            if let commentCount = self.displayImage["commentCount"]{
                return "\(commentCount)"
            }
            return ""
        }
        
        set{
            self.displayImage["commentCount"] = newValue as AnyObject?
        }
    }
    
    
    var isLiked : String? {
        get{
            if let isLiked = self.displayImage["isLiked"]{
                return "\(isLiked)"
            }
            return ""
        }
        
        set{
            self.displayImage["isLiked"] = newValue as AnyObject?
        }
    }
    
    
    var imageUrl : String? {
        get{
            if let imageUrl = self.displayImage["imageUrl"]{
                return "\(imageUrl)"
            }
            return ""
        }
        
        set{
            self.displayImage["imageUrl"] = newValue as AnyObject?
        }
    }
    
    var next : String? {
        get{
            if let next = self.displayImage["next"]{
                return "\(next)"
            }
            return ""
        }
        
        set{
            self.displayImage["next"] = newValue as AnyObject?
        }
    }
    
    var limit : String? {
        get{
            if let limit = self.displayImage["limit"]{
                return "\(limit)"
            }
            return "0"
        }
        
        set{
            self.displayImage["limit"] = newValue as AnyObject?
        }
    }
    
    var emojiOrRain : String? {
        get{
            if let emojiOrRain = self.displayImage["emojiOrRain"]{
                return "\(emojiOrRain)"
            }
            return ""
        }
        
        set{
            self.displayImage["emojiOrRain"] = newValue as AnyObject?
        }
    }
    

    
    var comments : [ImageCommentData]? {
        get{
            if let cmts = self.displayImage["comments"] as? jsonDictionaryArray{
                
                var commentsArray:[ImageCommentData] = []
                
                for cmt in cmts{
                    let cmtObj = ImageCommentData(commentsData:cmt)
                    commentsArray.append(cmtObj)
                }

                return commentsArray
            }
            return nil
        }
        
        set{
            self.displayImage["comments"] = newValue as AnyObject?
        }
    }
    
}
