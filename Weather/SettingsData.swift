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

struct UnsplashData: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let raw, full, regular, small: String
    let thumb: String
}

class SettingsData {
    
    static func loadSettings() -> Background? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Background> = Background.fetchRequest()
        
        do {
            let data = try managedContext.fetch(fetchRequest)
            for result in data {
                return result
            }
        } catch {
            print("Error loading contacts!")
        }
        
        return nil
    }
    
    static func loadNASAImage(date: Date, force: Bool, option: Int, completion: @escaping(URL) -> ()) {
        guard let url = URL(string: "https://api.nasa.gov/planetary/apod?api_key=Gx0ZaquZm68WEtiVgTg4c7E7ronVNWb1m1l0xp2j") else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(NasaData.self, from: data)
                
                guard let url = URL(string: (option == 0 ? data.url : data.hdurl)) else {
                    return
                }
                
                if dateFormatter.string(from: date) == data.date && !force {
                    return
                }
                
                completion(url)
                
            } catch let err {
                print("Err", err)
            }
        }.resume()
    }
    
    static func loadUnsplashImage(date: Date, force: Bool, option: Int, completion: @escaping(URL) -> ()) {
        guard let url = URL(string: "https://api.unsplash.com/photos/random/?client_id=5c92cae8923c68f7f1c821cc2817fa67a841a46059c79ddff27f7f28923c67af") else {
            return
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        URLSession.shared.dataTask(with: url) { (data, response
            , error) in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(UnsplashData.self, from: data)
                
                guard let url = URL(string: (option == 0 ? data.urls.regular : data.urls.raw)) else {
                    return
                }
                
                if dateFormatter.string(from: date) == dateFormatter.string(from: Date()) && !force {
                    return
                }
                
                completion(url)
                
            } catch let err {
                print("Err", err)
            }
            }.resume()
    }
    
    static func checkNASAImage(date: Date, force: Bool, option: Int, completion: @escaping(UIImage?) -> ()) {
        loadNASAImage(date: date, force: force, option: option) { url in
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }
    }
    
    static func checkUnsplashImage(date: Date, force: Bool, option: Int, completion: @escaping(UIImage?) -> ()) {
        loadUnsplashImage(date: date, force: force, option: option) { url in
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    if let downloadedImage = UIImage(data: data) {
                        completion(downloadedImage)
                    }
                }
            }
        }
    }
    
    static func saveData(downloadedImage: UIImage, quality: Int, option: String) {
        deleteAllSettingsData()
        let foundContent = Background(quality: quality, option: option, image: downloadedImage)
        do {
            if let context = foundContent?.managedObjectContext {
                try context.save()
            }
        } catch {
            print("Unable to save NASA content")
        }
    }
    
    static func deleteAllSettingsData() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: Background.fetchRequest())
        
        do {
            try managedContext.execute(batchDeleteRequest)
            
        } catch {
            print("Unable to delete all records in Background entity")
        }
    }
}
