//
//  AddClassViewController.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 10/20/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit

class AddClassViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var classNameTF: UITextField!
    @IBOutlet var classDateTable: UITableView!
    var cellCount = 1
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
                    
                    
                    let startDate = NSCalendar.currentCalendar().dateFromComponents(getStartTimeFromBlock(cell.getSelectedBlock1()))
                    let endDate = NSCalendar.currentCalendar().dateFromComponents(getEndTimeFromBlock(cell.getSelectedBlock2()))
                    
                    print(event.title)
                    print(startDate!)
                    print(endDate!)
             
                    
                    event.startDate = startDate!
                    event.endDate = endDate!
                    
                    event.recurrenceRules = [cell.getRecurrence()]
                    
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
        if NSDateComponents().month <= 5
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2015
            tmpDate.month = 1
            tmpDate.day = 5
            return tmpDate
        }
        
        else
        {
            let tmpDate = NSDateComponents()
            tmpDate.year = 2015
            tmpDate.month = 8
            tmpDate.day = 24
            return tmpDate
        }
        
    }
}
