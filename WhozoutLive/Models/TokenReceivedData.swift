

import UIKit

class TokenReceivedData: NSObject {

    
    private var tokenReceived : jsonDictionary
    
    init(ReceiveToken : jsonDictionary){
        self.tokenReceived = ReceiveToken
    }
    
    
    var broadcastId : String? {
        get{
            if let broadcastId = self.tokenReceived["broadcastId"]{
                return "\(broadcastId)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["broadcastId"] = newValue as AnyObject?
        }
    }
    
    
    var broadcastUserId : String? {
        get{
            if let broadcastUserId = self.tokenReceived["broadcastUserId"]{
                return "\(broadcastUserId)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["broadcastUserId"] = newValue as AnyObject?
        }
    }

    var typeOfbroadcast : String? {
        get{
            if let typeOfbroadcast = self.tokenReceived["typeOfbroadcast"]{
                return "\(typeOfbroadcast)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["typeOfbroadcast"] = newValue as AnyObject?
        }
    }

    var tokenAmount : String? {
        get{
            if let tokenAmount = self.tokenReceived["tokenAmount"]{
                return "\(tokenAmount)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["tokenAmount"] = newValue as AnyObject?
        }
    }

    var content : String? {
        get{
            if let content = self.tokenReceived["content"]{
                return "\(content)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["content"] = newValue as AnyObject?
        }
    }


    var mediaType : String? {
        get{
            if let mediaType = self.tokenReceived["mediaType"]{
                return "\(mediaType)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["mediaType"] = newValue as AnyObject?
        }
    }

    
    var smileyId : String? {
        get{
            if let smileyId = self.tokenReceived["smileyId"]{
                return "\(smileyId)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["smileyId"] = newValue as AnyObject?
        }
    }

    
    var userId : String? {
        get{
            if let userId = self.tokenReceived["userId"]{
                return "\(userId)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["userId"] = newValue as AnyObject?
        }
    }

    
    var name : String? {
        get{
            if let name = self.tokenReceived["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["name"] = newValue as AnyObject?
        }
    }

    var image : String? {
        get{
            if let image = self.tokenReceived["image"]{
                return "\(image)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["image"] = newValue as AnyObject?
        }
    }
    
    var dateCreated : String? {
        get{
            if let dateCreated = self.tokenReceived["dateCreated"]{
                return "\(dateCreated)"
            }
            return ""
        }
        
        set{
            self.tokenReceived["dateCreated"] = newValue as AnyObject?
        }
    }
}
