//
//  AppDelegate.swift
//  momo
//
//  Created by William Acosta on 3/26/25.
//

import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    //Initializes firebase and keeps track of app analytics to store
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)

        // Access userId from UserDefaults
        if let userId = UserDefaults.standard.string(forKey: "userId") {
            print("User ID: \(userId)")
        } else {
            print("No user ID found")
        }

        return true
    }

    // Key method Firebase Phone Auth needs
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }

        // Handle other push notifications here (if any)
        completionHandler(.noData)
    }
}

