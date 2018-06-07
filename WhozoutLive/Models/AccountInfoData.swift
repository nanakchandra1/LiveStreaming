

import UIKit

class AccountInfoData {

    
    private var accountData : jsonDictionary
    
    init(accountData : jsonDictionary){
        self.accountData = accountData
    }
    
    
    var id : String? {
        get{
            if let id = self.accountData["_id"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.accountData["_id"] = newValue as AnyObject?
        }
    }

    var accountHolderName : String? {
        get{
            if let accountHolderName = self.accountData["accountHolderName"]{
                //return "efrfrefer fe rf e"

                return "\(accountHolderName)"
                
                
            }
            return ""
        }
        
        set{
            self.accountData["accountHolderName"] = newValue as AnyObject?
        }
    }

    var accountNumber : String? {
        get{
            if let accountNumber = self.accountData["accountNumber"]{
                //return "1234567890"

                return "\(accountNumber)"

            }
            return ""
        }
        
        set{
            self.accountData["accountNumber"] = newValue as AnyObject?
        }
    }

    
    var accountType : String? {
        get{
            if let accountType = self.accountData["accountType"]{
                //return "2"

                return "\(accountType)"

            }
            return ""
        }
        
        set{
            self.accountData["accountType"] = newValue as AnyObject?
        }
    }
    
    var bankLocation : String? {
        get{
            if let bankLocation = self.accountData["bankLocation"]{
               // return "fdd fv df vd v d vdf"

                return "\(bankLocation)"
            }
            return ""
        }
        
        set{
            self.accountData["bankLocation"] = newValue as AnyObject?
        }
    }
    
    var bankName : String? {
        get{
            if let bankName = self.accountData["bankName"]{
               // return "fv f v f vf v fv"

                return "\(bankName)"
            }
            return ""
        }
        
        set{
            self.accountData["bankName"] = newValue as AnyObject?
        }
    }
    
    var email : String? {
        get{
            if let email = self.accountData["email"]{
               // return "pdfd@opop.com"

                return "\(email)"
            }
            return ""
        }
        
        set{
            self.accountData["email"] = newValue as AnyObject?
        }
    }

    var phoneNumber : String? {
        get{
            if let phoneNumber = self.accountData["phoneNumber"]{
               // return "434343434343"

                return "\(phoneNumber)"
            }
            return ""
        }
        
        set{
            self.accountData["phoneNumber"] = newValue as AnyObject?
        }
    }
    
    var status : String? {
        get{
            if let status = self.accountData["status"]{
                // return "434343434343"
                
                return "\(status)"
            }
            return ""
        }
        
        set{
            self.accountData["status"] = newValue as AnyObject?
        }
    }
    
    var lat : String? {
        get{
            if let lat = self.accountData["lat"]{
                // return "434343434343"
                
                return "\(lat)"
            }
            return ""
        }
        
        set{
            self.accountData["lat"] = newValue as AnyObject?
        }
    }
    
    var lng : String? {
        get{
            if let lng = self.accountData["lng"]{
                // return "434343434343"
                
                return "\(lng)"
            }
            return ""
        }
        
        set{
            self.accountData["lng"] = newValue as AnyObject?
        }
    }
    
    var nextRequestStatus : String? {
        get{
            if let nextRequestStatus = self.accountData["nextRequestStatus"]{
                // return "434343434343"
                
                return "\(nextRequestStatus)"
            }
            return ""
        }
        
        set{
            self.accountData["nextRequestStatus"] = newValue as AnyObject?
        }
    }
    
    
    var country : String? {
        get{
            if let nextRequestStatus = self.accountData["country"]{
                // return "434343434343"
                
                return "\(nextRequestStatus)"
            }
            return ""
        }
        
        set{
            self.accountData["nextRequestStatus"] = newValue as AnyObject?
        }
    }
    
    
    
    var state : String? {
        get{
            if let nextRequestStatus = self.accountData["state"]{
                
                return "\(nextRequestStatus)"
            }
            return ""
        }
        
        set{
            self.accountData["state"] = newValue as AnyObject?
        }
    }

    
    var city : String? {
        get{
            if let nextRequestStatus = self.accountData["city"]{
                
                return "\(nextRequestStatus)"
            }
            return ""
        }
        
        set{
            self.accountData["city"] = newValue as AnyObject?
        }
    }

    
}
