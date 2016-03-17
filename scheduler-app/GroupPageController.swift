//
//  GroupPageController.swift
//  scheduler-app
//
//  Created by Victoria on 3/6/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import DigitsKit
import Firebase

class GroupPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGroupsText: UILabel!
    
    @IBAction func addBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toCreateGroup", sender: nil)
    }
    
//    @IBAction func logOutBtnPress(sender: AnyObject) {
//        Digits.sharedInstance().logOut()
//        print("logging out!")
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            print(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID))
//        }
//    }
    var randArray = ["Hello", "Torie", "How", "Are", "You"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noGroupsText.text = "No groups to show! Add a group to get started."
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        print("hi")
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(randArray.count)
        return randArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
            print("torie")
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! GroupCell
        
        cell.textLabel?.text = randArray[indexPath.row]
        
        return cell
    }

}