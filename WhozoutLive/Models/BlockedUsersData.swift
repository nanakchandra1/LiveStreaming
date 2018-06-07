

import UIKit

class BlockedUsersData{

    
    
    private var blockedUserData : jsonDictionary
    
    init(blockeduser:jsonDictionary){
        self.blockedUserData = blockeduser
    }
    
    
    var name : String? {
        get{
            if let name = self.blockedUserData["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.blockedUserData["name"] = newValue as AnyObject?
        }
    }


    var id : String? {
        get{
            if let id = self.blockedUserData["_id"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.blockedUserData["_id"] = newValue as AnyObject?
        }
    }

    var blockType : String? {
        get{
            if let blockType = self.blockedUserData["blockType"]{
                return "\(blockType)"
            }
            return ""
        }
        
        set{
            self.blockedUserData["blockType"] = newValue as AnyObject?
        }
    }
    
    var imageUrl : String? {
        get{
            if let imageUrl = self.blockedUserData["imageUrl"]{
                return "\(imageUrl)"
            }
            return ""
        }
        
        set{
            self.blockedUserData["imageUrl"] = newValue as AnyObject?
        }
    }

  
}
