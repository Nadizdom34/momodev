//
//  momoApp.swift
//  momo
//
//  Created by William Acosta on 3/4/25.
//

import SwiftUI

@main
struct momoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
