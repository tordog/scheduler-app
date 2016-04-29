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
    
    var groupIDHash = [String: String]()
    var groupID: String = ""
    var maxCount = 0
    
    @IBAction func profileSettingsBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toProfileSettings", sender: nil)
    }
    
    @IBAction func addBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toCreateGroup", sender: nil)
    }
    
    @IBAction func logoutBtnPress(sender: AnyObject) {
        Digits.sharedInstance().logOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        self.performSegueWithIdentifier("backToSignUp", sender: nil)
    }
    
    var randArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let uid = getUID()
        
        if uid != nil {

            //print(homeRef.authData.uid)
            let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(uid)/groups")
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if(snapshot.childrenCount == 0){
                    self.noGroupsText.text = "No groups yet! Create a group to get started."
                }
                else {
                    self.noGroupsText.text = ""
                    let enumerator = snapshot.children
                    
                    while let rest = enumerator.nextObject() as? FDataSnapshot {
                        //Find rest.key in groups
                        let refGroup = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(rest.key)")
                        refGroup.observeSingleEventOfType(.Value, withBlock: { snapshot in
                            if let groupName = snapshot.value["groupName"]{
                                self.randArray.append(groupName as! String)
                                self.groupIDHash[groupName as! String] = rest.key
                                self.tableView.reloadData()
                            }
                        })
                        
                    }
                    
                }
            })
        }
        
        
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toGroupCalendar"){
            let svc = segue.destinationViewController as! CollectionViewController;
            svc.groupIDToPass = groupID
            svc.numSectionsToPass = self.maxCount
        }
    }

    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(randArray.count)
        return randArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroupCell") as! GroupCell
        
        cell.textLabel?.text = randArray[indexPath.row]
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        
        let currentCell = tableView.cellForRowAtIndexPath(indexPath)! as UITableViewCell
        if let groupName = currentCell.textLabel!.text {
            groupID = groupIDHash[groupName]!
        }
        
        let ref = Firebase(url:"https://scheduler-base.firebaseio.com/groups/\(groupID)")
        ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
            if let x = snapshot.value["highestNum"] {
                self.maxCount = x as! Int
                self.performSegueWithIdentifier("toGroupCalendar", sender: nil)
            }
            else {
                self.maxCount = 20
                self.performSegueWithIdentifier("toGroupCalendar", sender: nil)
            }
        })

    }

}