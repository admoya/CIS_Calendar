//
//  SecondViewController.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 10/16/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI
class SecondViewController: UIViewController, EKEventEditViewDelegate, UITableViewDelegate, UITableViewDataSource{
    let store = EKEventStore();
    var cellCount = 0;
    @IBOutlet var eventTable: UITableView!
    var events = NSMutableArray()
    var mainCal = EKCalendar(forEntityType: EKEntityType.Event, eventStore: EKEventStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainCal = fetchCalendar()
        self.fetchEvents({ (events: NSMutableArray) -> Void in
        self.events = events
        self.cellCount = events.count
        self.eventTable.reloadData()
        })
        
    }
    
    func fetchEvents(completed: (NSMutableArray) -> ()) {
        store.requestAccessToEntityType(EKEntityType.Event, completion: {[weak weakEventStore = self.store]
            granted, error in
            if let eventStore = weakEventStore {
                let endDate = NSDate(timeIntervalSinceNow: 604800*10);   //This is 10 weeks in seconds
                let predicate = eventStore.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: [self.mainCal])
                let events = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate))
                //print(events)
                completed(events)
            }
        })
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
        addClass(self)
        return newCalendar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func addClass(sender: AnyObject) {
        if checkCalendarPermission()
        {
            self.performSegueWithIdentifier("AddClassSegue", sender: nil)
        }
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellCount
    }

    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "Cell")
        if cellCount != 0
        {
            cell.textLabel?.text = events[indexPath.row].title
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            
            cell.detailTextLabel?.text = dateFormatter.stringFromDate(events[indexPath.row].startDate)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    
    
    
    
    

    @IBAction func addToCalendar(sender: AnyObject) {
        
        let eventController = EKEventEditViewController()
        
        eventController.eventStore = store
        eventController.editViewDelegate = self
        self.dismissViewControllerAnimated(true, completion: nil)
        
        let event = EKEvent(eventStore: store)
        eventController.event = event
        
        if (checkCalendarPermission())
        {
            self.presentViewController(eventController, animated: true, completion: nil)
        }

    }
    
    func eventEditViewController(controller: EKEventEditViewController,
        didCompleteWithAction action: EKEventEditViewAction){
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func  checkCalendarPermission() -> Bool
    {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        switch status {
        case .Authorized:
            //self.setNavBarAppearanceStandard()
            return true
            
        case .NotDetermined:
            store.requestAccessToEntityType(EKEntityType.Event, completion: { (granted, error) -> Void in
                if granted == true {
                    //self.setNavBarAppearanceStandard()
                    return
                }
            })
        case .Denied, .Restricted:
            
            let alert = UIAlertController(title: "Access Denied", message: "Permission is needed to access the calendar. Go to Settings > Privacy > Calendars to allow access for the CIS Calendar app.", preferredStyle: .Alert) // 1
            let firstAction = UIAlertAction(title: "Okay", style: .Default) { (alert: UIAlertAction!) -> Void in
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
            }
            let secondAction = UIAlertAction(title: "No", style: .Default) { (alert: UIAlertAction!) -> Void in
                
            }
            alert.addAction(firstAction);
            alert.addAction(secondAction);
            presentViewController(alert, animated: true, completion: nil)
            return false
        }
        return true
    }
}

