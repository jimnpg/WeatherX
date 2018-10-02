//
//  CollectionViewData.swift
//  Weather
//
//  Created by Grant Maloney on 9/20/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import ForecastIO

class CollectionViewData {
    let hour: String
    let icon: Icon
    let degree: String
    
    init(hour: String, icon: Icon, degree: String) {
        self.hour = hour
        self.icon = icon
        self.degree = degree
    }
}

class DailyViewData {
    let name: String
    let weather: Icon
    let lowTemperature: String
    let highTemperature: String
    
    init(name: String, weather: Icon, lowTemperature: String, highTemperature: String) {
        self.name = name
        self.weather = weather
        self.lowTemperature = lowTemperature
        self.highTemperature = highTemperature
    }
}
