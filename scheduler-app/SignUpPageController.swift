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
    @IBOutlet weak var emailAddress: UITextField!
    
    override func viewDidLoad() {
        phoneNumber.text=toPass
        self.hideKeyboardWhenTappedAround() 
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
    }
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0
    }
    
    
    @IBAction func backToLaunchBtnPress(sender: AnyObject) {
        // logout
        Digits.sharedInstance().logOut()
        self.performSegueWithIdentifier("backToLaunch", sender: nil)
        
    }
    
    //source: http://stackoverflow.com/questions/7123667/is-there-any-way-to-make-a-text-field-entry-must-be-email-in-xcode
    func isValidEmail(email2Test:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let range = email2Test.rangeOfString(emailRegEx, options:.RegularExpressionSearch)
        let result = range != nil ? true : false
        return result
    }
    
    @IBAction func createAcctBtnPress(sender: AnyObject) {
    
        let tempphoneNumber1 = phoneNumber.text
        let tempphoneNumber = tempphoneNumber1!.substringFromIndex((phoneNumber.text)!.startIndex.advancedBy(1))
        let email = "\(tempphoneNumber)@random.com"
        if let emailAddr = emailAddress.text where emailAddr != "" {
            if(isValidEmail(emailAddr)){
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
                                            let user = ["phone number": self.phoneNumber.text!, "first name": self.fName.text!, "last name": self.lName.text!, "email": self.emailAddress.text!]
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
                                self.showErrorAlert("This account already exists!", msg: "Please login to continue with this phone number.")
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
            else {
                showErrorAlert("Valid email required", msg: "Please enter a valid email address")
            }
            
        }
        else {
            showErrorAlert("Valid email required", msg: "Please enter a valid email address")
        }
   }
  
    
}
