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
    
    @IBAction func addBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("toCreateGroup", sender: nil)
    }
    
    @IBAction func logoutBtnPress(sender: AnyObject) {
        Digits.sharedInstance().logOut()
        NSUserDefaults.standardUserDefaults().setValue(nil, forKey: KEY_UID)
        self.performSegueWithIdentifier("backToSignUp", sender: nil)
    }
    
//    @IBAction func logOutBtnPress(sender: AnyObject) {
//        Digits.sharedInstance().logOut()
//        print("logging out!")
//        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
//            print(NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID))
//        }
//    }
    var randArray: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeRef = Firebase(url: "https://scheduler-base.firebaseio.com")
        if homeRef.authData != nil {
            // user authenticated
            let currUid = homeRef.authData.uid
            //print(homeRef.authData.uid)
            let ref = Firebase(url: "https://scheduler-base.firebaseio.com/users/\(currUid)/groups")
            ref.observeSingleEventOfType(.Value, withBlock: { snapshot in
                print("MERP: \(snapshot.childrenCount)") // I got the expected number of items
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

}