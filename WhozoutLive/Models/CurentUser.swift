

import Foundation

class CurentUser{
    
    
   static var name : String?{
            return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Name).stringValue
        }
    
    static var userName : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_UserName).stringValue
    }
    
        static var email : String?{
            return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Email).stringValue
        }
    
    static var gender : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Gender).stringValue
    }
    
    static var dob : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Dob).stringValue
    }
    
    public static var userId : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_UserId).stringValue
    }
    
    static var bio : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Bio).stringValue
    }
    
    static var country : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Country).stringValue
    }
    
    static var countryCode : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_CountryCode).stringValue
    }
    
    static var userImage : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.User_Image).stringValue
    }
    
    
    static var notificationSettings : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.Notification_Settings).stringValue
    }
    
    
    static var profiletype : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.Profile_Type).stringValue
    }
    
    static var identityProofBack : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofBack).stringValue
    }
    
    
    static var identityProofBackStatus : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofBackStatus).stringValue
    }
    
    static var identityProofFront : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofFront).stringValue
    }
    
    static var identityProofFrontStatus : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofFrontStatus).stringValue
    }
    
    static var identityProofSelfie : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofSelfie).stringValue
    }
    
    static var identityProofSelfieStatus : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.IdentityProofSelfieStatus).stringValue
    }
    
    static var docUpload : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.DocUpload).stringValue
    }
    
    
    static var emogieVersion : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.EmogiesVersion).stringValue
    }
    
    static var tokenCount : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.TokenCount).stringValue
        
        //return UserDefaults.standard.integer(forKey: AppUserDefaults.Key.TokenCount.rawValue)
        
    }

    static var accessToken : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.accessToken).stringValue
    }
    
    static var encryptionUrl : String?{
        return AppUserDefaults.value(forKey: AppUserDefaults.Key.AcEncUrl).stringValue
    }
    
    init(info : [String:AnyObject])
    {
        print(info)
        
        
        if let id = info["_id"] as? String{
            AppUserDefaults.save(value: id, forKey: AppUserDefaults.Key.User_UserId)
       
        }else if let id = info["_id"] as? Int{
            
            AppUserDefaults.save(value: String(id) , forKey: AppUserDefaults.Key.User_UserId)
        }else{
             AppUserDefaults.save(value: "" , forKey: AppUserDefaults.Key.User_UserId)
        }
            
        
        AppUserDefaults.save(value: info["username"] as? String ?? "", forKey:AppUserDefaults.Key.User_UserName)
        
        AppUserDefaults.save(value: info["name"] as? String ?? "", forKey:AppUserDefaults.Key.User_Name)
        
        AppUserDefaults.save(value: info["image"] as? String ?? "", forKey:AppUserDefaults.Key.User_Image)
        
        AppUserDefaults.save(value: info["gender"] as? String ?? "", forKey:AppUserDefaults.Key.User_Gender)
        
        AppUserDefaults.save(value: info["email"] as? String ?? "", forKey:AppUserDefaults.Key.User_Email)
        
        AppUserDefaults.save(value: info["dob"] as? String ?? "", forKey:AppUserDefaults.Key.User_Dob)
        
        AppUserDefaults.save(value: info["countryCode"] as? String ?? "", forKey:AppUserDefaults.Key.User_CountryCode)
        
        AppUserDefaults.save(value: info["country"] as? String ?? "", forKey:AppUserDefaults.Key.User_Country)
        
        AppUserDefaults.save(value: info["bio"] as? String ?? "", forKey:AppUserDefaults.Key.User_Bio)
        
       
        
        AppUserDefaults.save(value: info["profileType"] as? String ?? "", forKey:AppUserDefaults.Key.Profile_Type)
        
         AppUserDefaults.save(value: info["identityProofBack"] as? String ?? "", forKey:AppUserDefaults.Key.IdentityProofBack)
        
         AppUserDefaults.save(value: info["accessKey"] as? String ?? "", forKey:AppUserDefaults.Key.accessToken)
        
        if let val = info["tokens"] as? Int{
            
            printDebug(object: "token---\(val)")
            
            AppUserDefaults.save(value: "\(val)", forKey:AppUserDefaults.Key.TokenCount)
        }
        
        
        AppUserDefaults.save(value: info["identityProofBack"] as? String ?? "", forKey:AppUserDefaults.Key.IdentityProofBack)
        
        
        if let val = info["notificationSetting"] as? Int{

            printDebug(object: "notificationSetting...\(val)")
            
         AppUserDefaults.save(value: "\(val)", forKey:AppUserDefaults.Key.Notification_Settings)
        
        }
        
        if let val = info["identityProofBackStatus"] as? Int{
          AppUserDefaults.save(value: "\(val)", forKey:AppUserDefaults.Key.IdentityProofBackStatus)
        }
        
        AppUserDefaults.save(value: info["identityProofFront"] as? String ?? "", forKey:AppUserDefaults.Key.IdentityProofFront)
       
           if let val = info["identityProofFrontStatus"] as? Int{
            
        AppUserDefaults.save(value: "\(val)", forKey:AppUserDefaults.Key.IdentityProofFrontStatus)
        }
            
        AppUserDefaults.save(value: info["identityProofSelfie"] as? String ?? "", forKey:AppUserDefaults.Key.IdentityProofSelfie)
       
        AppUserDefaults.save(value: info["acEncUrl"] as? String ?? "", forKey:AppUserDefaults.Key.AcEncUrl)

        
        if let val = info["identityProofSelfieStatus"] as? Int{
            
            AppUserDefaults.save(value: "\(val)"  , forKey:AppUserDefaults.Key.IdentityProofSelfieStatus)
        }
  
        if let val = info["taxDocumentStatus"] as? Int{
            
            AppUserDefaults.save(value: "\(val)"  , forKey:AppUserDefaults.Key.TaxDocumentStatus)
        }
        
         AppUserDefaults.save(value: info["taxDocument"] as? String ?? "",forKey:AppUserDefaults.Key.TaxDocument)
        
        if let val = info["docUpload"] as? Int{
            
            printDebug(object: val)
            
            AppUserDefaults.save(value : "\(val)" , forKey:AppUserDefaults.Key.DocUpload)
          
            printDebug(object: "++++++")

            printDebug(object:CurentUser.docUpload)
           

        }
        
    }

}
