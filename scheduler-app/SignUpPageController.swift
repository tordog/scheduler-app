//
//  SignUpPageController.swift
//  scheduler-app
//
//  Created by Victoria on 2/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import DigitsKit

class SignUpPageController: UIViewController {
    
    @IBOutlet weak var lName: UITextField!
    @IBOutlet weak var fName: UITextField!
    @IBOutlet weak var phoneNumber: UILabel!
    var toPass: String!
    @IBOutlet weak var backToLaunchBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        phoneNumber.text=toPass
    }
    
    
    @IBAction func backToLaunchBtnPress(sender: AnyObject) {
        // logout
        //Digits.sharedInstance().logOut()
        self.performSegueWithIdentifier("backToLaunch", sender: nil)
        
    }
    
    @IBAction func createAcctBtnPress(sender: AnyObject) {
    
        let tempphoneNumber1 = phoneNumber.text
        let tempphoneNumber = tempphoneNumber1!.substringFromIndex((phoneNumber.text)!.startIndex.advancedBy(1))
        let email = "\(tempphoneNumber)@random.com"
        if let pwd = passwordField.text where pwd != "" {
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
                            
                            if (error != nil){
                                print(error)
                                self.showErrorAlert("Could not create account", msg: "Please try again with different field entry.")
                            }
                            else {
                                NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
                            
                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {
                                    err, authData in
                                    //let temp = authData.uid as String
                                    let user = ["phone number": self.phoneNumber.text!, "first name": self.fName.text!, "last name": self.lName.text!]
                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
                                    //then, create a separate structure of just phone numbers
                                    let numberRef = DataService.ds.REF_PNUMBERS.childByAppendingPath(self.phoneNumber.text)
                                    let userInfo = ["uid": authData.uid]
                                    numberRef.setValue(userInfo)
                                    
                                })
                                
                                self.performSegueWithIdentifier("goToSyncOptions", sender: nil)
                            }
                            
                        })
                    }
                        
                    else {
                        self.showErrorAlert("Could not log in.", msg: "Please enter valid email / password.")
                    }
                    
                }
                else {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                }
            })
            
        }
        else{
            showErrorAlert("Email and password required", msg: "You must enter an email and a password.")
        }
    }
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }
    
    
    
    
}
