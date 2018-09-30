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
        
        legendView.addLegend(forLayerType: AWFMapLayer.radar)
        self.navigationItem.rightBarButtonItem = nil
        
        let mainSubView = self.view.subviews[3];
        
        /*
         This is really gross, this API documentation and manipulability is AWFUL. Either I don't understand some functionality, or they wrote it to be as uncustomizable as possible. I feel the later, I've spent 2 days now trying to manipulate the view to my liking. This was my best solution and making the legend view look clean.
        */
        if let stackView = mainSubView.subviews[0] as? UIStackView {
            if let label = stackView.subviews[0].subviews[0] as? UILabel {
                label.text = ""
            }
        }
        
        if let button = mainSubView.subviews[1] as? UIButton {
            button.sendActions(for: .touchUpInside)
        }
    }
}