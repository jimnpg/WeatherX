//
//  Background+CoreDataProperties.swift
//  Weather
//
//  Created by Grant Maloney on 11/7/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData


extension Background {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Background> {
        return NSFetchRequest<Background>(entityName: "Background")
    }

    @NSManaged public var backgroundImage: NSData?
    @NSManaged public var date: NSDate?
    @NSManaged public var option: String?
    @NSManaged public var quality: Int64

}
