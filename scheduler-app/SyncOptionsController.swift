//
//  SyncOptionsController.swift
//  scheduler-app
//
//  Created by Victoria on 2/29/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase

class SyncOptionsController: UIViewController {

    @IBOutlet weak var iCalSwitch: UISwitch!
    
    @IBOutlet weak var googleSwitch: UISwitch!
    
    @IBOutlet weak var outlookSwitch: UISwitch!
    
    var userID: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let homeRef = Firebase(url: "https://scheduler-base.firebaseio.com")
        if homeRef.authData != nil {
            // user authenticated
            userID = homeRef.authData.uid
        } else {
            // No user is signed in
        }
    }
    
    @IBAction func iCalSwitch(sender: AnyObject) {
        if(iCalSwitch.on){
            print("switch is on")
        }
        else {
            print("switch is off")
        }
    }
    
    @IBAction func googleSwitch(sender: AnyObject) {
        showErrorAlert("Google Calendar Sync", msg: "Oops! This functionality is not yet available. It is coming soon.")
        googleSwitch.setOn(false, animated: true)
    }

    @IBAction func outlookSwitch(sender: AnyObject) {
        showErrorAlert("Microsoft Outlook Sync", msg: "Oops! This functionality is not yet available. It is coming soon.")
        outlookSwitch.setOn(false, animated: true)
    }
    
    
    @IBAction func continueBtnPress(sender: AnyObject) {
        //set users/userID/iCal: true
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(userID)/calendars")
        
        if(iCalSwitch.on){
            let iCalRef = ref.childByAppendingPath("iCal")
            iCalRef.setValue(true)
        }
        
        self.performSegueWithIdentifier("processSyncs", sender: nil)
        
//TO CHECK IF IT's T/F..
//        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
//            if let iCal = snapshot.value["iCal"] as? Bool {
//                if(iCal == true){
//                    print("iCal Btn is True")
//                }
//                else {
//                    print("iCal btn is false")
//                }
//            }
//        })
        
        
        //self.performSegueWithIdentifier("toHome", sender: nil)
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }
}
