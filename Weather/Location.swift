//
//  City.swift
//  Weather
//
//  Created by Grant Maloney on 9/20/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import Foundation
import ForecastIO
import CoreLocation

let key: String = "559d2cbcb1143a2ef9354c0827d4c6a8"
let darkSkyApiURL: String = "https://api.darksky.net/forecast/"

let formatter = DateFormatter()
let currentTimeFormatter = DateFormatter()
let dayFormatter = DateFormatter()

class Location {
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        formatter.dateFormat = "h a"
        currentTimeFormatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        currentTimeFormatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        currentTimeFormatter.pmSymbol = "PM"
        dayFormatter.dateFormat = "EEEE"
    }
    
    func getData(completion: @escaping(City) -> ()) {
        let client = DarkSkyClient(apiKey: key)
        client.getForecast(latitude: lat, longitude: lng) { result in
            switch result {
            case .success(let currentForecast, _):
                currentTimeFormatter.timeZone = TimeZone(identifier: currentForecast.timezone)
                formatter.timeZone = TimeZone(identifier: currentForecast.timezone)
                if let sunsetTime = currentForecast.daily?.data[0].sunsetTime {
                    if let sunriseTime = currentForecast.daily?.data[0].sunriseTime {
                        if let currentTime = currentForecast.currently?.time {
                            if let hours = currentForecast.hourly?.data {
                                if let lowTemperature = currentForecast.daily?.data[0].temperatureLow {
                                    if let highTemperature = currentForecast.daily?.data[0].temperatureHigh {
                                        if let windSpeed = currentForecast.currently?.windSpeed {
                                            if let windBearing = currentForecast.currently?.windBearing {
                                                if let precipitationProbability = currentForecast.currently?.precipitationProbability {
                                                    if let humidity = currentForecast.currently?.humidity {
                                                        var collectionViewData = [CollectionViewData]()
                                                        var currentTemperature: String = ""
                                                        let lowTemperature = "\(String(Int(lowTemperature)))°"
                                                        let highTemperature = "\(String(Int(highTemperature)))°"
                                                        let windSpeed = String(Int(round(windSpeed)))
                                                        let windDirection = self.windDirectionFromDegrees(degrees: windBearing)
                                                        let precipitationProbability = String(Int(round(precipitationProbability * 100)))
                                                        let humidity = String(Int(round(humidity * 100)))
                                                        
                                                        var days: [DailyViewData] = []
                                                        if let daily = currentForecast.daily {
                                                            for (index, day) in daily.data.enumerated() {
                                                                if index > 0 {
                                                                    if let icon = day.icon {
                                                                        if let lowTemp = day.temperatureLow {
                                                                            if let highTemp = day.temperatureHigh {
                                                                                print(icon)
                                                                                let lowestTemp = String(Int(lowTemp))
                                                                                let highestTemp = String(Int(highTemp))
                                                                                days.append(DailyViewData(name: dayFormatter.string(from: day.time), weather: icon, lowTemperature: lowestTemp, highTemperature: highestTemp))
                                                                            }
                                                                        }
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        for (index, hour) in hours.enumerated() {
                                                            if let icon = hour.icon {
                                                                if let temperature = hour.temperature {
                                                                    if index == 0 {
                                                                        collectionViewData.append(CollectionViewData(hour: "Now", icon: icon, degree: String(Int(temperature))))
                                                                        currentTemperature = "\(String(Int(temperature)))"
                                                                    } else {
                                                                        collectionViewData.append(CollectionViewData(hour: formatter.string(from: hour.time), icon: icon, degree: String(Int(temperature))))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        let sunset = currentTimeFormatter.string(from: sunsetTime)
                                                        let sunrise = currentTimeFormatter.string(from: sunriseTime)
                                                        let time = currentTimeFormatter.string(from: currentTime)
                                                        
                                                        completion(City(sunrise: sunrise, sunset: sunset, currentTime: time, collectionViewData: collectionViewData, currentTemperature: currentTemperature, lowTemperature: lowTemperature, highTemperature: highTemperature, windSpeed: windSpeed, windDirection: windDirection, precipitationProbability: precipitationProbability, humidity: humidity, currentDate: currentTime, weekInformation: days))
                                                    } else {
                                                        print("Could not find humidity!")
                                                    }
                                                } else {
                                                    print("Could not find precipitation probability!")
                                                }
                                            } else {
                                                print("Could not find wind bearing!")
                                            }
                                        } else {
                                            print("Could not find wind speed!")
                                        }
                                    } else {
                                        print("Could not find high temperature of the day!")
                                    }
                                } else {
                                    print("Could not find low temperature of the day!")
                                }
                            } else {
                                print("Could not find hours in the day!")
                            }
                        } else {
                            print("Could not find current time!")
                        }
                    } else {
                        print("Could not find sunrise time!")
                    }
                } else {
                    print("Could not find sunset time!")
                }
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func windDirectionFromDegrees(degrees: Double) -> String{
        let directions: [String] = ["NORTH", "NNE", "NORTHEAST", "ENE", "EAST", "ESE", "SOUTHEAST", "SSE",
                                     "SOUTH", "SSW", "SOUTHWEST", "WSW", "WEST", "WNW", "NORTHWEST", "NNW"]
        
        let i = Int((degrees + 11.25)/22.5)
        return directions[i % 16]
    }
    
    static func getCoordinate( addressString : String,
                               completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                    
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}
