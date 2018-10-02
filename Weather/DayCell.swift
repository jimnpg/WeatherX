//
//  DayCell.swift
//  Weather
//
//  Created by Grant Maloney on 9/19/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell {
    @IBOutlet weak var degreeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var lowTempLabel: UILabel!
    @IBOutlet weak var underView: UIView!
    
    func updateCell(cellForItemAt: IndexPath, dailyViewData: [DailyViewData]) {
        self.underView.layer.cornerRadius = 8.0
        self.underView.layer.borderColor = UIColor.white.cgColor
        self.underView.layer.borderWidth = 1
        
        if !dailyViewData.isEmpty {
            self.titleLabel.text = dailyViewData[cellForItemAt.row].name
            self.degreeLabel.text = "\(dailyViewData[cellForItemAt.row].highTemperature)°"
            self.lowTempLabel.text = "\(dailyViewData[cellForItemAt.row].lowTemperature)°"
            self.image.image = UIImage(named: dailyViewData[cellForItemAt.row].weather.rawValue)
        } else {
            self.titleLabel.text = ""
            self.degreeLabel.text = "--°"
            self.lowTempLabel.text = "--°"
            self.image.image = UIImage(named: "clear-day")
        }
    }
}
