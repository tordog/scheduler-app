//
//  EventKitController.swift
//  scheduler-app
//
//  Created by Victoria on 4/20/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import EventKit
import Firebase

//EventKit tutorial source: https://github.com/andrewcbancroft/EventTracker/blob/ask-for-permission/EventTracker/ViewController.swift

class EventKitController: UIViewController {
    
    let eventStore = EKEventStore()
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil) {
            userID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
        }
        
    }

    override func viewWillAppear(animated: Bool) {
            let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(userID)/calendars")
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if let iCal = snapshot.value["iCal"] as? Bool {
                    if(iCal == true){
                        print("iCal Btn is True")
                        self.checkCalendarAuthorizationStatus()
                    }
                }
            })
        
    }

    @IBAction func continueBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toHome", sender: nil)
    }
    
    func checkCalendarAuthorizationStatus() {
        let status = EKEventStore.authorizationStatusForEntityType(EKEntityType.Event)
        
        switch (status) {
        case EKAuthorizationStatus.NotDetermined:
            // This happens on first-run
            requestAccessToCalendar()
        case EKAuthorizationStatus.Authorized:
            print("Already authorized")

        case EKAuthorizationStatus.Restricted, EKAuthorizationStatus.Denied:
            self.showErrorAlert("Access denied", msg: "TimeSlots cannot sync to iCal without access to your calendar")
        }
        
    }
    
    func requestAccessToCalendar() {
        eventStore.requestAccessToEntityType(EKEntityType.Event, completion: {
            (accessGranted: Bool, error: NSError?) in
            
            if accessGranted == true {
                print("Access granted")

            } else {
                self.showErrorAlert("Access denied", msg: "TimeSlots cannot sync to iCal without access to your calendar")

            }
        })
    }
    
    
    //add event tutorial: http://www.ioscreator.com/tutorials/add-event-calendar-tutorial-ios8-swift
    //fixes for swift 2: http://stackoverflow.com/questions/31894019/xcode7-ios9-use-of-unresolved-identifier-ekspanthisevent
    
    func insertEvent(store: EKEventStore) {
        // 1
        let calendars = store.calendarsForEntityType(EKEntityType.Event)

        
        let startDate = NSDate()
        // 2 hours
        let endDate = startDate.dateByAddingTimeInterval(2 * 60 * 60)
        

        // Create Event
        var event = EKEvent(eventStore: store)

        event.title = "New Meeting"
        event.startDate = startDate
        event.endDate = endDate
        //get default calendar: http://stackoverflow.com/questions/28379603/how-to-add-an-event-in-the-device-calendar-using-swift
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // 5
        // Save Event in Calendar
        
        do {
            try store.saveEvent(event, span: .ThisEvent)
            print("It worked??")
        } catch let specError as NSError {
            print("A specific error occurred: \(specError)")
        } catch {
            print("An error occurred")
        }
        
    }
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }
    
}