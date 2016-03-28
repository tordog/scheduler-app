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
        

        for (_, uid) in members {
            let ref = Firebase(url:"https://scheduler-base.firebaseio.com/users/\(uid)/groups")
            //TODO: check that uid exists
            //insert group id and admin status to user's groups
            let groupsInfo: Dictionary<String, Bool> = [groupid: false]
            ref.updateChildValues(groupsInfo)
            
        }
        
        let homeRef = Firebase(url: "https://scheduler-base.firebaseio.com")
        if homeRef.authData != nil {
            // user authenticated
            let currUid = homeRef.authData.uid
            print(homeRef.authData.uid)
            //add current user to groups/groupuid/members
            groupMemberInfo[currUid]=false
            //add groupid to users/curruid/groups
            let currentUserRef = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(currUid)/groups")
            let groupInfo: Dictionary<String, Bool> = [groupid: false]
            currentUserRef.updateChildValues(groupInfo)
        } else {
            // No user is signed in
        }
        
        groupRef.updateChildValues(groupMemberInfo)
        
        self.performSegueWithIdentifier("backToGroups", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        members = membersToPass
        memberPhoneNumbers = Array(members.keys)
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
