//
//  ProfileSettingsVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase
import EventKit

class ProfileSettingsVC: UIViewController {
    
    
    let eventStore = EKEventStore()
    
    @IBAction func backBtnPress(sender: UIButton!) {
        self.performSegueWithIdentifier("backToHome", sender: nil)
    }

    @IBAction func deleteAcctBtnPress(sender: AnyObject) {
        
        // Create the alert controller
        var alertController = UIAlertController(title: "Are you sure?", message: "Deleting your account is permanent. Are you sure you wish to proceed?", preferredStyle: .Alert)
        
        // Create the actions
        var okAction = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) {
            UIAlertAction in
            print("Delete acct")
        }
        var cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel) {
            UIAlertAction in
            print("Cancel Pressed")
        }
        
        // Add the actions
        alertController.addAction(okAction)
        alertController.addAction(cancelAction)
        
        // Present the controller
        self.presentViewController(alertController, animated: true, completion: nil)
        
    }
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var lastName: UILabel!
    @IBOutlet weak var phoneNum: UILabel!
    @IBOutlet weak var iCalSwitch: UISwitch!
    @IBOutlet weak var googleSwitch: UISwitch!
    
    var userID: String! = ""
    
    @IBAction func saveBtnPress(sender: AnyObject) {
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(userID)/calendars")
        let iCalRef = ref.childByAppendingPath("iCal")

        if(iCalSwitch.on){
            iCalRef.setValue(true)
            self.checkCalendarAuthorizationStatus()
        }
        else {
            iCalRef.setValue(false)
        }
        
        let googleRef = ref.childByAppendingPath("googleSync")
        if(googleSwitch.on){
            googleRef.setValue(true)
            self.performSegueWithIdentifier("toGoogle", sender: nil)
        }
        else {
            googleRef.setValue(false)
            self.performSegueWithIdentifier("backToHome", sender: nil)
        }
        
        
    }
    
    override func viewDidLoad() {
        userID = getUID()
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(userID)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let fName = snapshot.value["first name"] {
                self.firstName.text = fName as? String
            }
            if let lName = snapshot.value["last name"] {
                self.lastName.text = lName as? String
            }
            if let pNum = snapshot.value["phone number"] {
                self.phoneNum.text=pNum as? String
            }
        })
        
        let ref2 = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(userID)/calendars")
        ref2.observeEventType(.Value, withBlock: { snapshot in
            if let iCal = snapshot.value["iCal"] as? Bool {
                if(iCal == true) {
                    self.iCalSwitch.setOn(true, animated: true)
                }
            }
            if let google = snapshot.value["googleSync"] as? Bool {
                if(google == true) {
                    self.googleSwitch.setOn(true, animated: true)
                }
            }
            
        })
        
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
                
            } else {
                self.showErrorAlert("Access denied", msg: "TimeSlots cannot sync to iCal without access to your calendar")
                
            }
        })
    }

    
    
    
}
