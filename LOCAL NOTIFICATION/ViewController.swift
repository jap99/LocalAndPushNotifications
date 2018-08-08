//
//  ViewController.swift
//  LOCAL NOTIFICATION
//
//  Created by Javid Poornasir on 8/8/18.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController {

    override func viewDidLoad() {   // CONTENT, TRIGGER, REQUEST
        super.viewDidLoad()
        
        self.view.backgroundColor = .blue
        
        // setup local notification
        let content = UNMutableNotificationContent()
        content.title = "TITLE OF NOTIFICATION"
        content.body = "BODY OF NOTIFICATION"
        content.sound = UNNotificationSound.default()
        
        // trigger - defines when notification will be sent (seconds, repeats)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // there's also a calendar notification to specify date and time to trigger notification
                //UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: Bool)
        // there's also a location trigger so when user enters a region a notf. will be fired
                //UNLocationNotificationTrigger
        
        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        // the identifer is used to identify the notf. & if your app sends another notf. w/ the same id then the first notf. gets overriden by the new one
        
        // now we can send the notf.
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
                // if we run the app the way it is and want to see a notf. then we'll need to exit the app before the 5 seconds are up because notf.s only show when app isn't in foreground
    }

    

}

