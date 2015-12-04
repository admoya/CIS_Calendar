//
//  TaskCell.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 12/3/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {

    @IBOutlet var tasknameLbl: UILabel!
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var classLbl: UILabel!
    @IBOutlet var priorityLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTaskName(name: String){
        tasknameLbl.text = name
    }
    
    func setDate(date: String){
        dateLbl.text = date
    }
    
    func setClass(className: String){
        classLbl.text = className
    }
    
    func setPriority(priority: String){
        priorityLbl.text = priority
    }

}
