//
//  SyncOptionsController.swift
//  scheduler-app
//
//  Created by Victoria on 2/29/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class SyncOptionsController: UIViewController {

    @IBAction func continueBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toHome", sender: nil)
    }
}
