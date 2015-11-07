//
//  AddClassCell.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 10/25/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit

class AddClassCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet var blockPicker: UIPickerView!
    @IBOutlet var mBtn: UIButton!
    @IBOutlet var tBtn: UIButton!
    @IBOutlet var wBtn: UIButton!
    @IBOutlet var rBtn: UIButton!
    @IBOutlet var fBtn: UIButton!
    @IBOutlet var saBtn: UIButton!
    @IBOutlet var suBtn: UIButton!

    let pickerData = [["Block 1", "Block 2", "Block 3", "Block 4", "Block 5", "Block 6", "Block 7", "Block 8", "Block 9", "Block 10", "Block 11", "Block E1", "Block E2", "Block E3"],["Block 1", "Block 2", "Block 3", "Block 4", "Block 5", "Block 6", "Block 7", "Block 8", "Block 9", "Block 10", "Block 11", "Block E1", "Block E2", "Block E3"]]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData[component].count
    }

    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0
        {
            blockPicker.selectRow(row, inComponent: 1, animated: true)
        }
        
        else if (row < blockPicker.selectedRowInComponent(0))
        {
            blockPicker.selectRow(blockPicker.selectedRowInComponent(0), inComponent: 1, animated: true)
        }
    }
    
    @IBAction func dayPressed(sender: UIButton) {
        if (sender.tintColor == UIColor.blueColor())
        {
            sender.tintColor = UIColor.lightGrayColor()
        }
        
        else
        {
        sender.tintColor = UIColor.blueColor()
        }
    }
    
    func isBlue(button: UIButton)->Bool
    {
        if button.tintColor == UIColor.blueColor()
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    func getSelectedBlock1()->String{
        return pickerData[0][blockPicker.selectedRowInComponent(0)]
    }
    func getSelectedBlock2()->String{
        return pickerData[1][blockPicker.selectedRowInComponent(1)]
    }
    
    func getRecurrence() -> EKRecurrenceRule
    {
        let tmpDate = NSDateComponents()
        if NSDateComponents().month <= 5
        {
            tmpDate.year = 2016
            tmpDate.month = 4
            tmpDate.day = 21
        }
        else
        {
            tmpDate.year = 2015
            tmpDate.month = 12
            tmpDate.day = 10
        }
        
        let end = EKRecurrenceEnd(endDate: NSCalendar.currentCalendar().dateFromComponents(tmpDate)!)
        
        let recurrence = EKRecurrenceRule(recurrenceWithFrequency: EKRecurrenceFrequency.Weekly, interval: 1, daysOfTheWeek: getDaysOfWeek(), daysOfTheMonth: nil, monthsOfTheYear: nil, weeksOfTheYear: nil, daysOfTheYear: nil, setPositions: nil, end: end)
        
        return recurrence
    }
    
    func getDaysOfWeek()->[EKRecurrenceDayOfWeek]
    {
        var days = [EKRecurrenceDayOfWeek]()
        
        if isBlue(suBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Sunday)
            days.append(day)
        }
        if isBlue(mBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Monday)
            days.append(day)
        }
        if isBlue(tBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Tuesday)
            days.append(day)
        }
        if isBlue(wBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Wednesday)
            days.append(day)
        }
        if isBlue(rBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Thursday)
            days.append(day)
        }
        if isBlue(fBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Friday)
            days.append(day)
        }
        if isBlue(saBtn)
        {
            let day = EKRecurrenceDayOfWeek(EKWeekday.Saturday)
            days.append(day)
        }
        
        return days
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func createEvent() -> EKEvent
    {
        let retEvent = EKEvent(eventStore: EKEventStore())
        
        return retEvent
    }

}
