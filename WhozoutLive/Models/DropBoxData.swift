

import UIKit

class DropBoxData {

    
    
    private var dropBoxData : jsonDictionary
    
    init(dropBoxData:jsonDictionary){
        self.dropBoxData = dropBoxData
    }
    
    
    var name : String? {
        get{
            if let name = self.dropBoxData["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.dropBoxData["name"] = newValue as AnyObject?
        }
    }

    
}
