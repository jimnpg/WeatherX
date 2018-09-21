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
            self.titleLabel.text = "\(cellForItemAt.row):00 AM"
        } else {
            self.titleLabel.text = collectionViewData[cellForItemAt.row].hour
        }
        
        if collectionViewData.isEmpty {
            self.degreeLabel.text = "18°"
        } else {
            self.degreeLabel.text = "\(collectionViewData[cellForItemAt.row].degree)°"
        }
        
        self.image.image = UIImage(named: "Sun")//Need to take icon use from object collectionViewData
    }
}
