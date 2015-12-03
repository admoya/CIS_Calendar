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

class EventDetail: UIViewController {

    @IBOutlet var eventNameLbl: UILabel!
    @IBOutlet var eventTypeLbl: UILabel!
    @IBOutlet var startDateLbl: UILabel!
    @IBOutlet var endDateLbl: UILabel!
    @IBOutlet var tasksLbl: UILabel!
    var events: NSMutableArray!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
