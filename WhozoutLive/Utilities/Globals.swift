//
//  Globals.swift
//  WhozoutLive
//
//  Created by apple on 04/01/17.
//  Copyright © 2017 App. All rights reserved.
//

import Foundation
import UIKit

let screenWidth = UIScreen.main.bounds.size.width
let screenHeight = UIScreen.main.bounds.size.height
let screenSize = UIScreen.main.bounds.size

let sharedAppdelegate = (UIApplication.shared.delegate as! AppDelegate)

var isIPhoneSimulator:Bool{
    
    var isSimulator = false
    #if arch(i386) || arch(x86_64)
        //simulator
        isSimulator = true
    #endif
    return isSimulator
}

enum StoryBoard : String {
    case Main = "Main"
    case Streaming = "Streaming"
    case DocumentUpload = "DocumentUpload"
    case TokenManagement = "TokenManagement"

    var instance : UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
}


func printDebug <T> (object: T) {
    
    if isIPhoneSimulator{
         print(object)
    }
    else{
       // print(object)
        //NSLog("\(object)")
    }
}

