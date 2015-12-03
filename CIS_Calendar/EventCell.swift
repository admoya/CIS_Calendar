//
//  EventCell.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 12/2/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit

class EventCell: UITableViewCell {

    @IBOutlet var eventNameLbl: UILabel!
    @IBOutlet var dayLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var timeLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
