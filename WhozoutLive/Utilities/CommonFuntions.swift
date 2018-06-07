

import Foundation
import UIKit
import MBProgressHUD
import AVFoundation
import CoreLocation
import Photos
import AVFoundation
//import MGFashionMenuView




var player: AVAudioPlayer?

class CommonFunction {
    

    class func getPlaceHolderColor(text:String) -> NSAttributedString{
        return NSAttributedString(string: text ,
                                  attributes:[NSForegroundColorAttributeName: AppColors.placeHolderColor])
        
        //  return attString
    }
    
    
    class func setPlaceHolderWithColor(text:String,color:UIColor) -> NSAttributedString{
        return NSAttributedString(string: text ,
                                  attributes:[NSForegroundColorAttributeName: color])
    }
    
    
    
    class func attributeStringColor(main_string : String , string_to_color : String , color : UIColor) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string:main_string)
        
        let range1 = (main_string as NSString).range(of: main_string)
        // attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 14), range: range1)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: AppColors.placeHolderColor , range: range1)
        //if main_string.contains("(should be 18 years or above from curent date)"){
        let range2 = (main_string as NSString).range(of: "(should be 18 years or above from curent date)")
        attributedString.addAttribute(NSFontAttributeName, value: UIFont.systemFont(ofSize: 10) , range: range2)
        // }
        
        let range = (main_string as NSString).range(of: string_to_color)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: color , range: range)
        
        return attributedString
    }
    
    
    class func attributedHashTagString(main_string : String, attributedColor : UIColor,mainStringColor : UIColor,withFont : UIFont) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string:main_string)
        
        let range1 = (main_string as NSString).range(of: main_string)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: mainStringColor , range: range1)
        // AppFonts.lotoMedium.withSize(14)
        attributedString.addAttribute(NSFontAttributeName, value: withFont,range: range1)
        
        let arr = main_string.components(separatedBy: " ")
        printDebug(object: arr)
        for item in arr{
            
            if item.contains("#") && item.characters.first == "#" && item.characters.count > 0 && item.characters.last != "#"{
                let range = (main_string as NSString).range(of: item)
                attributedString.addAttribute(NSForegroundColorAttributeName, value: attributedColor , range: range)
                attributedString.addAttribute(NSFontAttributeName, value: AppFonts.lotoMedium.withSize(14),range: range)
            }
        }
        
        return attributedString
    }
    
    
    
    class func notificationAttributedString(main_string : String,stringToColor:String, attributedColor : UIColor,mainStringColor : UIColor,withFont : UIFont) -> NSAttributedString{
        
        let attributedString = NSMutableAttributedString(string:main_string)
        
        let range1 = (main_string as NSString).range(of: main_string)
        
        attributedString.addAttribute(NSForegroundColorAttributeName, value: mainStringColor , range: range1)
        // AppFonts.lotoMedium.withSize(14)
        attributedString.addAttribute(NSFontAttributeName, value: withFont,range: range1)
        
        let range = (main_string as NSString).range(of: stringToColor)
        attributedString.addAttribute(NSForegroundColorAttributeName, value: attributedColor , range: range)
        attributedString.addAttribute(NSFontAttributeName, value: AppFonts.lotoMedium.withSize(14),range: range)
        
        
        
        return attributedString
    }
    
    
    
    class func getCommaSeperatedFromArray(array:[String])-> String?{
        return array.joined(separator: ",")
    }
    
    
    
    
    class func rgbColor(red:CGFloat,green:CGFloat,blue:CGFloat,alpha:CGFloat)->UIColor{
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
    }
    
}

//MARk:- TSMessage
//====================
extension CommonFunction{
    class func showTsMessageError(message:String){
        TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.error)
    }
    
    
    class func showTsMessageErrorInViewControler(message:String,vc:UIViewController){
        TSMessage.showNotification(in: vc, title: "", subtitle: message, type: TSMessageNotificationType.error)
        
        //  var menuView = MGFashionMenuView()
        
        
    }
    
    class func showTsMessageSuccess(message:String){
        
        
        TSMessage.showNotification(withTitle: message, type: TSMessageNotificationType.success)
        
    }
    
    
    
    
}

//MARK:- validations
//====================
extension CommonFunction{
    class func isValidName(value: String) -> Bool {
        
