//
//  CreateGroupVC.swift
//  scheduler-app
//
//  Created by Victoria on 3/7/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit
import Firebase


class CreateGroupVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var members = [String: String]()
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var groupName: UITextField!
    @IBOutlet weak var phoneNumberToAdd: UISearchBar!
    @IBOutlet weak var countryCode: UITextField!
    
    @IBAction func removeBtnPress(sender: AnyObject) {
        if let button = sender as? UIButton {
            if let superview = button.superview {
                if let cell = superview.superview as? AddMemberCell {
                    members.removeValueForKey(cell.textLabel!.text!)
                    tableView.reloadData()
                }
            }
        }
        print("removing this user..")
    }
    
    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelGroupCreate", sender: nil)
    }
    
    @IBAction func addMember(sender: AnyObject) {
        //check that phone number exists in REF_PNUMBERS
        if let phoneNum = self.phoneNumberToAdd.text {
            if let cc = self.countryCode.text {
                let phonenumber = "\(cc)\(phoneNum)"
                let aString: String = phonenumber
                let newString = aString.stringByReplacingOccurrencesOfString("+", withString: "%2B")
                let ref = Firebase(url:"https://scheduler-base.firebaseio.com/phonenumbers/\(newString)")
                ref.observeEventType(.Value, withBlock: { snapshot in
                    if !snapshot.exists() {
                        self.showErrorAlert("Phone number not recognized", msg: "Please ensure that the information entered is correct. The phone number entered is either incorrect, or the user is not registered with TimeSlots.")
                    } else {
                        //get user's uid
                        if let addUID = snapshot.value["uid"] {
                            self.members[phonenumber]=addUID as? String
                            self.tableView.reloadData()
                        }
                        else {
                            self.showErrorAlert("Internal error occurred", msg: "There is an error with this user's account. Please try again later.")
                        }
                    }
                    }, withCancelBlock: { error in
                        print(error.description)
                })
            }

        }
        else {
            showErrorAlert("Please enter a valid contact number", msg: "")
        }
        self.phoneNumberToAdd.text=""
        
    }
    
    
    @IBAction func createGroupBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toAdminSetup", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toAdminSetup"){
            let svc = segue.destinationViewController as! AdminSetupVC;
            svc.membersToPass = members
            svc.nameToPass = groupName.text
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround() 
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
        var keys = Array(members.keys)
        let cell = tableView.dequeueReusableCellWithIdentifier("AddMemberCell") as! AddMemberCell
        cell.textLabel?.text = keys[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.contentView.bringSubviewToFront(cell.removeBtn)
        return cell
    }

}
