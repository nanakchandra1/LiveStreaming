//
//  TokenPurchasedData.swift
//  WhozoutLive
//
//  Created by apple on 20/03/17.
//  Copyright © 2017 App. All rights reserved.
//

import UIKit

class TokenPurchasedData: NSObject {

    private var tokenPurchased : jsonDictionary
    
    init(purchasedToken : jsonDictionary){
        self.tokenPurchased = purchasedToken
    }
    
    
    var tokenId : String? {
        get{
            if let id = self.tokenPurchased["_id"]{
                return "\(id)"
            }
            return ""
        }
        
        set{
            self.tokenPurchased["_id"] = newValue as AnyObject?
        }
    }

    var timestamp : String? {
        get{
            if let timestamp = self.tokenPurchased["timestamp"]{
                return "\(timestamp)"
            }
            return ""
        }
        
        set{
            self.tokenPurchased["timestamp"] = newValue as AnyObject?
        }
    }
    

    var tokens : String? {
        get{
            if let tokens = self.tokenPurchased["tokens"]{
                return "\(tokens)"
            }
            return ""
        }
        
        set{
            self.tokenPurchased["tokens"] = newValue as AnyObject?
        }
    }
    

    
}
