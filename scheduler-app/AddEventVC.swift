//
//  AddEventVC.swift
//  scheduler-app
//
//  Created by Victoria on 4/3/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class AddEventVC: UIViewController {

    @IBAction func saveBtnPress(sender: AnyObject) {
        //save everything to firebase!
        //under GroupID which I haven't passed yet
        //should be under groups/groupID/events/date..
        //title, startTime, endTime, description, numSlots
        
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
    }
    
    @IBOutlet weak var eventTitle: UITextField!
    
    @IBOutlet weak var eventDescription: UITextView!
    
    @IBOutlet weak var eventStart: UIDatePicker!
    
    @IBOutlet weak var eventEnd: UIDatePicker!
    
    @IBOutlet weak var numSlots: UILabel!
    
    @IBOutlet weak var stepper: UIStepper!
    
    @IBAction func stepperAction(sender: AnyObject) {
        numSlots.text = "\(Int(stepper.value))"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let today = NSDate()
        let endDate = today.dateByAddingTimeInterval(14*60*60*24);
        eventStart.minimumDate = today
        eventStart.maximumDate = endDate
        eventEnd.minimumDate = today
        eventEnd.maximumDate = endDate
        // Do any additional setup after loading the view.
    }


    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
