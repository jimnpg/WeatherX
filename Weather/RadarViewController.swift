//
//  RadarViewController.swift
//  Weather
//
//  Created by Grant Maloney on 9/29/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import MapKit
import AerisMapKit

class RadarViewController: AWFWeatherMapViewController {
    
    var latitude: Double?
    var longitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layer = AWFRasterMapLayer(layerType: .radar)
        weatherMap.amp.addRasterLayer(layer)
        if let lat = latitude {
            if let lng = longitude {
                let weather = weatherMap.mapView as! MKMapView
                let center = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.50, longitudeDelta: 0.50))
                weather.setRegion(region, animated: true)
            }
        }
    }
}
