//
//  WLEmogies+CoreDataProperties.swift
//  WhozoutLive
//
//  Created by apple on 26/04/17.
//  Copyright © 2017 App. All rights reserved.
//

import Foundation
import CoreData


extension WLEmogies {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<WLEmogies> {
        return NSFetchRequest<WLEmogies>(entityName: "WLEmogies");
    }

    @NSManaged public var category: String?
    @NSManaged public var emogiId: String?
    @NSManaged public var price: String?
    @NSManaged public var smileyIds: String?
    @NSManaged public var url: String?
    @NSManaged public var version: String?
    @NSManaged public var dimension: String?
    @NSManaged public var smileyType: String?
    
}
