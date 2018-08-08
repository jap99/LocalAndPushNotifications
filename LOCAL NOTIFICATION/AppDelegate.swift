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
        }
        return true
    }
    
    
    
    
    func connectToFirebaseConnectionMgr() {
        // call this immediately after app becomes active
        Messaging.messaging().shouldEstablishDirectChannel = true
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
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
    }
    
    
    
    
    private func parseRemoteNotification(notification: [String: AnyObject]) -> String? {
        if let aps = notification["aps"] as? [String: AnyObject] {
            let alert = aps["alert"] as? String
            return alert
        }
        return nil
    }
    

    
    
    
    // PUSH NOTIFICATIONS
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) { // Callback for receiving device token
        let token = deviceToken.map{ String(format: "%02.2hhx", $0) }.joined()
        print("PRINTING THE DEVICE TOKEN: \(token)")
        
        // Device token doesn't usually change but sometimes it does so we need to have a service to make sure we can update it
    }
    
    
    
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) { // Called if device token not received
    }
    
    

    // FIREBASE
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        // properly handling a refreshed token in Swift 4 may be more difficult than it appears
        let newToken = InstanceID.instanceID().token()
        connectToFirebaseConnectionMgr() // called if we get a new token so it can reset itself
    }
    
    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
        
    }
    
    
    
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        
        // break our connection to FCM (firebase connection mgr)
        Messaging.messaging().shouldEstablishDirectChannel = false
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        
        connectToFirebaseConnectionMgr() // FCM
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


    
    
}

