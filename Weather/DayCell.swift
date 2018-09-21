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
    
    func updateCell(cellForItemAt: IndexPath, days: [String]) {
        self.titleLabel.text = "\(days[cellForItemAt.row]) 12/16"
        
        let lowTemp = NSMutableAttributedString(string:"18°", attributes: [NSAttributedStringKey.foregroundColor : UIColor(rgb: 0x83adef)])
        
        let divider = NSMutableAttributedString(string:"|", attributes: [NSAttributedStringKey.foregroundColor : UIColor.white])
        
        let highTemp = NSMutableAttributedString(string:"25°", attributes: [NSAttributedStringKey.foregroundColor : UIColor(rgb: 0xef8282)])
        
        lowTemp.append(divider)
        lowTemp.append(highTemp)
        
        self.degreeLabel.attributedText = lowTemp
        
        self.image.image = UIImage(named: "Sun")
    }
}
