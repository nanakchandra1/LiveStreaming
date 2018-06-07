//
//  TokenAmount.swift
//  WhozoutLive
//
//  Created by apple on 23/01/17.
//  Copyright © 2017 App. All rights reserved.
//

import UIKit

class TokenAmount {

    private var tokenData : jsonDictionary
    
    init(tokenData:[String:AnyObject]){
        
        self.tokenData = tokenData
        
    }
    
    var amountID: String?{
        get{
            if let id = self.tokenData["_id"]{
                return "\(id)"
            }
            return nil
        }
        set{
            self.tokenData["_id"] = newValue as AnyObject?
        }
    }
    
    var amountValue: String?{
        get{
            if let value = self.tokenData["val"]{
                return "\(value)"
            }
            return nil
        }
        set{
            self.tokenData["val"] = newValue as AnyObject?
        }
    }

    
}
