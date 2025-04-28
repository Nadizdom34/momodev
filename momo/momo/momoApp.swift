import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics

@main
//Sets up firebase through the app delegate
struct momoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

