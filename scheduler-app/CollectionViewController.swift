//
//  CollectionViewController.swift
//  CustomCollectionLayout
//
//  Created by JOSE MARTINEZ on 15/12/2014.
//  Copyright (c) 2014 brightec. All rights reserved.
//

import UIKit
import Firebase

class CollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    let dateCellIdentifier = "DateCellIdentifier"
    let contentCellIdentifier = "ContentCellIdentifier"
    var dates: [String] = []
    var numSections: Int = 0
    var groupIDToPass: String = ""
    var groupID: String = ""
    var dateToPass = ""
    var eventIDToPass = ""
    var statusToPass = ""

    var sampleData: [[[String]]] = []
    
    //we'll search firebase, get the # of entries, and make the table using that number. For now, let's make the table the # of events.
    
    @IBAction func addEvent(sender: AnyObject) {
        self.performSegueWithIdentifier("addEvent", sender: nil)
    }
    
    @IBAction func backBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("backToGroups", sender: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerTitle: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupID = groupIDToPass
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        var dateStrDict = Dictionary<String, Int>()
        
        numSections = 10 //events.count + 1 //plus 1 for initial row
        
            var date = NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd";
        
            let ref0 = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)")
            ref0.observeSingleEventOfType(.Value, withBlock: { snapshot in
                if !snapshot.exists() {
                    print("Error")
                } else {
                    self.headerTitle.text = snapshot.value["groupName"] as? String
                }
            })
   
            for (var i=0; i<15; i++){
                
                let dateStr = formatter.stringFromDate(date); //string to add to DB
                dateStrDict[dateStr] = i
                //add dateStr to sampleData
                sampleData.append([])
                for (var j = 0; j<numSections; j++){
                    sampleData[i].append(["", "", "", "", "", "", ""])
                }
                //Firebase Call here
                let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)/\(dateStr)/events")
                var count = 0
                ref.queryOrderedByChild("startTime24").observeEventType(.ChildAdded, withBlock: { snapshot in
                    var title = ""
                    var startDate = ""
                    var timeStr = ""
                    var desc = ""
                    var eventID = ""
                    var numSlots = ""
                    var datestring = ""
                    var signupBool = ""
                    if let stitle = snapshot.value["title"] as? String {
                        title = stitle
                    }
                    if let sDate = snapshot.value["startDate"] as? String {
                        startDate = sDate
                    }
                    if let startTime = snapshot.value["startTime"] as? String {
                        if let endTime = snapshot.value["endTime"] as? String {
                            timeStr = "\(startTime) to \(endTime)"
                        }
                    }
                    if let eventid = snapshot.value["eventID"] as? String {
                        eventID = eventid
                    }
                    if let nSlots = snapshot.value["numSlots"] as? String {
                        numSlots = "\(nSlots) slots available"
                    }
                    if let description = snapshot.value["description"] as? String {
                        desc = description
                    }
                    if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
                        let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID)
                        
                        let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(self.groupID)/\(dateStr)/events/\(eventID)/signups/\(uid!)")
                        ref.observeEventType(.Value, withBlock: { snapshot in
                            if snapshot.value is NSNull {
                                signupBool = "false"
                            }
                            else {
                                signupBool = "true"
                            }
                            self.sampleData[dateStrDict[startDate]!][count] = [eventID, title, desc, timeStr, numSlots, startDate, signupBool]
                            count++
                            self.collectionView!.reloadData()
                        })

                    }
