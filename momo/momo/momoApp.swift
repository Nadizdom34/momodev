import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics

@main
struct momoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

