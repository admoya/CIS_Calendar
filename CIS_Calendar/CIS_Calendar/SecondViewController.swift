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
    var indexToPass: Int = 0
    var mainCal = EKCalendar(forEntityType: EKEntityType.Event, eventStore: EKEventStore())
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        if checkCalendarPermission(){
            mainCal = fetchCalendar()
            self.fetchEvents({ (events: NSMutableArray) -> Void in
                self.events = events
                self.cellCount = events.count
                self.eventTable.reloadData()
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "ClassDetailSegue")
        {
            let svc = segue.destinationViewController as! EventDetail;
            svc.events = self.events
            svc.index = self.indexToPass
        }
    }
    
    func fetchEvents(completed: (NSMutableArray) -> ()) {
                let eventStore = self.store
                let endDate = NSDate(timeIntervalSinceNow: 604800*1);   //This is 1 weeks in seconds
                let predicate = eventStore.predicateForEventsWithStartDate(NSDate(), endDate: endDate, calendars: [self.mainCal])
                let events = NSMutableArray(array: eventStore.eventsMatchingPredicate(predicate))
                //print(events)
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
    
    func getPermission()
    {
        store.requestAccessToEntityType(EKEntityType.Event, completion: {[weak weakEventStore = self.store]
            granted, error in
            print("Permission granted to access \(weakEventStore)");
            })

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
        
        let cell = tableView.dequeueReusableCellWithIdentifier("eventCell")! as! EventCell
        if cellCount != 0
        {
            cell.eventNameLbl?.text = events[indexPath.row].title
        
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
            let timeFormatter = NSDateFormatter()
            timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
            let dayFormatter = NSDateFormatter()
            dayFormatter.dateStyle = NSDateFormatterStyle.FullStyle
            cell.dateLbl?.text = dateFormatter.stringFromDate(events[indexPath.row].startDate)
            cell.timeLbl?.text = timeFormatter.stringFromDate(events[indexPath.row].startDate)
            
            //Quick calculation of weekday
            var dayStr = dayFormatter.stringFromDate(events[indexPath.row].startDate)
            if (dayStr[dayStr.startIndex.advancedBy(1)] == "h" )
            {
                dayStr = "R"
            }
            else if (dayStr[dayStr.startIndex] == "S" && dayStr[dayStr.startIndex.advancedBy(1)] == "u")
            {
                dayStr = "Su"
            }
            else{
            dayStr = dayStr.substringToIndex(dayStr.startIndex.advancedBy(1))
            }
            cell.dayLbl.text = dayStr
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        indexToPass = indexPath.row
        self.performSegueWithIdentifier("ClassDetailSegue", sender: nil)
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
                return granted
            })
        case .Denied, .Restricted:
            
            let alert = UIAlertController(title: "Access Denied", message: "Permission is needed to access the calendar. Go to Settings > Privacy > Calendars to allow access for the CIS Calendar app.", preferredStyle: .Alert) // 1
            /*
            NOTE: The following will open the settings menu and allow the user to grant permission. iOS automatically kills an application that has its security settings changed while it is running (not a bad idea, but unfortunate here). When running the application on XCode, the app will crash. However, if the application is run through the simulator by just clicking the icon, you will see that when you return to the application it will have restarted instead of crashing.
            */
            let firstAction = UIAlertAction(title: "Okay", style: .Default) { (alert: UIAlertAction!) -> Void in
                dispatch_after(1, dispatch_get_main_queue(), {
                UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
                })
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

