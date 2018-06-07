//
//  AppDelegate.swift
//  WhozoutLive
//
//  Created by apple on 04/01/17.
//  Copyright © 2017 App. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import UserNotifications
import SwiftyDropbox
import Starscream
import AFNetworking
import Fabric
import Crashlytics


protocol NotificationBellDelegate : class {
    
    func showCount()
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
     var parentNavigationController = UINavigationController()
    var locationManager = LocationManager.sharedInstance
    var tabBar : VKCTabBarControllar?
    var locMgr = CLLocationManager()
    var latitude:CLLocationDegrees{
        if let location = self.locMgr.location{
            return location.coordinate.latitude
        }
        return 0
    }
    
    var longitude:CLLocationDegrees{
        if let location = self.locMgr.location{
            return location.coordinate.longitude
        }
        return 0
    }
    var deviceToken : String!
    var showTutorial = true
    
    var agePopUpShown = false
    var syncingPopUpShown = false
    
    var time  : Timer?
    var isUsResident : Bool = true
    var fromLogout = false
    weak var notificationDelegate : NotificationBellDelegate?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        Fabric.with([Crashlytics.self])
      DropboxClientsManager.setupWithAppKey("ixn9pi4r46sif3g")

        sharedAppdelegate.startLocationManager()
        
        self.registerRemoteNotification()
        
        IQKeyboardManager.shared().isEnabled = true

        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        
        UIApplication.shared.isStatusBarHidden = false
       
        SocketHelper.sharedInstance.socket.delegate = self

        SocketHelper.sharedInstance.socket.pongDelegate = self
        
        CommonWebService.sharedInstance.videoAnimationCount = 0
        
      //  SocketHelper.sharedInstance.connectSocket()
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        //GMSServices.provideAPIKey("AIzaSyC35EjqaIlqHWYvAYoWuXAw53PzlhM046E")
        
    GMSServices.provideAPIKey("AIzaSyCABxsjw8NNxqly2WIW5T86GYKQlODjMKc")
        
       
        
           let token =  AppUserDefaults.value(forKey: AppUserDefaults.Key.DevideToken)
        
         NSLog("//////token is >>>\(token)")
        
        self.setRootVC()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(AppDelegate.logOutOnSocketError4001), name: NSNotification.Name(rawValue: "callDueToAuthenticationFail"), object: nil)
        
        
        return true
    }

    func applicationWillResignActive(_ application:
        UIApplication) {
        
        printDebug(object: "resign")
        
//        if !SocketHelper.sharedInstance.socket.isConnected{
//            SocketHelper.sharedInstance.connectSocket()
//            
//        }
        
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        printDebug(object: "background")
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
//        if !SocketHelper.sharedInstance.socket.isConnected{
//            SocketHelper.sharedInstance.connectSocket()
//
//        }
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0

        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//        if !SocketHelper.sharedInstance.socket.isConnected{
//            SocketHelper.sharedInstance.connectSocket()
//            
//        }
    }

    func applicationWillTerminate(_ application: UIApplication) {
        NSLog("will terminate \(String(describing: CurentUser.userId))")
        if CurentUser.userId == ""{
            NSLog("save after \(String(describing: CurentUser.userId))")
            AppUserDefaults.save(value: "", forKey: AppUserDefaults.Key.User_UserId)
            
        }
        SocketHelper.sharedInstance.socket.disconnect()
        
        NSLog("after will terminate \(String(describing: CurentUser.userId))")
        
        URLCache.shared.removeAllCachedResponses()
        
        self.setRootVC()
               self.saveContext()
    }

    // MARK: - Core Data stack

    @available(iOS 10.0, *)
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "WhozoutLive")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()


    
    // MARK: - Core Data Saving support

    func saveContext () {
        
      
        if #available(iOS 10.0, *) {
            _ = persistentContainer.viewContext
        } else {
            // Fallback on earlier versions
        }
