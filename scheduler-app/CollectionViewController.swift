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
    
    let events = ["hi", "lol", "event!"]
    
    var sampleData: [[[String]]] = []
    
    //var sampleData = Dictionary<Int, [[String]]>()
    
    //we'll search firebase, get the # of entries, and make the table using that number. For now, let's make the table the # of events.
    
    @IBAction func addEvent(sender: AnyObject) {
        self.performSegueWithIdentifier("addEvent", sender: nil)
    }
    
    @IBAction func backBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("backToGroups", sender: nil)
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        groupID = groupIDToPass
        print(groupID)
        self.collectionView.backgroundColor = UIColor.whiteColor()
        
        var dateStrDict = Dictionary<String, Int>()
        
        numSections = events.count + 1 //plus 1 for initial row
        
            var date = NSDate()
            var formatter = NSDateFormatter();
            formatter.dateFormat = "yyyy-MM-dd";
   
            for (var i=0; i<15; i++){
                
                let dateStr = formatter.stringFromDate(date); //string to add to DB
                dateStrDict[dateStr] = i
                //add dateStr to sampleData
                sampleData.append([])
                for (var j = 0; j<numSections; j++){
                    sampleData[i].append(["", "", "", "", ""])
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
                    if let nSlots = snapshot.value["numSlots"] as? String {
                        numSlots = "\(nSlots) slots available"
                    }
                    if let description = snapshot.value["description"] as? String {
                        desc = description
                    }

                    if let eventid = snapshot.value["eventID"] as? String {
                        eventID = eventid
                    }
                    self.sampleData[dateStrDict[startDate]!][count] = [eventID, title, desc, timeStr, numSlots, startDate]
                    count++
                    self.collectionView!.reloadData()
                    print(self.sampleData)
                    
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
        
        
//        sampleData = ["Day 1": [["eventID1", "title1", "description1", "time1"], ["eventID2", "title2", "description2", "time2"]], "Day 2": [["eventID", "title", "description", "time"]]]

        
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
        cell!.layer.backgroundColor = UIColor.lightGrayColor().CGColor
        
        eventIDToPass = sampleData[indexPath.row - 1][indexPath.section - 1][0]
        dateToPass = sampleData[indexPath.row - 1][indexPath.section - 1][5]
        
        self.performSegueWithIdentifier("toEventDetails", sender: nil)
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var date = NSDate()
        var formatter = NSDateFormatter();
        formatter.dateFormat = "yyyy-MM-dd";
        
        //for the 14 days, loop through
//        for (var i=0; i<14; i++){
//            if indexPath.section == i+1 {
//                let dateStr = formatter.stringFromDate(date); //string to add to DB
//                print("Today's date: \(dateStr)") //I think we can compare this string to the things in our DB
//                //so /groups/groupid/dateStr
//                var count = 1
//                let ref = Firebase(url: "https://scheduler-base.firebaseio.com/groups/\(groupID)/\(dateStr)/events")
//                ref.queryOrderedByChild("startTime24").observeEventType(.ChildAdded, withBlock: { snapshot in
//                    if indexPath.row == count {
//                        if let title = snapshot.value["title"] as? String {
//                            print("Title: \(title)")
//                        }
//                        if let startDate = snapshot.value["startDate"] as? String {
//                            //print(startDate)
//                        }
//                        if let startTime = snapshot.value["startTime"] as? String {
//                            if let endTime = snapshot.value["endTime"] as? String {
//                                print("From \(startTime) to \(endTime)")
//                            }
//                        }
//                        
//                        if let time = snapshot.value["startTime24"] as? Double {
//                            //print("Start time: \(time)")
//                        }
//                    }
//                    count += 1
//                })
//
//            }
//            let nextDay = date.dateByAddingTimeInterval(1*60*60*24);
//            let calendar = NSCalendar.currentCalendar()
//            let components = calendar.components([.Day , .Month , .Year], fromDate: date) //can be tomorrow's date, etc.
//            let year =  components.year
//            let month = components.month
//            let day = components.day
//            dates.append("\(month)/\(day)")
//            date=nextDay
//            
//        }
        
        // loop through each cell:
        //for cell in self.collectionView!.visibleCells() as [UICollectionViewCell] {  }
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
                dateCell.backgroundColor = UIColor.whiteColor()
                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
                dateCell.dateLabel.textColor = UIColor.blackColor()
                dateCell.dateLabel.text = ""

                return dateCell
            } else {
                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
                dateCell.dateLabel.textColor = UIColor.blackColor()
                dateCell.dateLabel.text = dates[indexPath.row - 1]

                if indexPath.section % 2 != 0 {
                    dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    dateCell.backgroundColor = UIColor.whiteColor()
                }

                return dateCell
            }
        } else {
            if indexPath.row == 0 {
                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
                dateCell.dateLabel.textColor = UIColor.blackColor()
                dateCell.dateLabel.text = ""
                if indexPath.section % 2 != 0 {
                    dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    dateCell.backgroundColor = UIColor.whiteColor()
                }
                
                return dateCell
            }
            else {

                let contentCell : ContentCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
                contentCell.contentLabel.font = UIFont.systemFontOfSize(13)
                contentCell.contentLabel.textColor = UIColor.blackColor()
                contentCell.contentLabel.text = sampleData[indexPath.row - 1][indexPath.section - 1][1]
                contentCell.timeLabel.text = sampleData[indexPath.row - 1][indexPath.section - 1][3]
                contentCell.numSlotsLabel.text = sampleData[indexPath.row - 1][indexPath.section - 1][4]
                if indexPath.section % 2 != 0 {
                    contentCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
                } else {
                    contentCell.backgroundColor = UIColor.whiteColor()
                }
                
                return contentCell
                
   
            }
        }
        
        
