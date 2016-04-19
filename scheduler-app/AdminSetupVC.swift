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
    
    var adminStatus = [String: Bool]()
    
    var currentUID: String = ""
    var currentPhoneNum: String = ""
    
    
    @IBAction func saveBtnPress(sender: AnyObject) {
        //save group to Groups
        let newGroup = DataService.ds.REF_GROUPS.childByAutoId()
        let groupid = newGroup.key
        let groupNameInfo: Dictionary<String, AnyObject> = ["groupName": nameToPass, "highestNum": 0]
        newGroup.updateChildValues(groupNameInfo)
        //add members
        let groupRef = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupid)/members")
        var groupMemberInfo = Dictionary<String, Bool>()
        //add all member uids to groupid/members
        for (_, uid) in members {
            groupMemberInfo[uid] = adminStatus[uid]
        }
        
        //add group id to user's DB
        for (_, uid) in members {
            let ref = Firebase(url:"https://scheduler-base.firebaseio.com/users/\(uid)/groups")
            //TODO: check that uid exists
            //insert group id and admin status to user's groups
            let groupsInfo: Dictionary<String, Bool> = [groupid: adminStatus[uid]!]
            ref.updateChildValues(groupsInfo)
            
        }
        
        groupRef.updateChildValues(groupMemberInfo)
        
        self.performSegueWithIdentifier("backToGroups", sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrUid()
        members = membersToPass
        memberPhoneNumbers = Array(members.keys)
        tableView.delegate = self
        tableView.dataSource = self
        print("Initializing adminStatus")
        for(_, uid) in members {
            adminStatus[uid] = false
        }
        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(self.currentUID)/phone%20number")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if !snapshot.exists() {
                print("Error")
            } else {
                self.currentPhoneNum = snapshot.value as! String
                self.members[self.currentPhoneNum] = self.currentUID
                self.memberPhoneNumbers.append(self.currentPhoneNum)
                self.adminStatus[self.currentUID]=true
                self.tableView.reloadData()
            }
        })

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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        let phoneNum = currentCell.textLabel!.text!
        
        let aString: String = phoneNum
        let newString = aString.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        let ref = Firebase(url:"https://scheduler-base.firebaseio.com/phonenumbers/\(newString)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if !snapshot.exists() {
                print("Error, this phone number does not exist")
            } else {
                //get user's uid
                if let addUID = snapshot.value["uid"] {
                    let addUID = addUID as! String
                    if (self.adminStatus[addUID] == true) {
                        self.adminStatus[addUID] = false
                        let cellBGView = UIView()
                        cellBGView.backgroundColor = UIColor.clearColor()
                        currentCell.selectedBackgroundView = cellBGView
                        //view.backgroundColor = UIColor.clearColor()
                    }
                    else{
                        self.adminStatus[addUID] = true
                        let cellBGView = UIView()
                        cellBGView.backgroundColor = UIColor.lightGrayColor()
                        currentCell.selectedBackgroundView = cellBGView
                        //view.backgroundColor = UIColor.blueColor()
                    }
                    
                }
                else {
                    print("Internal error. UID does not exist for this phone number")
                }
            }
            }, withCancelBlock: { error in
                print(error.description)
        })

        
            }
    
    func getCurrUid() {
        let homeRef = Firebase(url: "https://scheduler-base.firebaseio.com")
        if homeRef.authData != nil {
            // user authenticated
            let currUid = homeRef.authData.uid
            self.currentUID = currUid
        } else {
            // No user is signed in
        }
    }
    
}
