//
//  AppDelegate.swift
//  OneToTwentyFive
//
//  Created by 김성준 on 2017. 7. 23..
//  Copyright © 2017년 김성준. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let userDefaults = UserDefaults.standard

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
         saveData()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       loadData()
    }

    func applicationWillTerminate(_ application: UIApplication) {
    }

    func saveData() {
        let recordsData = NSKeyedArchiver.archivedData(withRootObject: Records.sharedInstance)
        userDefaults.set(recordsData, forKey: "recordsData")
    }
    
    func loadData() {
        guard let loadRecordsData = userDefaults.data(forKey: "recordsData") else { return }
        let loadRecordsObject = NSKeyedUnarchiver.unarchiveObject(with: loadRecordsData) as! Records
        Records.sharedInstance = loadRecordsObject
    }

}

