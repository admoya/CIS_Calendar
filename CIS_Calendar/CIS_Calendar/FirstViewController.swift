//
//  FirstViewController.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 10/16/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

var tasks: [Task]?
class FirstViewController: UIViewController, UITableViewDelegate, UITableViewDataSource  {

    let store = EKEventStore();
    
    @IBOutlet var taskTable: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        if (checkCalendarPermission()){
            if (NSUserDefaults.standardUserDefaults().objectForKey("tasks") != nil){
            let decoded = NSUserDefaults.standardUserDefaults().objectForKey("tasks") as! NSData
            tasks = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Task]
            taskTable.reloadData()
            }
        }
    }
    
    
    @IBAction func addTask(sender: AnyObject) {
        if checkCalendarPermission()
        {
            self.performSegueWithIdentifier("AddTaskSegue", sender: nil)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tasks?.count != nil{
        return (tasks?.count)!
        }
        else{
        return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("taskCell")! as! TaskCell
        let task = tasks?[indexPath.row]
        
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: (task?.name)!)
        if (task!.completed!){
        attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
        }
        
        cell.tasknameLbl.attributedText = attributeString
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
        let timeFormatter = NSDateFormatter()
        timeFormatter.timeStyle = NSDateFormatterStyle.ShortStyle
        
        let date = dateFormatter.stringFromDate((tasks?[indexPath.row].date)!) + "\n" + timeFormatter.stringFromDate((tasks?[indexPath.row].date)!)
        cell.dateLbl.text = date
        
        cell.classLbl.text = task?.associatedClass
        let prio = "Priority: " + String(task!.priority)
        cell.priorityLbl.text = prio
        
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        if(!tasks![indexPath.row].completed!){
        tasks![indexPath.row].completed = true
        }
        else{
           tasks![indexPath.row].completed = false
        }
        taskTable.reloadData()
    }

    
    @IBAction func deleteTasks(sender: AnyObject) {
        if (tasks != nil){
        for task in tasks! {
            if (task.completed!){
                tasks?.removeAtIndex((tasks?.indexOf(task))!)
            }
        }
            let encodedData = NSKeyedArchiver.archivedDataWithRootObject(tasks!)
            
            NSUserDefaults.standardUserDefaults().setObject(encodedData, forKey: "tasks")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        taskTable.reloadData()
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

