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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            
        }
    }

}

