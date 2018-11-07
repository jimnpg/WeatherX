//
//  SettingsData.swift
//  Weather
//
//  Created by Grant Maloney on 11/6/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import CoreData
import UIKit

struct NasaData: Codable {
    let copyright, date, explanation: String
    let hdurl: String
    let mediaType, serviceVersion, title: String
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case copyright, date, explanation, hdurl
        case mediaType = "media_type"
        case serviceVersion = "service_version"
        case title, url
    }
}

class SettingsData {
    
    static let appDelegate = UIApplication.shared.delegate as? AppDelegate
    static let managedContext = appDelegate?.persistentContainer.viewContext
    
    static func saveData(entityName: String, data: Any) {
        if let context = managedContext {
            let entity: NSManagedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
            
            if let option = data as? String {
                let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                let request = NSBatchDeleteRequest(fetchRequest: fetch)
                do {
                    try context.execute(request)
                } catch {
                    print("Could not delete data!")
                }
                
                entity.setValue(option, forKey: "option")
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
    
    static func loadBackgroundOption(completion: @escaping(URL) -> ()) {
        
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=Gx0ZaquZm68WEtiVgTg4c7E7ronVNWb1m1l0xp2j") else {
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(NasaData.self, from: data)
                
                guard let hdurl = URL(string: data.hdurl) else {
                    return
                }
                
                completion(hdurl)
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
}
