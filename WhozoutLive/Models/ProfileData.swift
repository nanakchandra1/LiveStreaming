

import UIKit


class ProfileData {

  
    private var profileData : jsonDictionary
    
    init(profileData:jsonDictionary){
        self.profileData = profileData
    }
    

    var name : String? {
        get{
            if let name = self.profileData["name"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.profileData["name"] = newValue as AnyObject?
        }
    }
    
    var bio : String? {
        get{
            if let bio = self.profileData["bio"]{
                return "\(bio)"
            }
            return ""
        }
        
        set{
            self.profileData["bio"] = newValue as AnyObject?
        }
    }
    
    var dob : String? {
        get{
            if let dob = self.profileData["dob"]{
                return "\(dob)"
            }
            return ""
        }
        
        set{
            self.profileData["dob"] = newValue as AnyObject?
        }
    }
    
    
    var email : String? {
        get{
            if let email = self.profileData["email"]{
                return "\(email)"
            }
            return ""
        }
        
        set{
            self.profileData["email"] = newValue as AnyObject?
        }
    }
    
    var gender : String? {
        get{
            if let gender = self.profileData["gender"]{
                return "\(gender)"
            }
            return ""
        }
        
        set{
            self.profileData["gender"] = newValue as AnyObject?
        }
    }
    
    
    var profileType : String? {
        get{
            if let profileType = self.profileData["profileType"]{
                return "\(profileType)"
            }
            return ""
        }
        
        set{
            self.profileData["profileType"] = newValue as AnyObject?
        }
    }

    
    var userImage : String? {
        get{
            if let userImage = self.profileData["userImage"]{
                return "\(userImage)"
            }
            return ""
        }
        
        set{
            self.profileData["userImage"] = newValue as AnyObject?
        }
    }
    
    var username : String? {
        get{
            if let username = self.profileData["username"]{
                return "\(username)"
            }
            return ""
        }
        
        set{
            self.profileData["username"] = newValue as AnyObject?
        }
    }

    var isfollowed : String? {
        get{
            if let isfollowed = self.profileData["isfollowed"]{
                return "\(isfollowed)"
            }
            return ""
        }
        
        set{
            self.profileData["isfollowed"] = newValue as AnyObject?
        }
    }
    
    var isProfilePicAvailable : String? {
        get{
            if let profileSetup = self.profileData["profileSetup"]{
                return "\(profileSetup)"
            }
            return ""
        }
        
        set{
            self.profileData["profileSetup"] = newValue as AnyObject?
        }
    }
    
    
    var docUpload : String? {
        get{
            if let docUpload = self.profileData["docUpload"]{
                return "\(docUpload)"
            }
            return ""
        }
        
        set{
            self.profileData["docUpload"] = newValue as AnyObject?
        }
    }

    
  
    
    var identityProofBack : String? {
        get{
            if let identityProofBack = self.profileData["identityProofBack"]{
                return "\(identityProofBack)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofBack"] = newValue as AnyObject?
        }
    }
    
    var identityProofBackStatus : String? {
        get{
            if let identityProofBackStatus = self.profileData["identityProofBackStatus"]{
                return "\(identityProofBackStatus)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofBackStatus"] = newValue as AnyObject?
        }
    }
    

    var identityProofFront : String? {
        get{
            if let identityProofFront = self.profileData["identityProofFront"]{
                return "\(identityProofFront)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofFront"] = newValue as AnyObject?
        }
    }
    

    var identityProofFrontStatus : String? {
        get{
            if let identityProofFrontStatus = self.profileData["identityProofFrontStatus"]{
                return "\(identityProofFrontStatus)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofFrontStatus"] = newValue as AnyObject?
        }
    }
    

    var identityProofSelfie : String? {
        get{
            if let identityProofSelfie = self.profileData["identityProofSelfie"]{
                return "\(identityProofSelfie)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofSelfie"] = newValue as AnyObject?
        }
    }
    

    var identityProofSelfieStatus : String? {
        get{
            if let identityProofSelfieStatus = self.profileData["identityProofSelfieStatus"]{
                return "\(identityProofSelfieStatus)"
            }
            return ""
        }
        
        set{
            self.profileData["identityProofSelfieStatus"] = newValue as AnyObject?
        }
    }
    

    var taxDocument : String? {
        get{
            if let taxDocument = self.profileData["taxDocument"]{
                return "\(taxDocument)"
            }
            return ""
        }
        
        set{
            self.profileData["taxDocument"] = newValue as AnyObject?
        }
    }
    

    var taxDocumentStatus : String? {
        get{
            if let taxDocumentStatus = self.profileData["taxDocumentStatus"]{
                return "\(taxDocumentStatus)"
            }
            return ""
        }
        
        set{
            self.profileData["taxDocumentStatus"] = newValue as AnyObject?
        }
    }
    

    var broadcastDocument : String? {
        get{
            if let broadcastDocument = self.profileData["broadcastDocument"]{
                return "\(broadcastDocument)"
            }
            return ""
        }
        
        set{
            self.profileData["broadcastDocument"] = newValue as AnyObject?
        }
    }
    

    var broadcastDocumentStatus : String? {
        get{
            if let broadcastDocumentStatus = self.profileData["broadcastDocumentStatus"]{
                return "\(broadcastDocumentStatus)"
            }
            return ""
        }
        
        set{
            self.profileData["broadcastDocumentStatus"] = newValue as AnyObject?
        }
    }

    var shareUrl : String? {
        get{
            if let shareUrl = self.profileData["shareUrl"]{
                return "\(shareUrl)"
            }
            return ""
        }
        
        set{
            self.profileData["shareUrl"] = newValue as AnyObject?
        }
    }

    
    var savedImages : [ImageData]? {
        get{
            if let savedImages = self.profileData["savedImages"] as? jsonDictionaryArray{
                
                var imgObjArr : [ImageData] = []
                
                for item in savedImages{
                    let imgObj = ImageData(imageData: item)
                    imgObjArr.append(imgObj)
                }
                
                return imgObjArr
            }
            return []
        }
        
        set{
            
            self.profileData["savedImages"] = newValue as AnyObject?
        }
    }
 
    
    var userImages : [ImageData]? {
        get{
            if let savedImages = self.profileData["userImages"] as? jsonDictionaryArray{
                
                var imgObjArr : [ImageData] = []
                
                for item in savedImages{
                    let imgObj = ImageData(imageData: item)
                    imgObjArr.append(imgObj)
                }
                
                return imgObjArr
            }
            return []
        }
        
        set{
            
            self.profileData["userImages"] = newValue as AnyObject?
        }
    }
    
    
    
}
