

import UIKit

class FollowersFollowingData {

    
    private var followUserData : jsonDictionary
    
    init(followData:jsonDictionary){
        self.followUserData = followData
    }
    


    
    
    var followingId : String? {
        get{
            if let followingId = self.followUserData["followingId"]{
                return "\(followingId)"
            }
            return ""
        }
        
        set{
            self.followUserData["followingId"] = newValue as AnyObject?
        }
    }

    var live : String? {
        get{
            if let live = self.followUserData["live"]{
                return "\(live)"
            }
            return ""
        }
        
        set{
            self.followUserData["live"] = newValue as AnyObject?
        }
    }

    var userImage : String? {
        get{
            if let userImage = self.followUserData["userImage"]{
                return "\(userImage)"
            }
            return ""
        }
        
        set{
            self.followUserData["userImage"] = newValue as AnyObject?
        }
    }

    var userName : String? {
        get{
            if let userName = self.followUserData["userName"]{
                return "\(userName)"
            }
            return ""
        }
        
        set{
            self.followUserData["userName"] = newValue as AnyObject?
        }
    }

    var isfollowed : String? {
        get{
            if let isfollowed = self.followUserData["isfollowed"]{
                return "\(isfollowed)"
            }
            return ""
        }
        
        set{
            self.followUserData["isfollowed"] = newValue as AnyObject?
        }
    }
    
    var userId : String? {
        get{
            if let userId = self.followUserData["userId"]{
                return "\(userId)"
            }
            return ""
        }
        
        set{
            self.followUserData["userId"] = newValue as AnyObject?
        }
    }
    
    //.......................
    
    
//    
//    var id : String? {
//        get{
//            if let _id = self.followUserData["_id"]{
//                return "\(_id)"
//            }
//            return ""
//        }
//        
//        set{
//            self.followUserData["_id"] = newValue as AnyObject?
//        }
//    }
//    
//    
//    var image : String? {
//        get{
//            if let image = self.followUserData["image"]{
//                return "\(image)"
//            }
//            return ""
//        }
//        
//        set{
//            self.followUserData["image"] = newValue as AnyObject?
//        }
//    }
//    
//    var username : String? {
//        get{
//            if let username = self.followUserData["username"]{
//                return "\(username)"
//            }
//            return ""
//        }
//        
//        set{
//            self.followUserData["username"] = newValue as AnyObject?
//        }
//    }
    
}
