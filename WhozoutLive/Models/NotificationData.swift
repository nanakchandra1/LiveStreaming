

import UIKit

class NotificationData {

    
    private var notificationData : jsonDictionary
    
    init(notification:jsonDictionary){
        self.notificationData = notification
    }
    
    
    var message : String? {
        get{
            if let msg = self.notificationData["content"]{
                return "\(msg)"
            }
            return ""
        }
        
        set{
            self.notificationData["content"] = newValue as AnyObject?
        }
    }
    
    var notificationType : String? {
        get{
            if let type = self.notificationData["notificationType"]{
                return "\(type)"
            }
            return ""
        }
        
        set{
            self.notificationData["notificationType"] = newValue as AnyObject?
        }
    }
    
    var relationId : String? {
        get{
            if let relationId = self.notificationData["relationId"]{
                return "\(relationId)"
            }
            return ""
        }
        
        set{
            self.notificationData["relationId"] = newValue as AnyObject?
        }
    }
    
    var status : String? {
        get{
            if let status = self.notificationData["status"]{
                return "\(status)"
            }
            return ""
        }
        
        set{
            self.notificationData["status"] = newValue as AnyObject?
        }
    }
    
    var userImage : String? {
        get{
            if let imgUrl = self.notificationData["imageId"]{
                return "\(imgUrl)"
            }
            return ""
        }
        
        set{
            self.notificationData["imageId"] = newValue as AnyObject?
        }
    }

    var timeStamp : String? {
        get{
            if let time = self.notificationData["dateUpdated"]{
                return "\(time)"
            }
            return ""
        }
        
        set{
            self.notificationData["dateUpdated"] = newValue as AnyObject?
        }
    }
    
    var name : String? {
        get{
            if let name = self.notificationData["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.notificationData["name"] = newValue as AnyObject?
        }
    }
    
    var notificationId : String? {
        get{
            if let id = self.notificationData["notificationId"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.notificationData["notificationId"] = newValue as AnyObject?
        }
    }
    
    
    
    var shareType : String? {
        get{
            if let shareType = self.notificationData["shareType"]{
                return "\(shareType)"
            }
            return ""
        }
        
        set{
            self.notificationData["shareType"] = newValue as AnyObject?
        }
    }

}
