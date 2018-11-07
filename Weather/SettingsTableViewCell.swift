//
//  SettingsTableViewCell.swift
//  Weather
//
//  Created by Grant Maloney on 11/6/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var qualityControl: UISegmentedControl!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var curveView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
