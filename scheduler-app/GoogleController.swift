//
//  GoogleController.swift
//  scheduler-app
//
//  Created by Victoria on 4/19/16.
//  Copyright © 2016 Victoria. All rights reserved.
//

import UIKit

class GoogleController: UIViewController {
    
    private let kKeychainItemName = "Google Calendar API"
    private let kClientID = "4167539657-0ekgk3lflbtq9ok5g4d7g9m7tauvi0vu.apps.googleusercontent.com"
    
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    //private let scopes = [kGTLAuthScopeCalendarReadonly]
    private let scopes = [kGTLAuthScopeCalendar]
    
    private let service = GTLServiceCalendar()
    let output = UITextView()
    
    // When the view loads, create necessary subviews
    // and initialize the Google Calendar API service
    override func viewDidLoad() {
        super.viewDidLoad()
        
        output.frame = view.bounds
        output.editable = false
        output.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        output.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        view.addSubview(output);
        
        if let auth = GTMOAuth2ViewControllerTouch.authForGoogleFromKeychainForName(
            kKeychainItemName,
            clientID: kClientID,
            clientSecret: nil) {
//                auth.accessToken = nil;
//                auth.refreshToken = nil;
                service.authorizer = auth
        }
        
    }
    
    // When the view appears, ensure that the Google Calendar API service is authorized
    // and perform API calls
    override func viewDidAppear(animated: Bool) {
        if let authorizer = service.authorizer,
            canAuth = authorizer.canAuthorize where canAuth {
                fetchEvents()
        } else {
            presentViewController(
                createAuthController(),
                animated: true,
                completion: nil
            )
        }
    }
    
    func addEvent() {
        //POST https://www.googleapis.com/calendar/v3/calendars/primary/events
        

        
        let event1: [String: AnyObject] = [
            "summary": "Title",
            "description": "description",
            "start": [
                "dateTime": "2016-04-28T09:00:00-07:00",
                "timeZone": "America/Los_Angeles",
            ],
            "end": [
                "dateTime": "2016-04-28T17:00:00-07:00",
                "timeZone": "America/Los_Angeles",
            ]
        ]
        
        //updateAuthService()
        
        //var event = GTLObject();
        let event = GTLCalendarEvent()
        event.summary = "Test title"
        event.descriptionProperty = "Description"
        let date = NSDate()
        let date1 = date.dateByAddingTimeInterval(1*60*60);
        let date2 = date1.dateByAddingTimeInterval(1*60*60);
        let uh = GTLCalendarEventDateTime()
        
        let startDateTime: GTLDateTime = GTLDateTime(date: date1, timeZone: NSTimeZone.localTimeZone())
        let endDateTime: GTLDateTime = GTLDateTime(date: date2, timeZone: NSTimeZone.localTimeZone())
        
        event.start = uh
        event.start.dateTime = startDateTime
        event.end = uh
        event.end.dateTime = endDateTime
        
        print(event)
        
        let query = GTLQueryCalendar.queryForEventsInsertWithObject(event, calendarId: "primary")
        service.executeQuery(query, completionHandler: nil)
        
        
        
        
//        // prepare json data
//        if let jsonData = try? NSJSONSerialization.dataWithJSONObject(event, options: .PrettyPrinted) {
//            print("hi")
//            // create post request
//            let url = NSURL(string: "https://www.googleapis.com/calendar/v3/calendars/primary/events")!
//            let request = NSMutableURLRequest(URL: url)
//            request.HTTPMethod = "POST"
//            
//            // insert json data to the request
//            request.HTTPBody = jsonData
//            
//            
//            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){ data,response,error in
//                if error != nil{
//                    print("Error occured")
//                    print(error!.localizedDescription)
//                    return
//                }
//                if let responseJSON = try? NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject]{
//                    print("HI...")
//                    print(responseJSON)
//                }
//            }
//            
//            task.resume()
//        }

    }
    
    // Construct a query and get a list of upcoming events from the user calendar
    func fetchEvents() {
        let query = GTLQueryCalendar.queryForEventsListWithCalendarId("primary")
        query.maxResults = 10
        query.timeMin = GTLDateTime(date: NSDate(), timeZone: NSTimeZone.localTimeZone())
        query.singleEvents = true
        query.orderBy = kGTLCalendarOrderByStartTime
        service.executeQuery(
            query,
            delegate: self,
            didFinishSelector: "displayResultWithTicket:finishedWithObject:error:"
        )
        
        addEvent()
    }
    
    
    
    func updateAuthService() -> GTLServiceCalendar {
        let service2 = GTLServiceCalendar()
        let auth2 = GTMOAuth2Authentication()
        auth2.clientID = kClientID
        auth2.clientSecret = nil
        service2.authorizer = auth2

        return service2
        
    }
    
    
    
    
    
    // Display the start dates and event summaries in the UITextView
    func displayResultWithTicket(
        ticket: GTLServiceTicket,
        finishedWithObject response : GTLCalendarEvents,
        error : NSError?) {
            
            if let error = error {
                showAlert("Error", message: error.localizedDescription)
                return
            }
            
            var eventString = ""
            
            if let events = response.items() where !events.isEmpty {
                for event in events as! [GTLCalendarEvent] {
                    var start : GTLDateTime! = event.start.dateTime ?? event.start.date
                    var startString = NSDateFormatter.localizedStringFromDate(
                        start.date,
                        dateStyle: .ShortStyle,
                        timeStyle: .ShortStyle
                    )
                    eventString += "\(startString) - \(event.summary)\n"
                }
            } else {
                eventString = "No upcoming events found."
            }
            
            output.text = eventString
    }
    
    
    // Creates the auth controller for authorizing access to Google Calendar API
    private func createAuthController() -> GTMOAuth2ViewControllerTouch {
        let scopeString = scopes.joinWithSeparator(" ")
        return GTMOAuth2ViewControllerTouch(
            scope: scopeString,
            clientID: kClientID,
            clientSecret: nil,
            keychainItemName: kKeychainItemName,
            delegate: self,
            finishedSelector: "viewController:finishedWithAuth:error:"
        )
    }
    
    // Handle completion of the authorization process, and update the Google Calendar API
    // with the new credentials.
    func viewController(vc : UIViewController,
        finishedWithAuth authResult : GTMOAuth2Authentication, error : NSError?) {
            
            if let error = error {
                service.authorizer = nil
                showAlert("Authentication Error", message: error.localizedDescription)
                return
            }
            
            service.authorizer = authResult
            dismissViewControllerAnimated(true, completion: nil)
    }
    
    // Helper for showing an alert
    func showAlert(title : String, message: String) {
        let alert = UIAlertView(
            title: title,
            message: message,
            delegate: nil,
            cancelButtonTitle: "OK"
        )
        alert.show()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
