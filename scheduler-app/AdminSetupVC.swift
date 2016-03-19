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
        //newGroup.setValue(nameToPass)
        let groupid = newGroup.key
        let groupNameInfo: Dictionary<String, String> = ["groupName": nameToPass]
        newGroup.updateChildValues(groupNameInfo)
        //add members
        let groupRef = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupid)/members")
        var groupMemberInfo = Dictionary<String, Bool>()
        for (_, uid) in members {
            //add uid to group
            groupMemberInfo[uid] = false
        }
        groupRef.updateChildValues(groupMemberInfo)

        for (_, uid) in members {
            //get uid
            let ref = Firebase(url:"https://scheduler-base.firebaseio.com/users/\(uid)/groups")
            //TODO: check that uid exists
            var groupInfo: Dictionary<String, Bool> = [groupid: false]
            ref.updateChildValues(groupInfo)
            
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