        let charcter  = NSCharacterSet(charactersIn: " abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ").inverted
        var filtered:String!
        let inputString : [String] = value.components(separatedBy: charcter)
        
        filtered = inputString.joined(separator: "") as String!
        
        if (value == filtered){
            
            return true
            
        }
        return false
    }
    
    class func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.[A-Za-z]{2,64}"
        let range = testStr.range(of: emailRegEx, options: String.CompareOptions.regularExpression)
        
        let result = range != nil ? true : false
        return result
    }
    
    
    
}

//MARK:- Loader
//================
extension CommonFunction {
    
    class func showLoader(vc:UIViewController){
        
        MBProgressHUD.showAdded(to: vc.view, animated: true)
        
    
        
    }
    
    class func hideLoader(vc:UIViewController){
        
        MBProgressHUD.hide(for: vc.view, animated: true)    }
}


extension CommonFunction{
    
    class func getMainQueue(closure:@escaping ()->()){
        
        DispatchQueue.main.async {
            closure()
        }
        
    }
    
    class func delay(delay:Double, closure:@escaping ()-> Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
    
    class func delayy(delay:Double, closure:@escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            closure()
        }
    }
}


//MARK:- Set root vc
extension CommonFunction{
    
    class func setLoginToRoot(){
        let loginvc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "LoginID") as! LoginVC
        sharedAppdelegate.parentNavigationController = UINavigationController(rootViewController: loginvc)
        sharedAppdelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppdelegate.window?.rootViewController = sharedAppdelegate.parentNavigationController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }
    
    class func setTabBarToRoot(){
        let loginvc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "StreamingID") as! StreamingVC
        sharedAppdelegate.parentNavigationController = UINavigationController(rootViewController: loginvc)
        sharedAppdelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppdelegate.window?.rootViewController = sharedAppdelegate.parentNavigationController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }
    
    class func setTutorialToRoot(){
        
        let loginvc = StoryBoard.Main.instance.instantiateViewController(withIdentifier: "TutorialID") as! TutorialVC
        sharedAppdelegate.parentNavigationController = UINavigationController(rootViewController: loginvc)
        sharedAppdelegate.parentNavigationController.isNavigationBarHidden = true
        sharedAppdelegate.window?.rootViewController = sharedAppdelegate.parentNavigationController
        sharedAppdelegate.window?.makeKeyAndVisible()
    }
    
    
    class func pushToHome() {
        let tabBar = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "VKCTabBarControllarID") as? VKCTabBarControllar
        sharedAppdelegate.tabBar = tabBar
        tabBar?.initTabbar()
        
        let feedNavigation = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "FeedsNavigation") as! UINavigationController
        
        let connectionNavigation = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ConnectionsNavigation") as! UINavigationController
        
        let unKnownNavigation = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "UnKnownNavigation") as! UINavigationController
        
        let settingNavigation = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "SettingsNavigation") as! UINavigationController
        
        let profileNavigation = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ProfileNavigation") as! UINavigationController
        
        tabBar?.viewControllers = [feedNavigation, connectionNavigation,unKnownNavigation, settingNavigation, profileNavigation]
        
        sharedAppdelegate.parentNavigationController = UINavigationController(rootViewController: tabBar!)
        
        sharedAppdelegate.parentNavigationController.navigationBar.isHidden = true
        sharedAppdelegate.window?.rootViewController = sharedAppdelegate.parentNavigationController
        
        // _ = self.navigationController?.pushViewController(tabBar!, animated: animationFlag)
    }
}

//MARK:- Add remove child view
//===================================
extension CommonFunction{
    //MARK:- Add/Remove Child View Controller
    class func addChildVC(childVC:UIViewController, parentVC:UIViewController){
        parentVC.addChildViewController(childVC)
        childVC.view.frame = parentVC.view.bounds
        parentVC.view.addSubview(childVC.view)
        childVC.didMove(toParentViewController: parentVC)
    }
    
    class func removeChildVC(childVC:UIViewController){
        
        childVC.willMove(toParentViewController: nil)
        childVC.view.removeFromSuperview()
        childVC.removeFromParentViewController()
    }
}

extension CommonFunction{
    class func getTextHeight(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: CGFloat.greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.height
    }
    
