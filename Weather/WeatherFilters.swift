//
//  WeatherFilters.swift
//  Weather
//
//  Created by Grant Maloney on 9/20/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit
import Foundation

class Snow {
    let flakeEmitterCell = CAEmitterCell()
    let snowEmitterLayer = CAEmitterLayer()
    
    func handleSnow(toggle: Bool, view: UIView) {
        if toggle {
            flakeEmitterCell.contents = UIImage(named: "snowFlake")?.cgImage
            flakeEmitterCell.scale = 0.06
            flakeEmitterCell.scaleRange = 0.3
            flakeEmitterCell.emissionRange = .pi
            flakeEmitterCell.lifetime = 20.0
            flakeEmitterCell.birthRate = 40
            flakeEmitterCell.velocity = -30
            flakeEmitterCell.velocityRange = -20
            flakeEmitterCell.yAcceleration = 30
            flakeEmitterCell.xAcceleration = 5
            flakeEmitterCell.spin = -0.5
            flakeEmitterCell.spinRange = 1.0
            
            snowEmitterLayer.emitterPosition = CGPoint(x: view.bounds.width / 2.0, y: -50)
            snowEmitterLayer.emitterSize = CGSize(width: view.bounds.width, height: 0)
            snowEmitterLayer.emitterShape = kCAEmitterLayerLine
            snowEmitterLayer.beginTime = CACurrentMediaTime()
            snowEmitterLayer.timeOffset = 10
            snowEmitterLayer.emitterCells = [flakeEmitterCell]
            view.layer.addSublayer(snowEmitterLayer)
        } else {
            snowEmitterLayer.removeFromSuperlayer()
        }
    }
}
