//
//  AppDelegate.swift
//  NaloxOne
//
//  Created by Jake Byman on 10/16/16.
//  Copyright © 2016 Jake Byman. All rights reserved.
//

import UIKit
import UserNotifications
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        GMSServices.provideAPIKey("AIzaSyBbw40PoF9nQWbZU2sZNPbAdpaOTFs-Pio")
        self.window?.makeKeyAndVisible()
        
        // Set device token ID
        let token = UIDevice.current.identifierForVendor!.uuidString
        let formattedToken = token.replacingOccurrences(of: "-", with: "")
        HTTP.device_token = formattedToken
        
        // As soon as user opens, request to register for remote notifactions
        registerForRemoteNotification()
        
        // If the user has started the app from a push notification
        if let remoteNotification = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification] as? NSDictionary {
            let details = remoteNotification["details"] as! NSDictionary
            
            let latitude = (details["latitude"] as! NSString).doubleValue
            let longitude = (details["longitude"] as! NSString).doubleValue
            let notes = (details["notes"] as! NSString)
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let incidentView = mainStoryboard.instantiateViewController(withIdentifier: "incidentLocation") as! IncidentLocation
            
            incidentView.latitude = latitude
            incidentView.longitude = longitude
            incidentView.notes = notes as String!
            let activeVc = UIApplication.shared.keyWindow?.rootViewController
            activeVc?.present(incidentView, animated: false, completion: nil)

        }
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data){
        let token = String(format: "%@", deviceToken as CVarArg)
        let formattedToken = token.replacingOccurrences(of: " ", with: "")
        HTTP.device_token = formattedToken
    }
    
    func registerForRemoteNotification() {
                
        // If >= iOS 10, then use new method of registering for push notifications
        if #available(iOS 10.0, *) {
            let center  = UNUserNotificationCenter.current()
            center.delegate = self
            center.requestAuthorization(options: [.sound, .alert, .badge]) { (granted, error) in
                if error == nil{
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
            
        // If < iOS 10, then use old way
        else {
            UIApplication.shared.registerUserNotificationSettings(UIUserNotificationSettings(types: [.sound, .alert, .badge], categories: nil))
            UIApplication.shared.registerForRemoteNotifications()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // Get remote notification data....
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]){        
        if let aps = userInfo["details"] as? NSDictionary {
            let latitude = (aps["latitude"] as! NSString).doubleValue
            let longitude = (aps["longitude"] as! NSString).doubleValue
            let notes = (aps["notes"] as! NSString)
            showIncidentLocation(latitude: latitude, longitude: longitude, notes: notes as String)
        }
    }

    
    func showIncidentLocation(latitude: Float64, longitude: Float64, notes: String){
        
        self.window!.rootViewController?.dismiss(animated: false, completion: nil)

        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let incidentView = mainStoryboard.instantiateViewController(withIdentifier: "incidentLocation") as! IncidentLocation
        
        incidentView.latitude = latitude
        incidentView.longitude = longitude
        incidentView.notes = notes
        self.window?.makeKeyAndVisible()
        let activeVc = UIApplication.shared.keyWindow?.rootViewController
        activeVc?.present(incidentView, animated: false, completion: nil)
    }

}