    class func getTextWidth(text:String, font:UIFont, height:CGFloat) -> CGFloat{
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: CGFloat.greatestFiniteMagnitude, height: height))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = font
        label.text = text
        label.sizeToFit()
        return label.frame.width
    }
    
    
    
    //MARK:- Get text size
    //======================
    class func getTextSize(text:String,font:UIFont) ->CGSize{
        let tempLabel = UILabel()
        tempLabel.text = text
        tempLabel.font = font
        tempLabel.textAlignment = .left
        let size = tempLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
        return size
    }
    
    
    
    class func removeBlankCharacters(text:String) -> String{
        let finalDesc = String(text.characters.filter { !"\n\t\r".characters.contains($0) })
        return finalDesc
    }
    
    
    class func setShadowForView(view:UIView,radius:CGFloat){
        view.layer.masksToBounds = false
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowRadius = radius
        view.layer.shadowOpacity = 0.1
    }
    
    //MARK:- Get age
    //==================
    class func getAgeFromTimeStamp(timeStampString:String) -> String{
        let timeStampValue = Double(timeStampString )! / 1000.0
        let date =  Date.init(timeIntervalSince1970:timeStampValue)
        return Date().offsetFrom(date: date)
    }
    
    
    class func shareWithSocialMedia(message:String,vcObj:UIViewController)
    {
        
        var sharingItems = [AnyObject]()
        let message =  message
        
        sharingItems.append(UIImage(named: "emogie")!)
        sharingItems.append(message as AnyObject)
    
        let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
    
        var activitiesToExclude : [String] = []
        if #available(iOS 9.0, *) {
            
        activitiesToExclude = [UIActivityType.airDrop.rawValue, UIActivityType.print.rawValue, UIActivityType.copyToPasteboard.rawValue, UIActivityType.assignToContact.rawValue, UIActivityType.saveToCameraRoll.rawValue, UIActivityType.addToReadingList.rawValue, UIActivityType.openInIBooks.rawValue]
            
        } else {
            activitiesToExclude = [UIActivityType.airDrop.rawValue, UIActivityType.print.rawValue, UIActivityType.copyToPasteboard.rawValue, UIActivityType.assignToContact.rawValue, UIActivityType.saveToCameraRoll.rawValue, UIActivityType.addToReadingList.rawValue]
        }
        
        
         //activityViewController.excludedActivityTypes = activitiesToExclude
        
        
        
        if IsIPhone {
            vcObj.present(activityViewController, animated: true, completion: nil)
        }
        else {
            //let popup: UIPopoverController = UIPopoverController(contentViewController: activityViewController)
            
            // popup.present(from: CGRect(self.view.frame.size.width / 2, self.view.frame.size.height / 2, 0, 0), in: self.view, permittedArrowDirections: UIPopoverArrowDirection.up, animated: true)
        }
    }
    
    
    
    class func shareOnInstaGram(image:UIImage,vcObj:UIViewController){
        var documentController: UIDocumentInteractionController!

        let imgData:Data = UIImageJPEGRepresentation(UIImage(named: "emogie")!,1)!
        
        let instagramURL = URL(string: "instagram://app")
        if (UIApplication.shared.canOpenURL(instagramURL!)) {
            
            let captionString = "caption"
            
            let writePath = (NSTemporaryDirectory() as NSString).appendingPathComponent("instagram.igo")
            
            
            do {
                
                try imgData.write(to: URL(fileURLWithPath: writePath), options: .atomic)
                
                
                let fileURL = URL(fileURLWithPath: writePath)
                
                documentController = UIDocumentInteractionController(url: fileURL)
                
                documentController.delegate = self as! UIDocumentInteractionControllerDelegate
                
                documentController.uti = "com.instagram.exclusivegram"
                
                documentController.annotation = NSDictionary(object: captionString, forKey: "InstagramCaption" as NSCopying)
                
                documentController.presentOpenInMenu(from: vcObj.view.frame, in: vcObj.view, animated: true)
                
                
            } catch {
                printDebug(object: "catch block")
            }
            
            
        } else {
            print(" Instagram is not installed ")
        }
        
    }
    

    
    class func rateApp(){
      //  let url  = NSURL(string: "https://itunes.apple.com/in/genre/ios/id36?mt=8")
        
       let url  = NSURL(string: "https://itunes.apple.com/us/app/whozoutlive/id1223949522?ls=1&mt=8")
        
        if UIApplication.shared.canOpenURL(url! as URL) == true  {
            
            UIApplication.shared.open(url! as URL, options: ["":""], completionHandler: nil)
        }
    }
    
    
    class func showAlertOnTop(){
        
        _ = VKCAlertController.alert(title: "Error", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", buttons: ["Cancel"], tapBlock: { (_, index) in
            
            
        })
        
    }
    
    
    
    class func checkAndOpenLibrary(picker : UIImagePickerController ,forTypes: [String],vcObj : UIViewController) {
        
        //let picker : UIImagePickerController = piker
        
        //picker.delegate = self
        
        picker.mediaTypes = forTypes
        
        let status: PHAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        if (status == .notDetermined) {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
            
            picker.sourceType = sourceType
            picker.allowsEditing = true

            vcObj.present(picker, animated: true, completion: nil)
            
        }
            
        else {
            if status == .restricted {
                
                _ = VKCAlertController.alert(title: "Error", message: "You've been restricted from using the library on this device. Without camera access this feature won't work.", buttons: ["Cancel"], tapBlock: { (_, index) in
                    
                    
                })
                
                
            }
            else {
                
                if status == .denied {
                    
                    _ = VKCAlertController.alert(title: "Error", message: "Please change your privacy setting from the setting app and allow access to library for WhozoutLive.", buttons: ["Settings","Cancel"], tapBlock: { (_, index) in
                        
                        if index == 0{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                                
                            })
                            
                        }
                        
                    })
                    
                    
                }
                    
                else {
                    
                    if status == .authorized {
                        
                        let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.photoLibrary
                        
                        picker.sourceType = sourceType
                        
                        picker.allowsEditing = true
                        
                        vcObj.present(picker, animated: true, completion: nil)
                        
                    }
                    
                }
                
            }
            
        }
        
    }
    
    
    class func checkAndOpenCamera(picker : UIImagePickerController ,forTypes: [String],vcObj : UIViewController) {
        
        
        //        picker.delegate = self
        
        let authStatus: AVAuthorizationStatus = AVCaptureDevice.authorizationStatus(forMediaType: AVMediaTypeVideo)
        
        if authStatus == AVAuthorizationStatus.authorized {
            
            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
            
            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                
                picker.sourceType = sourceType
                
                picker.mediaTypes = forTypes
                
                picker.allowsEditing = true
                
                if picker.sourceType == UIImagePickerControllerSourceType.camera {
                    
                    picker.showsCameraControls = true
                    
                }
                
                vcObj.present(picker, animated: true, completion: nil)
                
            }
                
            else {
                
                //                dispatch_get_main_queue().asynchronously(execute: {
                //
                //                    //PKCommonClass.showTSMessageForError("Sorry! Camera not supported on this device")
                //
                //                })
                
            }
        }
            
        else {
            
            if authStatus == AVAuthorizationStatus.notDetermined {
                
                AVCaptureDevice.requestAccess(forMediaType: AVMediaTypeVideo, completionHandler: {(granted: Bool) in
                    
                    
                    DispatchQueue.main.async(execute: {
                        
                        if granted {
                            
                            let sourceType: UIImagePickerControllerSourceType = UIImagePickerControllerSourceType.camera
                            
                            if UIImagePickerController.isSourceTypeAvailable(sourceType) {
                                
                                picker.sourceType = sourceType
                                
                                if picker.sourceType == UIImagePickerControllerSourceType.camera {
                                    
                                    picker.showsCameraControls = true
                                    
                                }
                                
                                vcObj.present(picker, animated: true, completion: nil)
                                
                            }
                                
                            else {
                                
                                
                                DispatchQueue.main.async(execute: {
                                    //PKCommonClass.showTSMessageForError("Sorry! Camera not supported on this device")
                                })
                                
                                
                            }
                            
                        }
                        
                    })
                    
                })
                
            }
                
            else {
                
                if authStatus == AVAuthorizationStatus.restricted {
                    
                    _ = VKCAlertController.alert(title: "Error", message: "You've been restricted from using the camera on this device. Without camera access this feature won't work.", buttons: ["Cancel"], tapBlock: { (_, index) in
                        
                    })
                    
                }
                    
                else {
                    
                    _ = VKCAlertController.alert(title: "Error", message: "Please change your privacy setting from the setting app and allow access to camera for WhozoutLive", buttons: ["Settings","Cancel"], tapBlock: { (_, index) in
                        
                        if index == 0{
                            UIApplication.shared.open( URL(string: UIApplicationOpenSettingsURLString)!, options: ["":""], completionHandler: { (success) in
                                
                            })
                        }
                    })
                }
                
            }
            
        }
        
    }
    
    
    class func selectType(vcObj : UIViewController, isPdfAllowed : Bool ,complition:@escaping (_ type:SlectedAction) -> ()) {
        let optionMenu = UIAlertController(title: nil, message: "Choose Option", preferredStyle: .actionSheet)
        
        optionMenu.view.tintColor = AppColors.pinkColor
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
        })
        
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            complition(SlectedAction.Camera)
            
        })
        
        let galeryAction = UIAlertAction(title: "Gallery", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            
            complition(SlectedAction.Galery)
            
            
        })
        
        
        let dropBoxAction = UIAlertAction(title: "DropBox", style: .default, handler: {
            
            (alert: UIAlertAction!) -> Void in
            
            
            complition(SlectedAction.Dropbox)
            
        })
        
        
        if isPdfAllowed{
            optionMenu.addAction(dropBoxAction)
        }else{
            optionMenu.addAction(cameraAction)
            optionMenu.addAction(galeryAction)
            
        }
        
        optionMenu.addAction(cancelAction)
        
        vcObj.present(optionMenu, animated: true, completion: nil)
        
    }
    
    class func downloadPdf(urlString:String,vcObj : UIViewController){
        CommonFunction.showLoader(vc: vcObj)
        let url = URL(string: urlString)
        
        var pdfData : Data?
        
        do {
            pdfData = try Data(contentsOf: url!)
            
        } catch {
            
        }
        
        let removeLastPathComponents = NSString(string: Bundle.main.resourcePath!).deletingLastPathComponent
        
        let resourceDocPath = URL(fileURLWithPath: removeLastPathComponents).appendingPathComponent("Documents").absoluteString
        let filePath = resourceDocPath.appending("myPDF.pdf")
        
        printDebug(object: filePath)
        
        
        do {
            try pdfData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
        } catch {
            
        }
        
        CommonFunction.showTsMessageSuccess(message: "Tax document downloaded successfully.")
        CommonFunction.hideLoader(vc: vcObj)
        //  let url1 = URL(string: filePath)
        
        
        
    }
    
    
    class func downloadImage(urlString:String,vcObj : UIViewController){
        let url = URL(string: urlString)
        
        var pdfData : Data?
        
        do {
            pdfData = try Data(contentsOf: url!)
            
        } catch {
            
        }
        
        let removeLastPathComponents = NSString(string: Bundle.main.resourcePath!).deletingLastPathComponent
        
        let resourceDocPath = URL(fileURLWithPath: removeLastPathComponents).appendingPathComponent("Documents").absoluteString
        let filePath = resourceDocPath.appending("myImage.jpeg")
        
        printDebug(object: filePath)
        
        
        do {
            try pdfData?.write(to: URL(fileURLWithPath: filePath), options: .atomic)
        } catch {
            
        }
        
        CommonFunction.showTsMessageSuccess(message: "Image downloaded successfully.")
        //  let url1 = URL(string: filePath)
        
    }
    
    
    class func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    
    class func saveImageDocumentDirectory(pathName : String,imageUrl:String){
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(pathName)
        _ = UIImage(named: pathName)
        
        let url = URL(string: imageUrl)
        var pdfData : Data?
        do{
            
            printDebug(object: "imageUrl is \(imageUrl)")
            if imageUrl != ""{
            pdfData = try Data(contentsOf: url!)
            }
            
        }catch {
            
        }
        
        print(paths)
        //  let imageData = UIImageJPEGRepresentation(image!, 0.5)
        fileManager.createFile(atPath: paths as String, contents: pdfData, attributes: nil)
    }
    
    class func getImage(pathName : String) -> UIImage?{
        let fileManager = FileManager.default
        
        let imagePAth = (CommonFunction.getDirectoryPath() as NSString).appendingPathComponent(pathName)
        if fileManager.fileExists(atPath: imagePAth){
            
            printDebug(object: "path name is ....\(pathName)")
            
            printDebug(object: "got path for image....\(imagePAth)")
            
            if let img = UIImage(contentsOfFile: imagePAth){
                printDebug(object: "image found with pathName \(pathName)")
                return img
            }else{
                printDebug(object: "image not found with pathName \(pathName)")

                return UIImage(named: "emogie")

            }
            
            
        }else{
            
            print("No Image")
        }
        return UIImage(named: "emogie")
    }
    
    
    class func isImageExistInDirectory(pathName : String) -> Bool{
        let fileManager = FileManager.default
        
        let imagePAth = (CommonFunction.getDirectoryPath() as NSString).appendingPathComponent(pathName)
    
        if fileManager.fileExists(atPath: imagePAth){

            printDebug(object: "image exist at \(imagePAth)")
            return true
            
        }else{
            printDebug(object: "image not exist")

            return false
            
        }
    }

    
    class func deleteDirectory(pathName : String){
        let fileManager = FileManager.default
        let imagePAth = (CommonFunction.getDirectoryPath() as NSString).appendingPathComponent(pathName)
        if fileManager.fileExists(atPath: imagePAth){            try! fileManager.removeItem(atPath: imagePAth)
        }else{
            print("Something wronge.")
        }
    }
    
    
    class func floatEmogie(ypos:CGFloat,duration:CGFloat,emogieImg : UIImage,isPlaySound:Bool,dimension:String,vcObj:UIViewController){
        autoreleasepool {
           
            CommonWebService.sharedInstance.videoAnimationCount =  CommonWebService.sharedInstance.videoAnimationCount! + 1

        var rect : CGRect?
        printDebug(object: "dimension is \(dimension)")
          if dimension == "very-small"{
             rect = CGRect(x:screenWidth - 100, y:ypos, width: 15, height: 15)
        }else if dimension == "small"{
            rect = CGRect(x:screenWidth - 100, y:ypos, width: 25, height: 25)
        }else  if dimension == "medium"{
              rect = CGRect(x:screenWidth - 100, y:ypos, width: 35, height: 35)
        }else  if dimension == "large"{
                rect = CGRect(x:screenWidth - 100, y:ypos, width: 45, height: 45)
          }else  if dimension == "extra-large"{
            rect = CGRect(x:screenWidth - 100, y:ypos, width: 55, height: 55)
          }else{
             rect = CGRect(x:screenWidth - 100, y:ypos, width: 15, height: 15)
        }
        
        let emogie = FaveButton(
            frame: rect! ,
            faveIconNormal: emogieImg)

        vcObj.view.addSubview(emogie)
        
        emogie.toggle(emogie)
        
        emogie.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        UIView.animate(withDuration: 0.1,delay: 0,usingSpringWithDamping: CGFloat(0.2),initialSpringVelocity: CGFloat(7.30),options:.allowUserInteraction,animations: {
            emogie.transform = .identity
            
        },completion: { finished in
            
            UIView.animate(withDuration: 0.1,delay: 0,usingSpringWithDamping: CGFloat(0.2),initialSpringVelocity: CGFloat(7.30),options: .allowUserInteraction,animations: {emogie.transform = .identity
                           
                CATransaction.begin()
                CATransaction.setCompletionBlock {
                    emogie.removeFromSuperview()
                    if CommonWebService.sharedInstance.videoAnimationCount! > 0{
                    CommonWebService.sharedInstance.videoAnimationCount =  CommonWebService.sharedInstance.videoAnimationCount! - 1
                    }
                if CommonWebService.sharedInstance.videoAnimationCount! <= 1{
                    CommonWebService.sharedInstance.scroll?.scrollLast()
                    }
                }
                
                let randomCurve = arc4random_uniform( UInt32(100) + (50))
                let zigzagPath = UIBezierPath()
                let oX: CGFloat = emogie.frame.origin.x
                let oY: CGFloat = ypos
                let eX: CGFloat = -30.0
                let eY = randomCurve % 2 == 0 ? oY - CGFloat(randomCurve)  : oY + CGFloat(randomCurve)
                let cp1 = CGPoint(x: CGFloat(oX) , y: CGFloat(oY) )
                let cp2 = CGPoint(x: CGFloat(eX), y: CGFloat(cp1.y))
                zigzagPath.move(to: CGPoint(x: emogie.center.x, y: emogie.center.y))
                zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
                zigzagPath.lineWidth = 1.0
                let pathAnimation = CAKeyframeAnimation(keyPath: "position")
                pathAnimation.duration = 4
                pathAnimation.path = zigzagPath.cgPath
                pathAnimation.fillMode = kCAFillModeForwards
                pathAnimation.isRemovedOnCompletion = false
                emogie.layer.add(pathAnimation, forKey: "movingAnimation")
                CATransaction.commit()

                },
                completion: { finished in

         
            })
        })
        
        }
    }
    
    
    class func floatEmogie(id:String,isPlaySound:Bool,animationStartPosition : Float,vcObj:UIViewController){
        
       // printDebug(object: "id is \(id)")
        
    
        let pathAndDimension = DataBaseControler.getImagePath(emogieId: id)
        
         let emogieImage = CommonFunction.getImage(pathName: pathAndDimension.0)
        
       let random = CommonFunction.getEmogieYpos(animationStartPosition: animationStartPosition)
    
        CommonFunction.floatEmogie(ypos: CGFloat(random), duration: 5, emogieImg: emogieImage ?? UIImage(named:"emogie")!,isPlaySound: isPlaySound,dimension:pathAndDimension.1,vcObj: vcObj)
        
    }
    
    
    class func getEmogieYpos(animationStartPosition: Float) -> UInt32{
        
        printDebug(object: "iphone is \(UIDevice.current.modelName)")
        printDebug(object: "animationStartPosition is \(animationStartPosition)")
        if UIDevice.current.modelName == "iPhone 6 Plus"{
            //6 plus
            
            
           return arc4random_uniform(UInt32(animationStartPosition - 433)) + UInt32(animationStartPosition - 200)
            
        }else{
            //5s
            return arc4random_uniform(UInt32(animationStartPosition - 300)) + UInt32(animationStartPosition - 150)
        }
        
    }
    
    class func getTimeStampFromDate(date:Date) -> Int{
        
        printDebug(object: "timeStamp created \(date.timeIntervalSince1970)")
        
        return Int(Double(date.timeIntervalSince1970))
        
        
    }
    
    class func playSound(name:String,type:String) {
        
        guard let path = Bundle.main.path(forResource: name, ofType: type) else{
            return
        }
        
        guard let url1 = URL(string: path) else{
            return
        }
        
        printDebug(object: "path is \(url1)")
        do {
            player = try AVAudioPlayer(contentsOf: url1)
            
            guard let player = player else { return }
            
            player.prepareToPlay()
            player.volume = 10.0
            player.play()
        } catch let error {
            
            print("errorrrrrr\(error.localizedDescription)")
        }
    }
    
    class func formatPoints(num: Double) ->String{
        let thousandNum = num/1000
        let millionNum = num/1000000
        if num >= 10000 && num < 1000000{
            if(floor(thousandNum) == thousandNum){
                return("\(Int(thousandNum))k")
            }
            
            return "\(Double(round(10*thousandNum)/10))k"
        }
        if num > 1000000{
            if(floor(millionNum) == millionNum){
                return("\(Int(thousandNum))k")
            }
            return "\(Double(round(10*millionNum)/10))M"
        }
        else{
            if(floor(num) == num){
                return ("\(Int(num))")
            }
            return ("\(num)")
        }
    }
    
    
    class func getNetworkType() -> String {
        
       if let statusBar = UIApplication.shared.value(forKey: "statusBar") , let foregroundView = (statusBar as AnyObject).value(forKey: "foregroundView"){

        let subviews = (foregroundView as AnyObject).subviews
            
            for subView in subviews! {
         
                if subView.isKind(of: NSClassFromString("UIStatusBarDataNetworkItemView")!){
                    
                    
                    if let value = subView.value(forKey: "dataNetworkType") {
                        
                        switch (value as AnyObject).integerValue {
                            
                        case 0:
                            
                            return "No wifi or cellular"
                            
                        case 1:
                            return "2G"
                            
                        case 2:
                            
                            return "3G"
                            
                        case 3:
                            
                            return "4G"
                            
                        case 4:
                            return "LTE"
                            
                        case 5:
                            return "Wifi"
                            
                        default:
                            
                            return " "
                        }
                    }
                }
            }
        }
        return " "
    }
    

    
    
}





//extension Double {
//    /// Rounds the double to decimal places value
//    mutating func roundToPlaces(places:Int) -> Double {
//        let divisor = pow(10.0, Double(places))
//        
//       // round(self * divisor / divisor)
//        
//        return round(self * divisor) / divisor
//    }
//}


