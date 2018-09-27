//
//  HourCell.swift
//  Weather
//
//  Created by Grant Maloney on 9/19/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class HourCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var degreeLabel: UILabel!
    
    func updateCell(cellForItemAt: IndexPath, collectionViewData: [CollectionViewData]) {
        if collectionViewData.isEmpty {
            self.titleLabel.text = "--"
        } else {
            self.titleLabel.text = collectionViewData[cellForItemAt.row].hour
        }
        
        if collectionViewData.isEmpty {
            self.degreeLabel.text = "--°"
        } else {
            self.degreeLabel.text = "\(collectionViewData[cellForItemAt.row].degree)°"
        }
        
        if collectionViewData.isEmpty {
            self.image.image = UIImage(named: "clear-day")
        } else {
            self.image.image = UIImage(named: collectionViewData[cellForItemAt.row].icon.rawValue)
        }
    }
}
