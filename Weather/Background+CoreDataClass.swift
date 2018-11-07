//
//  Background+CoreDataClass.swift
//  Weather
//
//  Created by Grant Maloney on 11/7/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit

@objc(Background)
public class Background: NSManagedObject {
    var modifiedDate: Date? {
        get {
            return date as Date?
        }
        set {
            date = newValue as NSDate?
        }
    }
    
    convenience init?(quality: Int, option: String?, image: UIImage) {
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let managedContext = appDelegate?.persistentContainer.viewContext else {
            return nil
        }
        
        self.init(entity: Background.entity(), insertInto: managedContext)
        self.option = option
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.backgroundImage = UIImagePNGRepresentation(image) as NSData?
        self.quality = Int64(quality)
    }
    
    func update(quality: Int, option: String, image: UIImage) {
        self.option = option
        self.backgroundImage = UIImagePNGRepresentation(image) as NSData?
        self.modifiedDate = Date(timeIntervalSinceNow: 0)
        self.quality = Int64(quality)
    }
}
