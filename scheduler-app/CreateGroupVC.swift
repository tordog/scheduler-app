//
//  CreateGroupVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/7/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var members: [String] = []
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var phoneNumberToAdd: UISearchBar!
    
    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelGroupCreate", sender: nil)
    }
    
    @IBAction func addMember(sender: AnyObject) {
        //check that this number is in our database!
        //retrieve the userID
        //add userID to array
        //add phone number to list
        members.append((phoneNumberToAdd.text)!)
        phoneNumberToAdd.text = ""
    }
    
    @IBAction func createGroupBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toAdminSetup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //return UITableViewCell()
        return tableView.dequeueReusableCellWithIdentifier("AddMemberCell") as! AddMemberCell
    }
    
}
