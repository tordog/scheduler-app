//
//  EventDetailsVC.swift
//  scheduler-app
//
//  Created by Victoria on 4/3/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase

class EventDetailsVC: UIViewController {
    
    var eventIDToPass: String = ""
    var eventID: String = ""
    var dateToPass: String = ""
    var groupIDToPass: String = ""
    var groupID: String = ""
    var date: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        eventID = eventIDToPass
        groupID = groupIDToPass
        date = dateToPass
        //get Firebase ref
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)/\(date)/events/\(eventID)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let title = snapshot.value["title"]{
                self.eventTitle.text = title as? String
            }
            if let startTime = snapshot.value["startTime"]{
                if let endTime = snapshot.value["endTime"] {
                    self.whenLabel.text = "\(startTime!) to \(endTime!)"
                }
            }
            if let nSlots = snapshot.value["numSlots"]{
                self.numSlots.text = nSlots as? String
            }
            if let desc = snapshot.value["description"]{
                self.eventDescription.text = desc as? String
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
                let newNum = Int(str)! - 1
                print(newNum)
                if newNum < 0 {
                    self.showErrorAlert("No slots available", msg: "All the slots for this event are already filled!")
                }
                else {
                    
                    
                    let ref3 = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(userID)/\(self.groupID)/events/\(self.eventID)")
                    ref3.observeEventType(.Value, withBlock: { snapshot in
                        if snapshot.value is NSNull {
                            print("This path was null! So user has not yet signed up.")
                            let numToStr = String(newNum)
                            ref2.childByAppendingPath("numSlots").setValue(numToStr)
                            
                            let ref4 = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(userID)/\(self.groupID)/events")
                            //add eventID: true
                            var infoToAdd = [self.eventID: true]
                            ref4.updateChildValues(infoToAdd)
                            self.performSegueWithIdentifier("backToCalendar", sender: nil)
                        } else {
                            print("This path exists")
                            print(snapshot.value)
                            self.showErrorAlert("Alert", msg: "You have already signed up for this time slot!")
                        }
                    })
                    
                    
                }
            }
        })

        
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
