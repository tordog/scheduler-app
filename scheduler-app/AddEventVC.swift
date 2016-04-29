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
    var numSectionsToPass: Int = 0
    var nSec: Int = 0

    @IBAction func saveBtnPress(sender: AnyObject) {
        //do a bunch of checks -- is everything non-empty?
        if(eventTitle.text == ""){
            showErrorAlert("Event Title required", msg: "Please enter an event title")
        }
        else if(eventDescription.text == ""){
            showErrorAlert("Event description required", msg: "Please enter an event description")
        }
        else if(location.text == ""){
            showErrorAlert("Event location required", msg: "Please enter an event location")
        }
        else if eventStart.date.compare(eventEnd.date) == NSComparisonResult.OrderedDescending {
            showErrorAlert("Error", msg: "Event Start occurs after Event End")
        }
        else {
            print("Valid entries, connecting to Firebase")
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
            
            print("Firebase being called....")
            //add this information to Firebase!
            let ref = Firebase(url:"https://scheduler-base.firebaseio.com/groups/\(groupID)/\(startDate)/events")
            let event = ref.childByAutoId()
            let eventID = event.key
            let eventInfo: Dictionary<String, String> = ["title": eventTitle.text!, "description": eventDescription.text, "startDate": startDate, "endDate": endDate, "numSlots": numSlots.text!, "eventID": eventID, "startTime": startTime, "endTime": endTime, "location": location.text!]
            let moreInfo: Dictionary<String, Double> = ["startTime24": date24ToDouble!]
            event.updateChildValues(eventInfo)
            event.updateChildValues(moreInfo)
            
            var numChildren: Int = 0
            
            
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                numChildren = Int(snapshot.childrenCount)
                
               
                let ref0 = Firebase(url:"https://scheduler-base.firebaseio.com/groups/\(self.groupID)")
                let numRef = ref0.childByAppendingPath("numChildren")
                numRef.setValue(numChildren)
                
                
            
                ref0.observeSingleEventOfType(.Value, withBlock: { snapshot in
                    
                    print(snapshot)
                    
                    print("HI!")
                    
                    if let k = snapshot.value["highestNum"] {
                       
                        if (Int(k as! NSNumber) <= numChildren){
                        
                            let numRef = ref0.childByAppendingPath("highestNum")
                            numRef.setValue(numChildren)
                            self.nSec = numChildren
                            self.performSegueWithIdentifier("backToCalendar", sender: nil)
                        }
                        else{
                            
                            self.performSegueWithIdentifier("backToCalendar", sender: nil)
                        }
                    }
                    else {
                       
                        self.performSegueWithIdentifier("backToCalendar", sender: nil)
                    }
                    
                    
                    
                })
             
            })
        
            
            
        }
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
    
    @IBOutlet weak var location: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupID = groupIDToPass
        nSec = numSectionsToPass
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
            svc.numSectionsToPass = nSec
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
