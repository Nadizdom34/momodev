import UIKit
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

/// The AppDelegate class is responsible for configuring Firebase services at launch and handling background remote notifications.
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)

        if let userId = UserDefaults.standard.string(forKey: "userId") {
            print("User ID: \(userId)")
        } else {
            print("No user ID found")
        }

        return true
    }

/// Called when the application finishes launching and initializes Firebase and logs an app open event. Also checks for a stored user ID.
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if Auth.auth().canHandleNotification(userInfo) {
            completionHandler(.noData)
            return
        }

        completionHandler(.noData)
    }
}

