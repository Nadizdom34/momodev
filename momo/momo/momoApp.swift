//
//  momoApp.swift
//  momo
//
//  Created by William Acosta on 3/4/25.
//

import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics

@main
struct momoApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
