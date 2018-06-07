

import UIKit

class ImageData {

    
    private var imageData : jsonDictionary
    
    init(imageData:jsonDictionary){
        self.imageData = imageData
    }
    
    
    var id : String? {
        get{
            if let id = self.imageData["_id"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.imageData["_id"] = newValue as AnyObject?
        }
    }
    
    var imageId : String? {
        get{
            if let imageId = self.imageData["imageId"]{
                return "\(imageId)"
            }
            return ""
        }
        
        set{
            self.imageData["imageId"] = newValue as AnyObject?
        }
    }
    
    
    var imageUrl : String? {
        get{
            if let imageUrl = self.imageData["imageUrl"]{
                return "\(imageUrl)"
            }
            return ""
        }
        
        set{
            self.imageData["imageUrl"] = newValue as AnyObject?
        }
    }

    
    var like : String? {
        get{
            if let like = self.imageData["like"]{
                return "\(like)"
            }
            return ""
        }
        
        set{
            self.imageData["like"] = newValue as AnyObject?
        }
    }
    
    var views : String? {
        get{
            if let views = self.imageData["views"]{
                return "\(views)"
            }
            return ""
        }
        
        set{
            self.imageData["views"] = newValue as AnyObject?
        }
    }
    
    var islike : String? {
        get{
            if let islike = self.imageData["islike"]{
                return "\(islike)"
            }
            return ""
        }
        
        set{
            self.imageData["islike"] = newValue as AnyObject?
        }
    }

    
}
