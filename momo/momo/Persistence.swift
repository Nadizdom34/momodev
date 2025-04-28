//
//  Persistence.swift
//  momo
//
//  Created by William Acosta & Nadezhda Dominguez Salinas on 3/4/25.
//

import CoreData
import SwiftUI
import Firebase
import FirebaseCore
import FirebaseFirestore
import FirebaseMessaging
import FirebaseAnalytics

//Saves data locally on user's device to provide a persistent user, by managing core data
struct PersistenceController {
    //Sets up one instance of persistance controller used throughout whole app
    static let shared = PersistenceController()
    //This is a preview instance that has in-memory storage
    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        //Creating a mock preview
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            //Taking care of errors when attempting to save preview data
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    //Container holds the core data and manages persistance
    let container: NSPersistentContainer
    //Intializes the persistance controller
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "momo")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        //Load the persistence store
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
              
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        //Merges the changes made
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
