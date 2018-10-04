//
//  SearchCell.swift
//  Weather
//
//  Created by Grant Maloney on 9/24/18.
//  Copyright © 2018 Grant Maloney. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var cityName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