//        if connect.hasChanges {
//            do {
//                try connect.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nserror = error as NSError
//                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
//            }
//        }
    }

    func startLocationManager(){
        self.locMgr.requestWhenInUseAuthorization()
        self.locMgr.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.startUpdatingLocation()
    }
    
    func setRootVC(){
        NSLog("user Id is \(String(describing: CurentUser.userId))")
        if let id = CurentUser.userId , id == ""{
            CommonFunction.setTutorialToRoot()
        }else if let id = CurentUser.userId , id == "1"{
            CommonFunction.setLoginToRoot()
                   }else{
            CommonFunction.pushToHome()
        }
        

//     
//        if let id = CurentUser.userId , id != ""{
//            CommonFunction.pushToHome()
//        }else{
//               CommonFunction.setTutorialToRoot()
//        }
        
    }
    
    
    func registerRemoteNotification(){

        if #available(iOS 8.0, *) {
            let settings = UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)

            UIApplication.shared.registerUserNotificationSettings(settings)
            UIApplication.shared.registerForRemoteNotifications();
        }
        else
        {
            let notificationTypes: UIRemoteNotificationType = [UIRemoteNotificationType.newsstandContentAvailability, UIRemoteNotificationType.alert, UIRemoteNotificationType.sound];
            UIApplication.shared.registerForRemoteNotifications (matching: notificationTypes);
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        var token = ""
        for i in 0..<deviceToken.count {
            token = token + String(format: "%02.2hhx", arguments: [deviceToken[i]])
        }
        NSLog("devicetoken------------------>>>>>>>>>>>>>")
        NSLog(token)
        
        AppUserDefaults.save(value: token, forKey: AppUserDefaults.Key.DevideToken)
        
       // NSLog(deviceTokenString.description)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        printDebug(object: userInfo)
           NSLog("------------------------------>>>rel_id...\(userInfo)")
        
        if UIApplication.shared.applicationState != .active{
            
            //NSLog(userInfo)
            
            if let type = userInfo["notificationType"] as? String{
                NSLog("not type Strig === \(type)")
                
            }
            
            
            if let type = userInfo["notificationType"] as? Int{
                
                NSLog("not type Int === \(type)")
                
            }
            
            if let type = userInfo["notificationType"] as? String{
                printDebug(object: type)
                
                CommonWebService.sharedInstance.videoVC = nil
                
                self.handlePush(type: type, userInfo: userInfo)
                
                if let count = userInfo["pushCount"] as? String {
                    
                    CommonWebService.sharedInstance.pushCount = Int(count)!

                    
                   // pushCount = Int(count)!
                }
                
            }else{
                
            }
        }else{
            
            
            if let count = userInfo["pushCount"] as? Int {
                
                NSLog("push count is Int======\(count)")
                
                if count > 9{
                 CommonWebService.sharedInstance.pushCount = 9
                }else{
                    CommonWebService.sharedInstance.pushCount = count
                }
                
               
                
                
                self.notificationDelegate?.showCount()
                  CommonFunction.playSound(name: "bell",type: "mp3")
                
            }
            
        }
    }
    
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        printDebug(object: userInfo)
         NSLog("------------------------------>>>rel_id...\(userInfo)")
        if UIApplication.shared.applicationState != .active{
        
            if let type = userInfo["notificationType"] as? String{

        NSLog("not type Strig === \(type)")
        
        }
            
            
            if let type = userInfo["notificationType"] as? Int{
                
                NSLog("not type Int === \(type)")
            
                
            }
            
            
        if let type = userInfo["notificationType"] as? String{
             printDebug(object: type)
            
            CommonWebService.sharedInstance.videoVC = nil

            self.handlePush(type: type, userInfo: userInfo)
            
          
         
            
          //  CommonWebService.sharedInstance.pushCount = userInfo["pushCount"] as! Int
            
            if let count = userInfo["pushCount"] as? String {
                pushCount = Int(count)!
            }
            
        }else{
            
        }
        }else{
        
         
            if let count = userInfo["pushCount"] as? Int {
                
                NSLog("push count is Int======\(count)")
                
                if count > 9{
                    CommonWebService.sharedInstance.pushCount = 9
                }else{
                    CommonWebService.sharedInstance.pushCount = count
                }
             
                self.notificationDelegate?.showCount()
                CommonFunction.playSound(name: "bell",type: "mp3")
                
            }
        
        }
    }
    
    
    
    
    func handlePush(type:String,userInfo:[AnyHashable : Any]){
        
        guard let relationId = userInfo["relationId"] as? String else{
            return
        }
        
          NSLog("------------------------------>>>rel_id...\(userInfo)")
        
        printDebug(object: relationId)
        NSLog("------------------------------>>>rel_id...\(type)")
        
        NSLog(relationId)
        
        if type == "1"{
            
          CommonWebService.sharedInstance.getUrl(feedId: relationId, vcObj: (self.tabBar)!,description: "hhg hgh hgh")
                
        }else if type == "2"{
         
            self.pushToProfile(userId: relationId)
            
        
        }else if type == "3" || type == "4" || type == "5"{
            
            self.pushToImageVC(imageId: relationId)
            
        }else if type == "7"{
        
            VKCTabBarControllar.sharedInstance.setCurrentTab(index: 4)
            VKCTabBarControllar.sharedInstance.selectTab(button: VKCTabBarControllar.sharedInstance.button5!)
            
        }else if type == "9"{

                self.pushToNotification(message: userInfo["message"] as? String ?? "")
    
    }  else{
            
            
        }
        
    }
    
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        printDebug(object: url)
        
        let ur = url.absoluteString
        
        printDebug(object: "ur....\(ur)")
        
        printDebug(object: "URLComponents....\(String(describing: URLComponents(string: ur)))")
        
        let queryItems = URLComponents(string: ur)?.queryItems
        
        printDebug(object: "queryItems...\(String(describing: queryItems))")

        let qit = NSURLComponents(string: ur)?.queryItems
        
        
        printDebug(object: "NSURLComponents....\(String(describing: qit))")
    
        if let param1 = queryItems?.filter({$0.name == "feedId"}).first{
             print(param1.value ?? "......")
            if let feedId = param1.value{
                
                CommonWebService.sharedInstance.getUrl(feedId: feedId, vcObj: (self.tabBar)!,description: "hhg hgh hgh")
                
            }
            
        }else if let param1 = queryItems?.filter({$0.name == "WhozOutLive_imageId"}).first{
            
            printDebug(object: "param1 is \(param1)")
            printDebug(object: "param1 value is \(String(describing: param1.value))")

            
            if let id = param1.value{
                printDebug(object: "id is \(id)")
                if id == CurentUser.userId{
                    VKCTabBarControllar.sharedInstance.setCurrentTab(index: 4)
                    VKCTabBarControllar.sharedInstance.selectTab(button: VKCTabBarControllar.sharedInstance.button5!)
                }else{
                    self.pushToProfile(userId: id)
                }
            }
           
        }else if let authResult = DropboxClientsManager.handleRedirectURL(url) {
            switch authResult {
            case .success:
                print("Success! User is logged into Dropbox.")
                isConnectedtoDropBox = true
            case .cancel:
                print("Authorization flow was manually canceled by user!")
            case .error(_, let description):
                print("Error: \(description)")
            }
        }
        return true
    }
    
    
    func pushToProfile(userId : String){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "OtherProfileID") as? OtherProfileVC
        vc?.userId = userId
        sharedAppdelegate.parentNavigationController.pushViewController(vc!, animated: true)
    }
    
    
    func pushToNotification(message:String){
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "NotificationID") as? NotificationVC
        CommonWebService.sharedInstance.pushCount = 0
        vc?.message = message
        sharedAppdelegate.parentNavigationController.pushViewController(vc!, animated: true)
    }

    
    func pushToImageVC(imageId : String){

        for vc in sharedAppdelegate.parentNavigationController.viewControllers{
            
            if vc.isKind(of : ImagecommentVC.self){
                
                let ind = sharedAppdelegate.parentNavigationController.viewControllers.indexOfObject(object: vc)
                sharedAppdelegate.parentNavigationController.viewControllers.remove(at: ind)
            }
        }
        
        let vc = StoryBoard.Streaming.instance.instantiateViewController(withIdentifier: "ImagecommentID") as? ImagecommentVC
        vc?.ImgId = imageId
        sharedAppdelegate.parentNavigationController.pushViewController(vc!, animated: true)
    }
    
    
    func logOutOnSocketError4001(notification:Notification){
        
//        notification.
//        
        printDebug(object: "logOutOnSocketError4001 called")
//
        printDebug(object: "  notification.userInfo...\(String(describing:   notification.userInfo))")
        
    
        
        CommonWebService.sharedInstance.logoutService { (success) in
            
            if success{
                
            }else{
                
            }
        }
        
        
    }
    
    
    
