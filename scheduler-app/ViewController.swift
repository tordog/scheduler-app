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

    @IBOutlet weak var signUpBtn: UIButton!
    
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

