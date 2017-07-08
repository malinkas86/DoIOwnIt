//
//  AppDelegate.swift
//  DoIOwnIt
//
//  Created by Malinka S on 2/16/17.
//  Copyright © 2017 Malinka S. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import XCGLogger
let log = XCGLogger.default

let themeColor = UIColor(red: 0.92, green: 0.73, blue: 0.04, alpha: 1.0) // gold color
let navbarColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha:1.0) // #1C1C1C
let navbarFont = UIFont(name: "DINCond-Medium", size: 22) ?? UIFont.systemFont(ofSize: 17)
var userMovies : [Movie] = []

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        if  let infoPlist = Bundle.main.infoDictionary,
            let googleInfoPlistLocation = infoPlist["GoogleInfoPlist"] as? String,
            let filePath = Bundle.main.path(forResource:googleInfoPlistLocation, ofType: "plist"),
            let firbaseOptions = FirebaseOptions(contentsOfFile: filePath) {
            
            FirebaseApp.configure(options: firbaseOptions)
            Database.database().isPersistenceEnabled = true
            
        }
        
        window?.tintColor = themeColor
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: navbarFont, // DIN Condensed
                                                            NSBackgroundColorAttributeName: navbarColor,
                                                            NSKernAttributeName : 5.0]
        
        //get app version number
        let appInfo = Bundle.main.infoDictionary! as Dictionary<String,AnyObject>
        let shortVersionString = appInfo["CFBundleShortVersionString"] as! String
        let bundleVersion = appInfo["CFBundleVersion"] as! String
        let applicationVersion = shortVersionString + "." + bundleVersion
        
        let defaults = UserDefaults.standard
            defaults.set(applicationVersion, forKey: "application_version")
            defaults.synchronize()
        
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
        return handled
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        Analytics.logEvent("app_entered_background", parameters: nil)
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        Analytics.logEvent("app_became_active", parameters: nil)
        FBSDKAppEvents.activateApp()
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        Analytics.logEvent("app_terminated", parameters: nil)
    }

}

