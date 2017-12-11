//
//  arrivalTimeTableViewCell.swift
//  TRANSIT
//
//  Created by Sam Kortekaas on 10/12/2017.
//  Copyright © 2017 Kortekaas. All rights reserved.
//

import UIKit

class arrivalTimeTableViewCell: UITableViewCell {
    @IBOutlet weak var cellTimeLabel: UILabel!
    @IBOutlet weak var cellPlatformLabel: UILabel!
    @IBOutlet weak var cellNameLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with train: ArrivingTrain) {
        cellTimeLabel.text = String(train.timeToStation/60) + " min"
        cellNameLabel.text = train.lineName + " > " + train.towards
        cellPlatformLabel.text = train.platformName
    }

}
