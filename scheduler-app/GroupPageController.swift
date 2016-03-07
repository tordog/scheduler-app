//
//  GroupPageController.swift
//  scheduler-app
//
//  Created by Victoria on 3/6/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class GroupPageController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noGroupsText: UILabel!
    
    @IBAction func addBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toCreateGroup", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        noGroupsText.text = "No groups to show! Add a group to get started."
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //return UITableViewCell()
        return tableView.dequeueReusableCellWithIdentifier("GroupCell") as! GroupCell
    }

}