//
//  AddEventVC.swift
//  scheduler-app
//
//  Created by Victoria on 4/3/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase

class AddEventVC: UIViewController {
    
    var groupIDToPass: String = ""
    var groupID: String = ""

    @IBAction func saveBtnPress(sender: AnyObject) {
        //do a bunch of checks -- is everything non-empty? 
        if(eventTitle.text == ""){
            print("Pls enter a title")
        }
        else if(eventDescription.text == ""){
            print("Enter description")
        }
        else if eventStart.date.compare(eventEnd.date) == NSComparisonResult.OrderedDescending {
            print("Error, start date is after end date")
        }
        else {
            let dateFormatter = NSDateFormatter()
            let timeFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            timeFormatter.dateFormat = "hh:mm a"
            let startDate = dateFormatter.stringFromDate(eventStart.date) // "2015-11-10 09:44 PM"
            let endDate = dateFormatter.stringFromDate(eventEnd.date)
            let startTime = timeFormatter.stringFromDate(eventStart.date)
            let endTime = timeFormatter.stringFromDate(eventEnd.date)
            
            //source: http://stackoverflow.com/questions/29321947/xcode-swift-am-pm-time-to-24-hour-format
            let militaryDateFormatter = NSDateFormatter()
            militaryDateFormatter.dateFormat = "HH:mm"
            let date24 = militaryDateFormatter.stringFromDate(eventStart.date)
            //String replacement source: http://stackoverflow.com/questions/24200888/any-way-to-replace-characters-on-swift-string
            let modDate24 = date24.stringByReplacingOccurrencesOfString(":", withString: ".")
            let date24ToDouble = Double(modDate24)
            
            //add this information to Firebase!
            let ref = Firebase(url:"https://scheduler-base.firebaseio.com/groups/\(groupID)/\(startDate)/events")
            let event = ref.childByAutoId()
            let eventID = event.key
            let eventInfo: Dictionary<String, String> = ["title": eventTitle.text!, "description": eventDescription.text, "startDate": startDate, "endDate": endDate, "numSlots": numSlots.text!, "eventID": eventID, "startTime": startTime, "endTime": endTime]
            let moreInfo: Dictionary<String, Double> = ["startTime24": date24ToDouble!]
            event.updateChildValues(eventInfo)
            event.updateChildValues(moreInfo)
            
            //extract start date & end date & format into proper string (for Firebase use)
            //extract start time & end time (make sure start time < end time if start date == end date
            
        }
        
        
        //save everything to firebase!
        //under GroupID which I haven't passed yet. ugh no you have to CREATE IT YOU ID
        //should be under groups/groupID/events/date..
        //title, startTime, endTime, description, numSlots
        
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
    }
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var eventStart: UIDatePicker!
    
    @IBOutlet weak var eventEnd: UIDatePicker!
    
    @IBOutlet weak var numSlots: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperAction(sender: AnyObject) {
        numSlots.text = "\(Int(stepper.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupID = groupIDToPass
        print(groupID)
        let today = NSDate()
        let endDate = today.dateByAddingTimeInterval(14*60*60*24);
        eventStart.minimumDate = today
        eventStart.maximumDate = endDate
        eventEnd.minimumDate = today
        eventEnd.maximumDate = endDate
        // Do any additional setup after loading the view.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToCalendar"){
            let svc = segue.destinationViewController as! CollectionViewController;
            svc.groupIDToPass = groupID
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
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
