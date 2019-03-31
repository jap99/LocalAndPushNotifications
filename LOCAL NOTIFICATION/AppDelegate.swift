//
//  AppDelegate.swift
//  LOCAL NOTIFICATION
//
//  Created by Javid Poornasir on 8/8/18.
//  Copyright © 2018 jp. All rights reserved.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseMessaging
import FirebaseInstanceID // support the token that firebase provides to identify the app to its services

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, MessagingDelegate {
    
    var window: UIWindow?
    
    
    
    // MessagingDelegate - a protocol to handle token update or data message delivery from FCM
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if error != nil {
                // something bad happened
            } else {
                UNUserNotificationCenter.current().delegate = self // the delegate methods will be handled by this class is what this means
                Messaging.messaging().delegate = self
                print("GRANTED NOTIFICATIONS: \(granted)")
            }
        }
        DispatchQueue.main.async {
            // Must request authorization that we can receive any type of push notification
            //UIApplication.shared
            application.registerForRemoteNotifications()
        }; return true
    }
    
    func connectToFirebaseConnectionMgr() {  // call this immediately after app becomes active
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Notification now displays when app's in foreground
        completionHandler([.alert, .sound])
    }
    
    // Reacts to tapping on the notifctn
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // We have access to the notf. so we can access the identifier
        if response.notification.request.identifier == "testIdentifier" {
            print("HANDLING NOTF. WITH THE IDENTIFIER 'testIdentifier'")
            // We can launch a specific screen from here
            // We also access the payload of what was sent in the push notification in here and here's some code to help us parse the notification
            if let notification = response.notification.request.content.userInfo as? [String: AnyObject] {
                let message = parseRemoteNotification(notification: notification)
                print(message as Any)
            } 
            completionHandler()
        }
        
        // HERE'S ANOTHER POSSIBILITY OF WHAT COULD BE DONE INSTEAD OF WHAT'S ABOVE - THIS WOULD MAKE THE ACTION BUTTONS WORK
        
        // THIS WOULD HELP US TO SHOW WHICH BOXING EVENTS OR CALENDAR EVENTS HAVE HAD REMINDERS SET UP IN THE FORM OF PUSH NOTF.
        //        https://www.youtube.com/watch?v=e7cTZ4Tp25I
        //        let foodItem = Food(context: persistentContainer.viewContext)
        //        foodItem.added = NSDate()
        //        if response.actionIdentifier == "addFruit" {
        //            foodItem.type = "Fruit"
        //        } else { // veggie
        //            foodItem.type = "Vegetable"
        //        }
        //        self.saveContext()
        //        scheduleNotification() // this would be here if we were to put this func in this class instead of ViewController.swift
        //         completionHandler()
    }
    
    private func parseRemoteNotification(notification: [String: AnyObject]) -> String? {
        if let aps = notification["aps"] as? [String: AnyObject] {
            let alert = aps["alert"] as? String
            return alert
        }; return nil
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { // Callback for receiving device token
        let token = deviceToken.map{ String(format: "%02.2hhx", $0) }.joined()
        print("PRINTING THE DEVICE TOKEN: \(token)")
        // Device token doesn't usually change but sometimes it does so we need to have a service to make sure we can update it
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { // Called if device token not received
    }
    
    
    
    // FIREBASE
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) { // properly handling a refreshed token in Swift 4 may be more difficult than it appears
        let newToken = InstanceID.instanceID().token()
        connectToFirebaseConnectionMgr()                        // called if we get a new token so it can reset itself
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
    }
    
    
    func applicationDidEnterBackground(_ application: UIApplication) {  // break our connection to FCM (firebase connection mgr)
        Messaging.messaging().shouldEstablishDirectChannel = false
    }
    
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        connectToFirebaseConnectionMgr() // FCM
    }
    
    
    
    
}

