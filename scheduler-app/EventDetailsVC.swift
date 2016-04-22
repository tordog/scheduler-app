//
//  EventDetailsVC.swift
//  scheduler-app
//
//  Created by Victoria on 4/3/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class EventDetailsVC: UIViewController {
    
    @IBOutlet weak var btnOutlet: UIButton!
    let eventStore = EKEventStore()
    
    var eventIDToPass: String = ""
    var eventID: String = ""
    var dateToPass: String = ""
    var groupIDToPass: String = ""
    var groupID: String = ""
    var date: String = ""
    var statusToPass: String = ""
    var status: String = ""
    var numSectionsToPass: Int = 0
    var nSec: Int = 0
    var eTitle: String = ""
    var eDescription: String = ""
    var sTime: String = ""
    var edTime: String = ""
    var eventStart = NSDate()
    var eventEnd = NSDate()

    override func viewDidLoad() {
        super.viewDidLoad()
        eventID = eventIDToPass
        groupID = groupIDToPass
        date = dateToPass
        status = statusToPass
        nSec = numSectionsToPass
        if(status == "true"){
            btnOutlet.setTitle("Cancel", forState: UIControlState.Normal)
            btnOutlet.backgroundColor = UIColor(red: 0.9, green: 0.2, blue: 0.2, alpha: 1.0)
        }
        //get Firebase ref
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)/\(date)/events/\(eventID)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let title = snapshot.value["title"]{
                self.eventTitle.text = title as? String
                self.eTitle = title as! String
            }
            
            if let startTime = snapshot.value["startTime"]{
                if let endTime = snapshot.value["endTime"] {
                    self.whenLabel.text = "\(startTime!) to \(endTime!)"
                    self.sTime = startTime as! String
                    self.edTime = endTime as! String
                }
            }
            if let nSlots = snapshot.value["numSlots"]{
                self.numSlots.text = nSlots as? String
            }
            if let desc = snapshot.value["description"]{
                self.eventDescription.text = desc as? String
                self.eDescription = desc as! String
            }
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd hh:mm a"
            if let startDate = snapshot.value["startDate"] {
                let dateConcat = ("\(startDate!) \(self.sTime)")
                self.eventStart = dateFormatter.dateFromString(dateConcat)!
            }
            if let endDate = snapshot.value["endDate"] {
                let dateConcat = ("\(endDate!) \(self.edTime)")
                self.eventEnd = dateFormatter.dateFromString(dateConcat)!
                
            }
            }, withCancelBlock: { error in
                print(error.description)
        })
        // Do any additional setup after loading the view.
    }
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var whenLabel: UILabel!
    @IBOutlet weak var numSlots: UILabel!
    @IBOutlet weak var eventDescription: UILabel!

    @IBAction func backBtnpress(sender: AnyObject) {
        //accept position, which means we need even more nested things. but to easily display, it should be associated with user id.
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    @IBAction func confirmBtnPress(sender: AnyObject) {
        
        let homeRef = Firebase(url: "https://scheduler-base.firebaseio.com")
        var userID = ""
        if homeRef.authData != nil {
            // user authenticated
            userID = homeRef.authData.uid
            print(userID)
        } else {
            // No user is signed in
        }
        
        //update Num Slots!
        let ref2 = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)/\(date)/events/\(eventID)")
        ref2.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let numSlots = snapshot.value["numSlots"] {
                let str = numSlots as! String
                print(str)
                var newNum = Int(str)!
                if(self.status == "false"){
                    newNum = newNum - 1
                }
                else {
                    newNum = newNum + 1
                }
                if newNum < 0 {
                    self.showErrorAlert("No slots available", msg: "All the slots for this event are already filled!")
                }
                else {
                    
                    
                    let numToStr = String(newNum)
                    ref2.childByAppendingPath("numSlots").setValue(numToStr)
                    
                    
                    if(self.status == "false"){
                        
                        if(self.checkCalendarAuthorizationStatus()) {
                            // Create Event
    
                            var event = EKEvent(eventStore: self.eventStore)
                            
                            event.title = self.eTitle
                            event.startDate = self.eventStart
                            event.endDate = self.eventEnd
                            //get default calendar: http://stackoverflow.com/questions/28379603/how-to-add-an-event-in-the-device-calendar-using-swift
                            event.calendar = self.eventStore.defaultCalendarForNewEvents
                            
                            self.insertEvent(self.eventStore, event: event)
   
                        }
                    
                        let ref3 = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(userID)/\(self.groupID)/events/\(self.eventID)")
                        ref3.observeEventType(.Value, withBlock: { snapshot in
                        
                            if snapshot.value is NSNull {
                                var updateSignUps = ref2.childByAppendingPath("signups")
                                updateSignUps.updateChildValues([userID: true])
                                
                                
                                let ref4 = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(userID)/\(self.groupID)/events")
                                //add eventID: true
                                var infoToAdd = [self.eventID: true]
                                ref4.updateChildValues(infoToAdd)
                                self.performSegueWithIdentifier("backToCalendar", sender: nil)
                            } else {
                                self.showErrorAlert("Alert", msg: "You have already signed up for this time slot!")
                            }
                        
                        })
                    }
                    else {
                        
//                        var startDate=NSDate().dateByAddingTimeInterval(-60*60*24)
//                        var endDate=NSDate().dateByAddingTimeInterval(60*60*24*3)
//                        var predicate2 = eventStore.predicateForEventsWithStartDate(startDate, endDate: endDate, calendars: nil)
//                        
//                        println("startDate:\(startDate) endDate:\(endDate)")
//                        var eV = eventStore.eventsMatchingPredicate(predicate2) as [EKEvent]!
//                        
//                        if eV != nil {
//                            for i in eV {
//                                println("Title  \(i.title)" )
//                                println("stareDate: \(i.startDate)" )
//                                println("endDate: \(i.endDate)" )
//                                
//                                if i.title == "Test Title" {
//                                    println("YES" )
//                                    // Uncomment if you want to delete
//                                    //eventStore.removeEvent(i, span: EKSpanThisEvent, error: nil)
//                                }
//                            }
//                        }
                        
                        let ref3 = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(userID)/\(self.groupID)/events/\(self.eventID)")
                        //DELETE ROW!!!!
                        ref3.removeAllObservers()
                        ref3.removeValue()
                        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(self.groupID)/\(self.date)/events/\(self.eventID)/signups/\(userID)")
                        ref.removeAllObservers()
                        ref.removeValue()
                        self.performSegueWithIdentifier("backToCalendar", sender: nil)
                    }
                    
                    
                }
            }
        })


        
    }
    
    func checkCalendarAuthorizationStatus() -> Bool {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            return requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            print("Already authorized")
            return true
            
        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            self.showErrorAlert("Access denied", msg: "TimeSlots cannot sync to iCal without access to your calendar")
            return false
        }
        
    }
    
    func requestAccessToCalendar() -> Bool {
        var state = false
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                print("Access granted")
                state=true
                
            } else {
                self.showErrorAlert("Access denied", msg: "TimeSlots cannot sync to iCal without access to your calendar")
                
            }
        })
        return state
    }
    
    
    //add event tutorial: http://www.ioscreator.com/tutorials/add-event-calendar-tutorial-ios8-swift
    //fixes for swift 2: http://stackoverflow.com/questions/31894019/xcode7-ios9-use-of-unresolved-identifier-ekspanthisevent
    
    func insertEvent(store: EKEventStore, event: EKEvent) {
        // 1
        let calendars = store.calendarsForEntityType(EKEntityType.Event)
        
        do {
            try store.saveEvent(event, span: .ThisEvent)
            print("Event has saved succesfully into calendar")
        } catch let specError as NSError {
            print("A specific error occurred: \(specError)")
        } catch {
            print("An error occurred")
        }
        
    }
    
    func deleteEvent(store: EKEventStore, event: EKEvent) {
        
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
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
