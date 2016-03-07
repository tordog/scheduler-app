//
//  CreateGroupVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/7/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class CreateGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelGroupCreate", sender: nil)
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
        return 8
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //return UITableViewCell()
        return tableView.dequeueReusableCellWithIdentifier("AddMemberCell") as! AddMemberCell
    }
    
}
