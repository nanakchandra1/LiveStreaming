
import UIKit

class CountryData{

    private var countryData : [String:AnyObject]
    
    init(countryData:[String:AnyObject]){
        
        self.countryData = countryData
        
    }

    var countryId: String?{
        get{
            if let id = self.countryData["_id"]{
                return "\(id)"
            }
            return nil
        }
        set{
            self.countryData["_id"] = newValue as AnyObject?
        }
    }

    var countryCode: String?{
        get{
            if let code = self.countryData["countryCode"]{
                return "\(code)"
            }
            return nil
        }
        set{
            self.countryData["countryCode"] = newValue as AnyObject?
        }
    }
    
    var countryName: String?{
        get{
            if let name = self.countryData["country"]{
                return "\(name)"
            }
            return nil
        }
        set{
            self.countryData["country"] = newValue as AnyObject?
        }
    }
}
