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
    @IBOutlet var dateLbl: UILabel!
    @IBOutlet var tasksLbl: UILabel!
    var events: NSMutableArray!
    var index: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
       eventNameLbl.text = events[index].title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