//                    self.sampleData[dateStrDict[startDate]!][count] = [eventID, title, desc, timeStr, numSlots, startDate, signupBool]
//                    count++
//                    self.collectionView!.reloadData()
                    //print(self.sampleData)
                    
                })
                
            

                let nextDay = date.dateByAddingTimeInterval(1*60*60*24);
                let calendar = NSCalendar.currentCalendar()
                let components = calendar.components([.Day , .Month , .Year], fromDate: date) //can be tomorrow's date, etc.
                let year =  components.year
                let month = components.month
                let day = components.day
                dates.append("\(month)/\(day)")
                date=nextDay
                
            }

        /* If other plan doesn't work...
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            let uid = NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID)
            print("https://scheduler-base.firebaseio.com/signups/\(uid!)/\(self.groupID)/events")
            let ref = Firebase(url: "https://scheduler-base.firebaseio.com/signups/\(uid!)/\(self.groupID)/events")
            ref.observeEventType(.ChildAdded, withBlock: { snapshot in
                if snapshot.value is NSNull {
                    print("snapshot doesn't exist; so none there?")
                }
                else {
                    print("snapshot exists. eventID: \(snapshot.key)")
                    //look for snapshot.key in sampleData? 
                    var found = false
                    for (var i=0; i<self.sampleData.count; i++){
                        for (var j=0; j<self.sampleData[i].count; j++){
                            if self.sampleData[i][j][0] == snapshot.key {
                                self.sampleData[i][j][4] = "You are signed up for this slot"
                                found = true
                                break
                            }
                        }
                        if (found == true) {
                            break
                        }
                    }
                }
                //print(snapshot.key)
                self.collectionView!.reloadData()
                
                }, withCancelBlock: { error in
                    print(error.description)
            })
            
        }
        */

        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        self.collectionView .registerNib(UINib(nibName: "DateCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: dateCellIdentifier)
        self.collectionView .registerNib(UINib(nibName: "ContentCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: contentCellIdentifier)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "toEventDetails"){
            let svc = segue.destinationViewController as! EventDetailsVC;
            svc.eventIDToPass = eventIDToPass
            svc.dateToPass = dateToPass
            svc.groupIDToPass = groupID
            svc.statusToPass = statusToPass
            
        }
        else if(segue.identifier == "addEvent"){
            let svc = segue.destinationViewController as! AddEventVC;
            svc.groupIDToPass = groupID
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
    // MARK - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return numSections
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

    //on cell click
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        
        if(indexPath.section == 0) {
            //date cell; not clickable; do nothing
        }
        else if sampleData[indexPath.row][indexPath.section - 1][0] == "" {
            //Cell not clickable; do nothing
        }
        else{
        
            cell!.layer.backgroundColor = UIColor.lightGrayColor().CGColor
            
            eventIDToPass = sampleData[indexPath.row][indexPath.section - 1][0]
            dateToPass = sampleData[indexPath.row][indexPath.section - 1][5]
            statusToPass = sampleData[indexPath.row][indexPath.section - 1][6]
            
            self.performSegueWithIdentifier("toEventDetails", sender: nil)
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var date = NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        
        // loop through each cell:
        //for cell in self.collectionView!.visibleCells() as [UICollectionViewCell] {  }
        
        if indexPath.section == 0 {
            let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
            dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
            dateCell.dateLabel.textColor = UIColor.blackColor()
            dateCell.dateLabel.text = dates[indexPath.row]
           // dateCell.backgroundColor = UIColor.whiteColor()
            if indexPath.row % 2 != 0 {
                dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
            } else {
                dateCell.backgroundColor = UIColor.whiteColor()
            }

            return dateCell
            
        } else {


            let contentCell : ContentCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
            contentCell.contentLabel.font = UIFont.systemFontOfSize(13)
            contentCell.contentLabel.textColor = UIColor.blackColor()
            contentCell.contentLabel.text = sampleData[indexPath.row][indexPath.section - 1][1]
            contentCell.timeLabel.text = sampleData[indexPath.row][indexPath.section - 1][3]
            contentCell.numSlotsLabel.textColor = UIColor.blackColor()
            if(sampleData[indexPath.row][indexPath.section - 1][6] == "true"){
                contentCell.numSlotsLabel.text = "You are signed up"
                contentCell.numSlotsLabel.textColor = UIColor.redColor()
                //contentCell.backgroundColor = UIColor(red: 0.5, green: 0.8, blue: 0.5, alpha: 0.55)
                contentCell.backgroundColor = UIColor(red: 0.8, green: 0.5, blue: 0.5, alpha: 0.55)

            }
            else {
                contentCell.numSlotsLabel.text = sampleData[indexPath.row][indexPath.section - 1][4]
                if indexPath.row % 2 != 0 {
                    if (sampleData[indexPath.row][indexPath.section - 1][0] != "") {
                        if indexPath.section % 2 != 0 {
                            contentCell.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 0.9, alpha: 0.35)
                        }
                        else {
                            contentCell.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 0.9, alpha: 0.25)
                        }
                    }
                    else{
                        contentCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                    }
                } else {
                    if (sampleData[indexPath.row][indexPath.section - 1][0] != "") {
                        if indexPath.section % 2 != 0 {
                            contentCell.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 0.9, alpha: 0.2)
                        }
                        else{
                            contentCell.backgroundColor = UIColor(red: 0.21, green: 0.65, blue: 0.9, alpha: 0.1)
                        }
                    }
                    else{
                        contentCell.backgroundColor = UIColor.whiteColor()
                    }
                }
            }
            
            
            return contentCell
                
   
            
        }
        
   }

}