//        if indexPath.section == 0 {
//            if indexPath.row == 0 {
//                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
//                dateCell.backgroundColor = UIColor.whiteColor()
//                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
//                dateCell.dateLabel.textColor = UIColor.blackColor()
//                dateCell.dateLabel.text = ""
//
//                return dateCell
//            } else {
//                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
//                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
//                dateCell.dateLabel.textColor = UIColor.blackColor()
//                dateCell.dateLabel.text = dates[indexPath.row - 1]
//                
//                if indexPath.section % 2 != 0 {
//                    dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
//                } else {
//                    dateCell.backgroundColor = UIColor.whiteColor()
//                }
//                
//                return dateCell
//            }
//        } else {
//            if indexPath.row == 0 {
//                let dateCell : DateCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(dateCellIdentifier, forIndexPath: indexPath) as! DateCollectionViewCell
//                dateCell.dateLabel.font = UIFont.systemFontOfSize(13)
//                dateCell.dateLabel.textColor = UIColor.blackColor()
//                dateCell.dateLabel.text = ""
//                if indexPath.section % 2 != 0 {
//                    dateCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
//                } else {
//                    dateCell.backgroundColor = UIColor.whiteColor()
//                }
//                
//                return dateCell
//            } else {
//                let contentCell : ContentCollectionViewCell = collectionView .dequeueReusableCellWithReuseIdentifier(contentCellIdentifier, forIndexPath: indexPath) as! ContentCollectionViewCell
//                contentCell.contentLabel.font = UIFont.systemFontOfSize(13)
//                contentCell.contentLabel.textColor = UIColor.blackColor()
//                contentCell.contentLabel.text = "Event"
//                if indexPath.section % 2 != 0 {
//                    contentCell.backgroundColor = UIColor(white: 242/255.0, alpha: 1.0)
//                } else {
//                    contentCell.backgroundColor = UIColor.whiteColor()
//                }
//                
//                return contentCell
//            }
//        }
   }

}

