//
//  CityData.swift
//  Weather
//
//  Created by Grant Maloney on 9/24/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import ForecastIO

struct CityData: Codable {
    let country: String?
    let geonameid: Int?
    let name: String?
    let subcountry: String?
}

struct CityTableViewData {
    let city: String?
    let currentTemperature: String?
    let currentTime: String?
    let icon: Icon?
}

class GeoData {
    static var geoData: [CityData] = []
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let managedContext = appDelegate?.persistentContainer.viewContext
    
    static func loadGeoData() {
        if let path = Bundle.main.path(forResource: "cities", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                print(data)
                let jsonData = try? JSONDecoder().decode([CityData].self, from: data)
                if let parseData = jsonData {
                    geoData = parseData
                }
            } catch {
                print("Error parsing json")
            }
        }
    }
    
    static func fetchData(entityName: String) -> String {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            if let context = managedContext {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    return data.value(forKey: "name") as! String
                }
            }
        } catch {
            print("Failed to load notes")
        }
        
        return ""
    }
    
    static func fetchData(entityName: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        do {
            if let context = managedContext {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    return data.value(forKey: "hasInitialized") as! Bool
                }
            }
        } catch {
            print("Failed to load notes")
        }
        
        return false
    }
    
    static func fetchData(entityName: String) -> ([CityData], [NSManagedObject]) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        request.returnsObjectsAsFaults = false
        
        var myCoreCityData: [NSManagedObject] = []
        var myCities: [CityData] = []
        
        do {
            if let context = managedContext {
                let result = try context.fetch(request)
                for data in result as! [NSManagedObject] {
                    let name = data.value(forKey: "name") as! String
                    let country = data.value(forKey: "country") as! String
                    let subcountry = data.value(forKey: "subcountry") as! String
                    let geonameid = data.value(forKey: "geonameid") as! Int
                    myCoreCityData.append(data)
                    myCities.append(CityData(country: country, geonameid: geonameid, name: name, subcountry: subcountry))
                }
            }
            
        } catch {
            print("Failed")
        }
        
        return (myCities, myCoreCityData)
    }
    
    static func saveData(entityName: String, data: Any) {
        if let context = managedContext {
            let entity: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            
            if let givenCity = data as? CityData {
                entity.setValue(givenCity.name, forKey: "name")
                entity.setValue(givenCity.country, forKey: "country")
                entity.setValue(givenCity.subcountry, forKey: "subcountry")
                entity.setValue(givenCity.geonameid, forKey: "geonameid")
            } else if let givenCityName = data as? String {
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                do {
                    try context.execute(request)
                } catch {
                    print("Could not delete data!")
                }
                
                entity.setValue(givenCityName, forKey: "name")
            } else if let givenCityBool = data as? Bool {
                entity.setValue(givenCityBool, forKey: "hasInitialized")
            }
            
            print("Saving")
            do {
                try context.save()
                print("Saved Successfully")
            } catch {
                print("Failed saving")
            }
        }
    }
    
    static func checkData(data: String) -> Bool {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "CityDataObject")
        request.returnsObjectsAsFaults = false
        
        do {
            if let context = managedContext {
                let result = try context.fetch(request)
                for city in result as! [NSManagedObject] {
                    let name = city.value(forKey: "name") as! String
                    if name == data {
                        return true
                    }
                }
            }
        } catch {
            print("Failed to load notes")
        }
        
        return false
    }
    
    static func checkName(data: String, replacement: String) {
        let currentCity: String = fetchData(entityName: "CurrentCity")
        if data == currentCity {
            saveData(entityName: "CurrentCity", data: replacement)
        }
    }
}


