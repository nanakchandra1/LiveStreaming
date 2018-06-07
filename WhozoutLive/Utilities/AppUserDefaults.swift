
import Foundation

enum AppUserDefaults {
    
    enum Key : String {
        case User_UserId
        case accessToken
        case User_Name
        case User_Age
        case User_UserName
        case User_Email
        case User_Bio
        case Profile_Type
        case Notification_Settings
        case User_Country
        case User_CountryCode
        case User_Dob
        case User_Image
        case User_Gender
        case DevideToken
        case IdentityProofBack
        case IdentityProofBackStatus
        case IdentityProofFront
        case IdentityProofFrontStatus
        case IdentityProofSelfie
        case IdentityProofSelfieStatus
        case TaxDocumentStatus
        case TaxDocument
        case DocUpload
        case EmogiesVersion
        case TokenCount
        case AcEncUrl
    }
}

extension AppUserDefaults {
    
    static func value(forKey key: Key, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
           // fatalError("No Value Found in UserDefaults\nFile : \(file) \nLine Number : \(line) \nFunction : \(function)")
            return JSON("")
        }
        
        return JSON(value)
    }
    
    static func value<T>(forKey key: Key, fallBackValue : T, file : String = #file, line : Int = #line, function : String = #function) -> JSON {
        
        guard let value = UserDefaults.standard.object(forKey: key.rawValue) else {
            
            print("No Value Found in UserDefaults\nFile : \(file) \nFunction : \(function)")
            return JSON(fallBackValue)
        }
        
        return JSON(value)
    }
    
    static func save(value : Any, forKey key : Key) {
        
        UserDefaults.standard.set(value, forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeValue(forKey key : Key) {
        
        UserDefaults.standard.removeObject(forKey: key.rawValue)
        UserDefaults.standard.synchronize()
    }
    
    static func removeAllValues() {
        
        let appDomain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: appDomain)
        UserDefaults.standard.synchronize()
       
    }
    
}
    
/* USAGE : 

AppUserDefaults.save(value: 32, forKey: .Age)
        
let age = AppUserDefaults.value(forKey: .Age).intValue
        
AppUserDefaults.save(value: "Chris", forKey: .Name)
let name = AppUserDefaults.value(forKey: .Age).stringValue

let name = AppUserDefaults.value(forKey: .Name, fallBackValue: "NO NAME")
*/