//    func getInternetCallBack(){
//        
//        
//        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//        
//        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//            
//            switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:
//            // NSLog(@"No Internet Connection");
//            reachable = NO;
//            _sendButton.enabled=NO;
//            break;
//            case AFNetworkReachabilityStatusReachableViaWiFi:
//            //NSLog(@"WIFI");
//            
//            reachable = YES;
//            _sendButton.enabled=YES;
//            
//            // [self checkForTwomsg];
//            
//            break;
//            case AFNetworkReachabilityStatusReachableViaWWAN:
//            //NSLog(@"3G");
//            reachable = YES;
//            _sendButton.enabled=YES;
//            //[self checkForTwomsg];
//            break;
//            default:
//            //NSLog(@"Unkown network status");
//            reachable = NO;
//            _sendButton.enabled=NO;
//            break;
//            
//            [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//            }
//            }];
//        
//        
//        
//    }
    
    
}


extension AppDelegate : WebSocketDelegate,WebSocketPongDelegate{

  
    
    public func websocketDidConnect(_ socket: Starscream.WebSocket) {
        
     
        
        if !socket.isConnected{
            SocketHelper.sharedInstance.connectSocket()
        }
        printDebug(object: "socket connected")
        
    }
    
    public func websocketDidDisconnect(_ socket: Starscream.WebSocket, error: NSError?) {
        
        printDebug(object: "socket is...\(socket)")
        
        print("error on Appdelegate...\(String(describing: error?.localizedDescription))")
        
        SocketHelper.sharedInstance.connectSocket()
            printDebug(object: ".....socket disconnected")

    }
    
    
    func websocketDidReceivePong(_ socket: WebSocket) {
        
        printDebug(object: "pong delegate called")
        
    }
    
    public func websocketDidReceiveMessage(_ socket: WebSocket, text: String) {
        
        printDebug(object: "Appdelegate socket received \(text)")
        
    }
    
    public func websocketDidReceiveData(_ socket: Starscream.WebSocket, data: Data) {
        
    }
}

