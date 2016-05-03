//
//  emailVC.swift
//  scheduler-app
//
//  Created by Victoria on 5/2/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import Foundation
import UIKit
import MessageUI
import EventKit

class emailVC: UIViewController, MFMailComposeViewControllerDelegate {
    
    let eventStore = EKEventStore()
//    var eventToPass = EKEvent()
//    var event = EKEvent()
    var tryingToPass = NSString()
    var trying = NSString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.event = self.eventToPass
        self.trying = self.tryingToPass
        print(self.trying)
    }
    
    @IBAction func sendEmailButtonTapped(sender: AnyObject) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients(["victorianielsen@outlook.com", "torie.nielsen@gmail.com"])
        mailComposerVC.setSubject("Sending you an in-app e-mail...")
        mailComposerVC.setMessageBody("Monday May 2, 4pm-6:15pm", isHTML: false)
        
        let data = self.trying.dataUsingEncoding(NSUTF8StringEncoding)
        print(data!)

        mailComposerVC.addAttachmentData(data!, mimeType: "multipart/alternative;text/calendar;method=REQUEST;charset=UTF-8;attachment", fileName: "eventData.ics")
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = showErrorAlert("Could Not Send Email", msg: "Your device could not send e-mail.  Please check e-mail configuration and try again.")
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
}