//
//  emailVC.swift
//  scheduler-app
//
//  Created by Victoria on 5/2/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import Firebase
import UIKit
import MessageUI
import EventKit

class emailVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    let eventStore = EKEventStore()
    var tryingToPass = NSString()
    var trying = NSString()
    var subjectToPass = NSString()
    var subject = NSString()
    var emailAddress: String = ""
    var groupID: String = ""
    var nSec: Int = 0
    var groupIDToPass: String = ""
    var numSectionsToPass: Int = 0
    var sent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.event = self.eventToPass
        self.trying = self.tryingToPass
        self.subject = self.subjectToPass
        self.groupID = self.groupIDToPass
        self.nSec = self.numSectionsToPass
        let uid = getUID()
        print(uid!)
        let ref = Firebase(url:"https://scheduler-base.firebaseio.com/users/\(uid!)")
        ref.observeEventType(.Value, withBlock: { snapshot in
            if let emailAddr = snapshot.value["email"] {
                print(emailAddr)
                self.emailAddress = emailAddr as! String
            }
            
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        if(sent == true){
            self.performSegueWithIdentifier("backToCalendar", sender: nil)
        }
    }
    
    @IBAction func cancelBtnPress(sender: AnyObject) {
        self.performSegueWithIdentifier("backToCalendar", sender: nil)
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
            //self.performSegueWithIdentifier("backToCalendar", sender: nil)
        } else {
            self.showSendMailErrorAlert()
            //self.performSegueWithIdentifier("backToCalendar", sender: nil)
        }
        sent = true
        
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["\(self.emailAddress)"])
        mailComposerVC.setSubject("New event from TimeSlots: \(self.subject)")
        mailComposerVC.setMessageBody("To add this event to your calendar, double click the .ics file.", isHTML: false)

        
        let data = self.trying.dataUsingEncoding(NSUTF8StringEncoding)
        print(data!)

        mailComposerVC.addAttachmentData(data!, mimeType: "text/calendar", fileName: "eventData.ics")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = showErrorAlert("Could Not Send Email", msg: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "backToCalendar"){
            let svc = segue.destinationViewController as! CollectionViewController;
            svc.groupIDToPass = groupID
            svc.numSectionsToPass = nSec
            
        }
        
        
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}