//
//  Task.swift
//  CIS_Calendar
//
//  Created by Adrian Moya on 12/3/15.
//  Copyright © 2015 Adrian Moya. All rights reserved.
//

import Foundation

class Task: NSObject, NSCoding {
    var name: String!
    var priority: Int!
    var date: NSDate!
    var associatedClass: String?
    var completed: Bool!
    
    init(name: String, priority: Int, date: NSDate, associatedClass: String, completed: Bool){
        self.name = name
        self.priority = priority
        self.date = date
        self.associatedClass = associatedClass
        self.completed = completed
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObjectForKey("name") as! String
        let priority = aDecoder.decodeIntegerForKey("priority")
        let date = aDecoder.decodeObjectForKey("date") as! NSDate
        let associatedClass = aDecoder.decodeObjectForKey("associatedClass") as! String
        let completed = aDecoder.decodeBoolForKey("completed")
        self.init(name: name, priority: priority, date: date, associatedClass: associatedClass, completed: completed)
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeInteger(priority, forKey: "priority")
        aCoder.encodeObject(name, forKey: "name")
        aCoder.encodeObject(associatedClass, forKey: "associatedClass")
        aCoder.encodeObject(date, forKey: "date")
        aCoder.encodeBool(completed, forKey: "completed")
    }
}
