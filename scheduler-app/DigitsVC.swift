//
//  DigitsVC.swift
//  scheduler-app
//
//  Created by Victoria on 4/21/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import DigitsKit

class DigitsVC: UIViewController {

    @IBOutlet weak var phoneNumTextField: UITextField!
    
    @IBAction func contBtnPress(sender: AnyObject) {
        if(phoneNumTextField.text == "") {
            showErrorAlert("Phone number required", msg: "Please enter a valid phone number")
        }
        else {
            self.performSegueWithIdentifier("beginSignUp", sender: nil)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "beginSignUp"){
            let svc = segue.destinationViewController as! SignUpPageController;
            svc.toPass = phoneNumTextField.text
        }
 
    
    }
    
}
