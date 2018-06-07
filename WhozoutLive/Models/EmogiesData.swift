

import UIKit

class EmogiesData {

    
    private var emogies : jsonDictionary
    
    init(emogie:jsonDictionary){
        self.emogies = emogie
    }
    
    var emogiId : String? {
        get{
            if let id = self.emogies["_id"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.emogies["_id"] = newValue as AnyObject?
        }
    }
    
    var category : String? {
        get{
            if let category = self.emogies["category"]{
                return "\(category)"
            }
            return ""
        }
        
        set{
            self.emogies["category"] = newValue as AnyObject?
        }
    }
    
    var price : String? {
        get{
            if let price = self.emogies["price"]{
                return "\(price)"
            }
            return ""
        }
        
        set{
            self.emogies["price"] = newValue as AnyObject?
        }
    }
    
    var url : String? {
        get{
            if let url = self.emogies["url"]{
                return "\(url)"
            }
            return ""
        }
        
        set{
            self.emogies["url"] = newValue as AnyObject?
        }
    }
    
    var version : String? {
        get{
            if let version = self.emogies["version"]{
                return "\(version)"
            }
            return ""
        }
        
        set{
            self.emogies["version"] = newValue as AnyObject?
        }
    }
    
    
    var smileyIds : String? {
        get{
            if let smileyIds = self.emogies["smileyIds"]{
                return "\(smileyIds)"
            }
            return ""
        }
        
        set{
            
            self.emogies["smileyIds"] = newValue as AnyObject?
        }
    }
    
    var dimension : String? {
        get{
            if let dimension = self.emogies["dimension"]{
                return "\(dimension)"
            }
            return ""
        }
        
        set{
            
            self.emogies["dimension"] = newValue as AnyObject?
        }
    }
    
    var isDeleted : String? {
        get{
            if let isDeleted = self.emogies["isDeleted"]{
                return "\(isDeleted)"
            }
            return ""
        }
        
        set{
            
            self.emogies["isDeleted"] = newValue as AnyObject?
        }
    }
    
    
    var modified : String? {
        get{
            if let modified = self.emogies["modified"]{
                return "\(modified)"
            }
            return ""
        }
        
        set{
            
            self.emogies["modified"] = newValue as AnyObject?
        }
    }
    
    
    var smileyType : String? {
        get{
            if let smileyType = self.emogies["smileyType"]{
                return "\(smileyType)"
            }
            return ""
        }
        
        set{
            
            self.emogies["smileyType"] = newValue as AnyObject?
        }
    }
    

    
    

    
}
