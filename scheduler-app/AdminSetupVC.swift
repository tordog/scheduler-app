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
    
    var currentUID: String? = ""
    var currentPhoneNum: String = ""
    
    
    @IBAction func saveBtnPress(sender: AnyObject) {
        //make sure there is at least 1 admin
        var adminFlag = false
        for (_,value) in adminStatus {
            if (value == true) {
                adminFlag = true
                break
            }
        }
        if(adminFlag == false){
            showErrorAlert("Admin Required", msg: "At least one admin is required per group. Please select a member to serve as admin of this group.")
        }
        else {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUID = getUID()!
        if(self.currentUID != nil){
            members = membersToPass
            memberPhoneNumbers = Array(members.keys)
            tableView.delegate = self
            tableView.dataSource = self
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
                    self.adminStatus[self.currentUID!]=false
                    self.tableView.reloadData()
                }
            })
            self.tableView.allowsMultipleSelection = true
        }
        else {
            showErrorAlert("User not logged in", msg: "Please log in to continue")
        }

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
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.redColor()
        cell.selectedBackgroundView = backgroundView
        return cell
    }
    
    
//    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        var selectedCell:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
//        selectedCell.contentView.backgroundColor = UIColor.redColor()
//    }
//    
//    // if tableView is set in attribute inspector with selection to multiple Selection it should work.
//    
//    // Just set it back in deselect
//    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        var cellToDeSelect:UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        let phoneNum = cellToDeSelect.textLabel?.text
        //fudge it's making me get the uid ok that makes sense
        let aString: String = phoneNum!
        let newString = aString.stringByReplacingOccurrencesOfString("+", withString: "%2B")
        let ref = Firebase(url:"https://scheduler-base.firebaseio.com/phonenumbers/\(newString)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if !snapshot.exists() {
                print("Error, this phone number does not exist")
            } else {
                //get user's uid
                if let addUID = snapshot.value["uid"] {
                    let addUID = addUID as! String
                    self.adminStatus[addUID] = false
                }
                else {
                    print("Internal error. UID does not exist for this phone number")
                }
            }
            }, withCancelBlock: { error in
                print(error.description)
        })

        
        print("Deselecting: \(cellToDeSelect.textLabel!.text)")
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        
        let phoneNum = currentCell.textLabel!.text!
        
        print("Selecting: \(phoneNum)")
        
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

                    self.adminStatus[addUID] = true
                    
                }
                else {
                    print("Internal error. UID does not exist for this phone number")
                }
            }
            }, withCancelBlock: { error in
                print(error.description)
        })

        
    }

    
}
