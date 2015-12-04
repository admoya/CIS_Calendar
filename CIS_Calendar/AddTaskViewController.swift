//
//  AddTaskViewController.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 12/3/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class AddTaskViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet var taskNameTF: UITextField!
    @IBOutlet var priorityPicker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    @IBOutlet var classPicker: UIPickerView!
    let store = EKEventStore()
    var taskDate : NSDate!
    var classes : NSMutableArray!
    var mainCal = EKCalendar(forEntityType: EKEntityType.Event, eventStore: EKEventStore())
    var classNames = ["No Class Association"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        priorityPicker.tag = 0;
        classPicker.tag = 1;
        taskDate = datePicker.date
        mainCal = fetchCalendar()
        self.fetchClasses({ (events: NSMutableArray) -> Void in
            self.classes = events
            self.classPicker.reloadAllComponents()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchClasses(completed: (NSMutableArray) -> ()) {
        let eventStore = self.store
        let endDate = NSDate(timeIntervalSinceNow: 604800*1);   //This is 1 weeks in seconds
        let predicate = eventStore.predicateForEventsWithStartDate(NSDate().dateByAddingTimeInterval(-86400 * 14), endDate: endDate, calendars: [self.mainCal])
        let events = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate))
        for ev1 in events {
            if (!classNames.contains(ev1.title!!) && ev1.notes == "STC_Class")
            {
                classNames.append(ev1.title!!)
            }
        }
    completed(events)
    }
    
    func fetchCalendar()->EKCalendar
    {
        for calendar in store.calendarsForEntityType(EKEntityType.Event)
        {
            if calendar.title == "Super Task Cal"
            {
                return calendar
            }
        }
        let newCalendar = EKCalendar(forEntityType:EKEntityType.Event, eventStore:store)
        newCalendar.title="Super Task Cal"
        newCalendar.source = store.defaultCalendarForNewEvents.source
        try! store.saveCalendar(newCalendar, commit:true)
        //addClass(self)
        return newCalendar
    }
    
    @IBAction func dateChanged(sender: UIDatePicker) {
        taskDate = sender.date
        //print(taskDate)
    }
    @IBAction func CloseView(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func AddTask(sender: AnyObject) {
        if (taskNameTF.text != nil)
        {
        if (NSUserDefaults.standardUserDefaults().objectForKey("tasks") == nil)
        {
            //print("Taking this")
            let tmpClasses = [Task(name: taskNameTF.text!, priority: priorityPicker.selectedRowInComponent(0), date: taskDate, associatedClass: classNames[classPicker.selectedRowInComponent(0)], completed: false)]
            
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(tmpClasses)
            
            NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: "tasks")
            NSUserDefaults.standardUserDefaults().synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else{
                let decoded = NSUserDefaults.standardUserDefaults().objectForKey("tasks") as! NSData
                var tmpClasses = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as! [Task]
            
                tmpClasses.append(Task(name: taskNameTF.text!, priority: priorityPicker.selectedRowInComponent(0), date: taskDate, associatedClass: classNames[classPicker.selectedRowInComponent(0)], completed: false))
            
                let encodedData = NSKeyedArchiver.archivedDataWithRootObject(tmpClasses)
            
                NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: "tasks")
                NSUserDefaults.standardUserDefaults().synchronize()
                self.dismissViewControllerAnimated(true, completion: nil)

            
            }
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if(pickerView.tag == 0){
            return 5
        }
        else{
            return self.classNames.count
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0{
            return String(row)
        }
        else
        {
            return self.classNames[row]
        }
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
       
    }



}
