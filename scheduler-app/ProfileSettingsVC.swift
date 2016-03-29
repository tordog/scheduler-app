//
//  ProfileSettingsVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/28/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class ProfileSettingsVC: UIViewController {
    @IBAction func backBtnPress(sender: UIButton!) {
        self.performSegueWithIdentifier("backToHome", sender: nil)
    }

}
