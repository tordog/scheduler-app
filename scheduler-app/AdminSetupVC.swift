//
//  AdminSetupVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/7/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase

class AdminSetupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var membersToPass = [String: String]()
    var nameToPass: String!
    var memberPhoneNumbers: [String] = []
    var members = [String: String]()
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func saveBtnPress(sender: AnyObject) {
        //save group to Groups
        let newGroup = DataService.ds.REF_GROUPS.childByAutoId()
        newGroup.setValue(nameToPass)
        //save group to user
        let ref = Firebase(url:"https://scheduler-base.firebaseio.com/users")
        //this is unnecessary, just loop through our members and find users/uid, then add groupuid: false to groups. (admin)
        for member in members {
            ref.observeEventType(.ChildAdded, withBlock: { snapshot in
                if member == snapshot.value["phone number"] as! String {
                    print("found member \(member)")
                }
            }, withCancelBlock: { error in
                print(error.description)
            })
        }
        
        self.performSegueWithIdentifier("backToGroups", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        members = membersToPass
        memberPhoneNumbers = Array(members.keys)
        print(members)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("selectAdmin") as! listMembersSelectAdmin
        cell.textLabel?.text = memberPhoneNumbers[indexPath.row]
        return cell
    }

}
