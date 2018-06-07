

import UIKit



class PlaceApiDtaa{

    private var placeData : jsonDictionary
    
    init(placeData:jsonDictionary){
        
        self.placeData = placeData
        
       printDebug(object: self.placeData)
    }

    var PlaceName: String?{
        get{
            
        
            if let name = self.placeData["description"]{
                return "\(name)"
            }
            return ""
        }
        set{
            self.placeData["description"] = newValue as AnyObject?
        }
    }
    var placeId: String?{
        get{
            if let id = self.placeData["place_id"]{
                return "\(id)"
            }
            return ""
        }
        set{
            self.placeData["place_id"] = newValue as AnyObject?
        }
    }
    
   }
