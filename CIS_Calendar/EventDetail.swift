//
//  EventDetail.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 12/2/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import UIKit
import EventKit
import EventKitUI

class EventDetail: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var eventNameLbl: UILabel!
    @IBOutlet var eventTypeLbl: UILabel!
    @IBOutlet var startDateLbl: UILabel!
    @IBOutlet var endDateLbl: UILabel!
    @IBOutlet var tasksLbl: UILabel!
    @IBOutlet var taskTable: UITableView!
    
    var events: NSMutableArray!
    var index: Int!
    var tasks: [Task]?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
       
        if (NSUserDefaults.standardUserDefaults().objectForKey("tasks") != nil){
            let decoded = NSUserDefaults.standardUserDefaults().objectForKey("tasks") as! NSData
            tasks = NSKeyedUnarchiver.unarchiveObjectWithData(decoded) as? [Task]
            
            for task in tasks!{
                if task.associatedClass != events[index].title{
                    tasks?.removeAtIndex((tasks?.indexOf(task))!)
                }
            }
            
            taskTable.reloadData()
        }

        
        
        eventNameLbl.text = events[index].title
        
        if (events[index].notes == "STC_Class"){
            eventTypeLbl.text = "Event Type: Class"
        }
        else{
            eventTypeLbl.text = "Event Type: Event"
        }
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = NSDateFormatterStyle.FullStyle
        dateFormatter.timeStyle = NSDateFormatterStyle.ShortStyle

        startDateLbl.text = "Starts: " + dateFormatter.stringFromDate(events[index].startDate)
        endDateLbl.text = "Ends:  " + dateFormatter.stringFromDate(events[index].endDate)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (tasks?.count)!
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
        
        
        return cell

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    }

    

}
