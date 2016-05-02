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
    
    var phoneNum: String! = ""
    
    @IBAction func continueBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("beginSignUp", sender: nil)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        //Digits.sharedInstance().logOut()
        didTapButton(UIButton)
    }
    
    

//    @IBOutlet weak var phoneNumTextField: UITextField!
    
//    @IBAction func contBtnPress(sender: AnyObject) {
//        if(phoneNumTextField.text == "") {
//            showErrorAlert("Phone number required", msg: "Please enter a valid phone number")
//        }
//        else {
//            self.performSegueWithIdentifier("beginSignUp", sender: nil)
//        }
//    }
    
    func didTapButton(sender: AnyObject) {
        let digits = Digits.sharedInstance()
        let configuration = DGTAuthenticationConfiguration(accountFields: .DefaultOptionMask)
        configuration.phoneNumber = "+1"
        digits.authenticateWithViewController(nil, configuration: configuration) { session, error in
            // Country selector will be set to US
            if(session != nil){
                self.phoneNum = session.phoneNumber
                self.performSegueWithIdentifier("beginSignUp", sender: nil)
            }
            else {
                print("Error verifying phone number")
            }
            
        }
        

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "beginSignUp"){
            let svc = segue.destinationViewController as! SignUpPageController;
            svc.toPass = phoneNum
        }
 
    
    }
    
}
