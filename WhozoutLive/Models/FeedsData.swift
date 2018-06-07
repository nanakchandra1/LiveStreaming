//
//  FeedsData.swift
//  WhozoutLive
//
//  Created by apple on 27/01/17.
//  Copyright © 2017 App. All rights reserved.
//

import UIKit

class FeedsData{

    private var feedData : jsonDictionary
    
    init(feed:jsonDictionary){
        self.feedData = feed
    }
    
    var broadcastPrice : String? {
        get{
            if let price = self.feedData["broadcastPrice"]{
                return "\(price)"
            }
            return ""
        }
        
        set{
             self.feedData["broadcastPrice"] = newValue as AnyObject?
        }
    }
    
    
    var broadcastType : String? {
        get{
            if let type = self.feedData["broadcastType"]{
                return "\(type)"
            }
            return ""
        }
        
        set{
            self.feedData["broadcastType"] = newValue as AnyObject?
        }
    }

    var commentCount : String? {
        get{
            if let count = self.feedData["commentCount"]{
                return "\(count)"
            }
            return ""
        }
        
        set{
            self.feedData["commentCount"] = newValue as AnyObject?
        }
    }
    var dateCreated : String? {
        get{
            if let date = self.feedData["dateCreated"]{
                return "\(date)"
            }
            return ""
        }
        
        set{
            self.feedData["dateCreated"] = newValue as AnyObject?
        }
    }
    
    var followers : String? {
        get{
            if let followers = self.feedData["followers"]{
                return "\(followers)"
            }
            return ""
        }
        
        set{
            self.feedData["followers"] = newValue as AnyObject?
        }
    }

    var likes : String? {
        get{
            if let likes = self.feedData["likes"]{
                return "\(likes)"
            }
            return ""
        }
        
        set{
            self.feedData["likes"] = newValue as AnyObject?
        }
    }

    var thumbnilUrl : String? {
        get{
            if let thumbnil = self.feedData["thumbnailUrl"]{
                return "\(thumbnil)"
            }
            return ""
        }
        
        set{
            self.feedData["thumbnailUrl"] = newValue as AnyObject?
        }
    }

    var userImage : String? {
        get{
            if let img = self.feedData["userImage"]{
                return "\(img)"
            }
            return ""
        }
        
        set{
            self.feedData["userImage"] = newValue as AnyObject?
        }
    }

    var userName : String? {
        get{
            if let name = self.feedData["userName"]{
                return "\(name)"
            }
            return ""
        }
        
        set{
            self.feedData["userName"] = newValue as AnyObject?
        }
    }

    var videoDiscription : String? {
        get{
            if let des = self.feedData["videoDiscription"]{
                return "\(des)"
            }
            return ""
        }
        
        set{
            self.feedData["videoDiscription"] = newValue as AnyObject?
        }
    }

    var views : String? {
        get{
            if let views = self.feedData["views"]{
                return "\(views)"
            }
            return ""
        }
        
        set{
            self.feedData["views"] = newValue as AnyObject?
        }
    }

    var country : String? {
        get{
            if let country = self.feedData["country"]{
                return "\(country)"
            }
            return ""
        }
        
        set{
            self.feedData["country"] = newValue as AnyObject?
        }
    }
    
    var feedId : String? {
        get{
            if let feedId = self.feedData["feedId"]{
                return "\(feedId)"
            }
            return ""
        }
        
        set{
            self.feedData["feedId"] = newValue as AnyObject?
        }
    }
    
    var isfollowed : String? {
        get{
            if let isfollowed = self.feedData["isfollowed"]{
                return "\(isfollowed)"
            }
            return ""
        }
        
        set{
            self.feedData["isfollowed"] = newValue as AnyObject?
        }
    }
    
    var broadcaorId : String? {
        get{
            if let broadcaorId = self.feedData["broadcaorId"]{
                return "\(broadcaorId)"
            }
            return ""
        }
        
        set{
            self.feedData["broadcaorId"] = newValue as AnyObject?
        }
    }
    
    var isliked : String? {
        get{
            if let isliked = self.feedData["isliked"]{
                return "\(isliked)"
            }
            return ""
        }
        
        set{
            self.feedData["isliked"] = newValue as AnyObject?
        }
    }
    
    
    
    var shareType : String? {
        get{
            if let shareType = self.feedData["shareType"]{
                return "\(shareType)"
            }
            return ""
        }
        
        set{
            self.feedData["shareType"] = newValue as AnyObject?
        }
    }
    
  
}
