//
//  AddClassViewController.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 10/20/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit

class AddClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var semPicker: UIPickerView!
    @IBOutlet var classNameTF: UITextField!
    @IBOutlet var classDateTable: UITableView!
    var cellCount = 1
    let pickerData = ["Fall", "Spring", "SummerA", "SummerB", "SummerC"]
    override func viewDidLoad() {
        super.viewDidLoad()
        
        classDateTable.scrollEnabled = false
        classDateTable.allowsSelection = false
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func CloseView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("classTimeCell")!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //print("Selected: \(row)")
            }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = pickerData[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 12) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }


    @IBAction func addClassDate(sender: AnyObject) {
        cellCount++
        classDateTable.scrollEnabled = true
        classDateTable.reloadData()
    }

    @IBAction func addClass(sender: AnyObject) {
        let store = EKEventStore()
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        var found = false
        
        for calendar in calendars
        {
            if calendar.title == "Super Task Cal"
            {
                found = true
                
                for tmpCell in classDateTable.visibleCells
                {
                   let cell = tmpCell as! AddClassCell
                    
                    let event = EKEvent(eventStore: store)
                    
                    event.title = classNameTF.text!
                    
                    event.notes = "STC_Class"
                    
                    
                    var startDate = NSCalendar.currentCalendar().dateFromComponents(getStartTimeFromBlock(cell.getSelectedBlock1()))
                    
                    var endDate = NSCalendar.currentCalendar().dateFromComponents(getEndTimeFromBlock(cell.getSelectedBlock2()))
                    
                    while(getDayOfWeek(startDate!) < cell.getFirstDay(getDayOfWeek(startDate!))){
                        startDate = startDate!.dateByAddingTimeInterval(86400)
                        endDate = endDate!.dateByAddingTimeInterval(86400)
                    }
                    
                    print(event.title)
                    print(startDate!)
                    print(endDate!)
             
                    
                    event.startDate = startDate!
                    event.endDate = endDate!
                    
                    event.recurrenceRules = [cell.getRecurrence(semPicker.selectedRowInComponent(0))]
                    
                    event.calendar = calendar
                    
                    print(event)
                    
                    try! store.saveEvent(event, span: EKSpan.ThisEvent)
                    
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            }
        }
        
        if !found
        {
            let newCalendar = EKCalendar(forEntityType:EKEntityType.Event, eventStore:store)
            newCalendar.title="Super Task Cal"
            newCalendar.source = store.defaultCalendarForNewEvents.source
            try! store.saveCalendar(newCalendar, commit:true)
            addClass(self)
        }
        
        
    }
    
    func getStartTimeFromBlock(block: String)->NSDateComponents
    {
        switch (block){
        
        case "Block 1":
           let tmpDate = getStartOfSemester()
           tmpDate.hour = 7
           tmpDate.minute = 25
            return tmpDate
        case "Block 2":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 8
            tmpDate.minute = 30
            return tmpDate
        case "Block 3":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 9
            tmpDate.minute = 35
            return tmpDate
        case "Block 4":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 10
            tmpDate.minute = 40
            return tmpDate
        case "Block 5":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 11
            tmpDate.minute = 45
            return tmpDate
        case "Block 6":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 12
            tmpDate.minute = 50
            return tmpDate
        case "Block 7":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 13
            tmpDate.minute = 55
            return tmpDate
        case "Block 8":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 15
            tmpDate.minute = 0
            return tmpDate
        case "Block 9":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 16
            tmpDate.minute = 5
            return tmpDate
        case "Block 10":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 17
            tmpDate.minute = 10
            return tmpDate
        case "Block 11":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 18
            tmpDate.minute = 15
            return tmpDate
        case "Block E1":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 19
            tmpDate.minute = 20
            return tmpDate
        case "Block E2":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 20
            tmpDate.minute = 20
            return tmpDate
        case "Block E3":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 21
            tmpDate.minute = 20
            return tmpDate
        default:
            print("Invalid date!")
            return NSDateComponents()

        }
        
    }
    
    func getEndTimeFromBlock(block: String)->NSDateComponents
    {
        switch (block){
            
        case "Block 1":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 8
            tmpDate.minute = 15
            return tmpDate
        case "Block 2":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 9
            tmpDate.minute = 20
            return tmpDate
        case "Block 3":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 10
            tmpDate.minute = 25
            return tmpDate
        case "Block 4":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 11
            tmpDate.minute = 30
            return tmpDate
        case "Block 5":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 12
            tmpDate.minute = 35
            return tmpDate
        case "Block 6":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 13
            tmpDate.minute = 40
            return tmpDate
        case "Block 7":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 14
            tmpDate.minute = 45
            return tmpDate
        case "Block 8":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 15
            tmpDate.minute = 50
            return tmpDate
        case "Block 9":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 16
            tmpDate.minute = 55
            return tmpDate
        case "Block 10":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 18
            tmpDate.minute = 0
            return tmpDate
        case "Block 11":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 19
            tmpDate.minute = 5
            return tmpDate
        case "Block E1":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 20
            tmpDate.minute = 10
            return tmpDate
        case "Block E2":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 21
            tmpDate.minute = 10
            return tmpDate
        case "Block E3":
            let tmpDate = getStartOfSemester()
            tmpDate.hour = 22
            tmpDate.minute = 10
            return tmpDate
        default:
            print("Invalid date!")
            return NSDateComponents()
            
        }
        
    }

    
    func getStartOfSemester()->NSDateComponents
    {
        if semPicker.selectedRowInComponent(0) == 1 //Spring
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2016
            tmpDate.month = 1
            tmpDate.day = 5
            return tmpDate
        }
        
        else if semPicker.selectedRowInComponent(0) == 0 //Fall
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2015
            tmpDate.month = 8
            tmpDate.day = 24
            return tmpDate
        }
        else if semPicker.selectedRowInComponent(0) == 2 //Summer A
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2016
            tmpDate.month = 5
            tmpDate.day = 9
            return tmpDate
        }
        else if semPicker.selectedRowInComponent(0) == 3 //Summer B
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2016
            tmpDate.month = 6
            tmpDate.day = 27
            return tmpDate
        }
        else {
            let tmpDate = NSDateComponents() //Summer C
            tmpDate.year = 2016
            tmpDate.month = 5
            tmpDate.day = 9
            return tmpDate
        }
        
    }
    
    func getDayOfWeek(date: NSDate)->Int{
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
        let myComponents = myCalendar.components(.Weekday, fromDate: date)
        let weekDay = myComponents.weekday
        return weekDay
    }
}
