//
//  ViewController.swift
//  scheduler-app
//
//  Created by Victoria on 2/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
//import DigitsKit


class ViewController: UIViewController {
    
    var phoneNum: String = ""

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var countryCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if(getUID() != nil){
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func signUpBtnPress(sender: UIButton!) {
        self.performSegueWithIdentifier("toDigits", sender: nil)
        //didTapButton(UIButton)
    }
    
    
    @IBAction func logInBtnPress(sender: AnyObject) {
        if let pNum = phoneNumberField.text where pNum != "", let cc = countryCode.text where cc != "", let pwd = passwordField.text where pwd != "" {
            let phonenumber = "\(cc)\(pNum)"
            let tempphoneNumber = phonenumber.substringFromIndex((phonenumber).startIndex.advancedBy(1))
            let email = "\(tempphoneNumber)@random.com"
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    
                    if error.code == STATUS_ACCOUNT_NONEXIST {
                        self.showErrorAlert("Account does not exist", msg: "Account with specified phone number does not exist. Sign up with this phone number to proceed.")
                    }
                    else{
                        self.showErrorAlert("Could not login", msg: "Please check your phone number or password.")
                    }
                                      
                }
                else {
                    NSUserDefaults.standardUserDefaults().setValue(authData.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                    
                }
            })
            
        }
        else{
            showErrorAlert("Phone number and password required", msg: "You must enter a phone number and a password.")
        }

        
    }

}

extension UIViewController {
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated:true, completion: nil)
    }
    
    func getUID() -> String? {
        if(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil) {
            var userID = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) as! String
            return userID
        }
        else{
            return nil
        }
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}



