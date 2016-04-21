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
        
        if(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil){
            userID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
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
        let iCalRef = ref.childByAppendingPath("iCal")
        
        if(iCalSwitch.on){
            iCalRef.setValue(true)
        }
        else {
            iCalRef.setValue(false)
        }
        
        self.performSegueWithIdentifier("processSyncs", sender: nil)
        
        
        //self.performSegueWithIdentifier("toHome", sender: nil)
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }
}
