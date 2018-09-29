//
//  MyWeatherConfig.swift
//  Weather
//
//  Created by Grant Maloney on 9/29/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import Foundation
import AerisMapKit

class MyWeatherMapConfig: AWFWeatherMapConfig {
    
    override init() {
        super.init()
        
        self.refreshInterval = 15 * AWFMinuteInterval
        self.animationEnabled = false
    }
}
