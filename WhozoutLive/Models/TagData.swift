

import UIKit

class TagData {

    private var tags : jsonDictionary
    
    init(tags : jsonDictionary){
        self.tags = tags
    }
    
    var tagId : String?{
        
        get{
            if let id = self.tags["_id"]{
                return "\(id)"
            }
            return nil
        }
        
        set{
            self.tags["_id"] = newValue as AnyObject
        }
        
    }
    
    
    var tagName : String?{
        
        get{
            if let name = self.tags["tagName"]{
                return "\(name)"
            }
            return nil
        }
        
        set{
            self.tags["tagName"] = newValue as AnyObject
        }
        
    }
}
