//
//  GroupPageController.swift
//  scheduler-app
//
//  Created by Victoria on 3/6/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class GroupPageController: UIViewController {
    @IBAction func addBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toCreateGroup", sender: nil)
    }
}