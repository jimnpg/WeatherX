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

let key: String = "559d2cbcb1143a2ef9354c0827d4c6a8"
let darkSkyApiURL: String = "https://api.darksky.net/forecast/" //559d2cbcb1143a2ef9354c0827d4c6a8/37.8267,-122.4233"

let formatter = DateFormatter()

class Location {
    var lat: Double
    var lng: Double
    
    init(lat: Double, lng: Double) {
        self.lat = lat
        self.lng = lng
        formatter.dateFormat = "h:mm a"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
    }
    
    func getData(completion: @escaping(City) -> ()) {
        let client = DarkSkyClient(apiKey: key)
        client.units = .us
        client.language = .english
        
        client.getForecast(latitude: lat, longitude: lng) { result in
            switch result {
            case .success(let currentForecast, let requestMetadata):
                print(currentForecast.currently?.windSpeed)
                print(currentForecast.currently?.windBearing)
                print(currentForecast.currently?.precipitationProbability)
                print(currentForecast.currently?.humidity)
                formatter.locale = Locale(identifier: currentForecast.timezone)
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
                                                        
                                                        for (index, hour) in hours.enumerated() {
                                                            if let icon = hour.icon {
                                                                if let temperature = hour.temperature {
                                                                    if index == 0 {
                                                                        collectionViewData.append(CollectionViewData(hour: "Now", icon: icon, degree: String(Int(temperature))))
                                                                        currentTemperature = "\(String(Int(temperature)))°"
                                                                    } else {
                                                                        collectionViewData.append(CollectionViewData(hour: formatter.string(from: hour.time), icon: icon, degree: String(Int(temperature))))
                                                                    }
                                                                }
                                                            }
                                                        }
                                                        
                                                        let sunset = formatter.string(from: sunsetTime)
                                                        let sunrise = formatter.string(from: sunriseTime)
                                                        let time = formatter.string(from: currentTime)
                                                        
                                                        completion(City(sunrise: sunrise, sunset: sunset, currentTime: time, collectionViewData: collectionViewData, currentTemperature: currentTemperature, lowTemperature: lowTemperature, highTemperature: highTemperature, windSpeed: windSpeed, windDirection: windDirection, precipitationProbability: precipitationProbability, humidity: humidity))
                                                    }
                                                }
                                            }
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

}
