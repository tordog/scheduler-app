//
//  ViewController.swift
//  scheduler-app
//
//  Created by Victoria on 2/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import DigitsKit


class ViewController: UIViewController {
    
    var phoneNum: String = ""

    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "beginSignUp"){
            let svc = segue.destinationViewController as! SignUpPageController;
            svc.toPass = phoneNum
        }
    }

    @IBAction func signUpBtnPress(sender: UIButton!) {
        didTapButton(UIButton)
    }
    @IBAction func logInBtnPress(sender: AnyObject) {
        if let pNum = phoneNumberField.text where pNum != "", let pwd = passwordField.text where pwd != "" {
            let tempphoneNumber = pNum.substringFromIndex((pNum).startIndex.advancedBy(1))
            let email = "\(tempphoneNumber)@random.com"
            print(email)
            
            DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: { error, authData in
                
                if error != nil {
                    
                    print(error)
                    
//                    if error.code == STATUS_ACCOUNT_NONEXIST {
//                        DataService.ds.REF_BASE.createUser(email, password: pwd, withValueCompletionBlock: { error, result in
//                            
//                            if (error != nil){
//                                print(error)
//                                self.showErrorAlert("Could not create account", msg: "Please try again with different field entry.")
//                            }
//                            else {
//                                NSUserDefaults.standardUserDefaults().setValue(result["uid"], forKey: "uid")
//                                
//                                DataService.ds.REF_BASE.authUser(email, password: pwd, withCompletionBlock: {
//                                    err, authData in
//                                    let user = ["phone number": self.phoneNumber.text!]
//                                    DataService.ds.createFirebaseUser(authData.uid, user: user)
//                                })
//                                
//                                self.performSegueWithIdentifier("goToSyncOptions", sender: nil)
//                            }
//                            
//                        })
//                    }
//                        
//                    else {
//                        self.showErrorAlert("Could not log in.", msg: "Please enter valid email / password.")
//                    }
//                    
                }
                else {
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
    
    @IBAction func logOutBtnPress(sender: AnyObject) {
        Digits.sharedInstance().logOut()
    }
    
    func didTapButton(sender: AnyObject) {
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.phoneNumber = "+1"
        digits.authenticateWithViewController(nil, configuration: configuration) { session, error in
            // Country selector will be set to US
            if(session != nil){
                print("Why does this not print too?")
                self.phoneNum = session.phoneNumber
                self.signUpBtn.setTitle("Continue", forState: .Normal)
                self.performSegueWithIdentifier("beginSignUp", sender: nil)
                print("successful number verification")
                print("number: \(session.phoneNumber)")
            }
            else {
                print("Error verifying phone number")
            }
            
        }
        

    }

}

