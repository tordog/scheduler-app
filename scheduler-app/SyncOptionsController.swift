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
    
    var uid: String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        uid = getUID()
        if uid == nil{
            showErrorAlert("No user logged in", msg: "Please log in to continue")
        }
        
    }

    @IBAction func outlookSwitch(sender: AnyObject) {
        showErrorAlert("Microsoft Outlook Sync", msg: "Oops! This functionality is not yet available. It is coming soon.")
        outlookSwitch.setOn(false, animated: true)
    }
    
    
    @IBAction func continueBtnPress(sender: AnyObject) {
        //set users/userID/iCal: true
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(uid)/calendars")
        let iCalRef = ref.childByAppendingPath("iCal")
        
        if(iCalSwitch.on){
            iCalRef.setValue(true)
        }
        else {
            iCalRef.setValue(false)
        }
        
        let googleRef = ref.childByAppendingPath("googleSync")
        if(googleSwitch.on){
            googleRef.setValue(true)
        }
        else {
            googleRef.setValue(false)
        }
        
        self.performSegueWithIdentifier("processSyncs", sender: nil)
        
        
        //self.performSegueWithIdentifier("toHome", sender: nil)
    }
    
}
