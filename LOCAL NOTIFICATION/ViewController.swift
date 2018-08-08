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
    }

    
    
    
    @IBAction func button_pressed(_ sender: Any) {
        scheduleNotification()
    }
    

    func scheduleNotification() {
        // setup local notification
        let content = UNMutableNotificationContent()
        content.title = "TITLE OF NOTIFICATION"
        content.body = "BODY OF NOTIFICATION"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "foodCategory"
        // there's also category.categoryIdentifier used to get all of the actions for a category we already defined
        // ie. one action to define a piece of fruit & one to define a food category
        // the three steps are
        // ( 1 ) DEFINE ACTIONS
        // ( 2 ) ADD ACTIONS TO A FOOD CATEGORY
        // ( 3 ) ADD THE FOOD CATEGORY TO NOTIFICATION FRAMEWORK
        let fruitAction = UNNotificationAction(identifier: "addFruit", title: "Add a piece of fruit", options: []) // step 1
        let veggieAction = UNNotificationAction(identifier: "addVegetable", title: "Add a piece of vegetable", options: []) // step 1
        let category = UNNotificationCategory(identifier: "foodCategory", actions: [fruitAction, veggieAction], intentIdentifiers: [], options: []) // step 2
        UNUserNotificationCenter.current().setNotificationCategories([category]) //step 3
        
        // show image in notf.
        guard let path = Bundle.main.path(forResource: "img", ofType: "png") else {
            return
        }
        let url = URL(fileURLWithPath: path)
        do {
            let attachment = try UNNotificationAttachment(identifier: "logo", url: url, options: nil)
            content.attachments = [attachment]
        } catch {
            print("THE ATTACHMENT COULD NOT BE LOADED")
        }
        
        
        // trigger - defines when notification will be sent (seconds, repeats)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        
        // there's also a calendar notification to specify date and time to trigger notification
        //UNCalendarNotificationTrigger(dateMatching: DateComponents, repeats: Bool)
        // there's also a location trigger so when user enters a region a notf. will be fired
        //UNLocationNotificationTrigger
        
        //        let request = UNNotificationRequest(identifier: "testIdentifier", content: content, trigger: trigger)
        let request = UNNotificationRequest(identifier: "foodNotification", content: content, trigger: trigger)
        // the identifer is used to identify the notf. & if your app sends another notf. w/ the same id then the first notf. gets overriden by the new one
        
        // now we can send the notf.
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().add(request) { (error) in
            if error != nil {
                print("ERROR ADD NOTF. REQUEST: \(error!.localizedDescription)")
            }
        }
        // if we run the app the way it is and want to see a notf. then we'll need to exit the app before the 5 seconds are up because notf.s only show when app isn't in foreground
    }
}

