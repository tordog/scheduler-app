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
    @IBOutlet weak var countryCode: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
//    func showErrorAlert(title: String, msg: String) {
//        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
//        let action = UIAlertAction(title: "Ok", style: .Default, handler: nil)
//        alert.addAction(action)
//        presentViewController(alert, animated:true, completion: nil)
//    }
    
    
//    func didTapButton(sender: AnyObject) {
//        let digits = Digits.sharedInstance()
//        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
//        configuration.phoneNumber = "+1"
//        digits.authenticateWithViewController(nil, configuration: configuration) { session, error in
//            // Country selector will be set to US
//            if(session != nil){
//                self.phoneNum = session.phoneNumber
//                self.signUpBtn.setTitle("Continue", forState: .Normal)
//                self.performSegueWithIdentifier("beginSignUp", sender: nil)
//                print("successful number verification")
//                print("number: \(session.phoneNumber)")
//            }
//            else {
//                print("Error verifying phone number")
//            }
//            
//        }
//        
//
//    }

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
}



