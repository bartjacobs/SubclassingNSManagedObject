//
//  AppDelegate.swift
//  Lists
//
//  Created by Bart Jacobs on 07/03/2017.
//  Copyright © 2017 Cocoacasts. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    let didSeedPersistentStore = "didSeedPersistentStore"

    let coreDataManager = CoreDataManager(modelName: "Lists")

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let managedObjectContext = coreDataManager.managedObjectContext

        // Seed Persistent Store
        seedPersistentStoreWithManagedObjectContext(managedObjectContext)
        
        // Create Fetch Request
        let fetchRequest: NSFetchRequest<List> = List.fetchRequest()

        // Add Sort Descriptor
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        do {
            let records = try managedObjectContext.fetch(fetchRequest)

            for record in records {
                print(record.name ?? "no name")
            }

        } catch {
            let fetchError = error as NSError
            print("\(fetchError), \(fetchError.userInfo)")
        }

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {

    }

    func applicationDidEnterBackground(_ application: UIApplication) {

    }

    func applicationWillEnterForeground(_ application: UIApplication) {

    }

    func applicationDidBecomeActive(_ application: UIApplication) {

    }

    func applicationWillTerminate(_ application: UIApplication) {

    }

    // MARK: - Helper Methods

    private func createRecordForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> NSManagedObject? {
        // Helpers
        var result: NSManagedObject?

        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: entity, in: managedObjectContext)

        if let entityDescription = entityDescription {
            // Create Managed Object
            result = NSManagedObject(entity: entityDescription, insertInto: managedObjectContext)
        }
        
        return result
    }

    private func fetchRecordsForEntity(_ entity: String, inManagedObjectContext managedObjectContext: NSManagedObjectContext) -> [NSManagedObject] {
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)

        // Helpers
        var result = [NSManagedObject]()

        do {
            // Execute Fetch Request
            let records = try managedObjectContext.fetch(fetchRequest)

            if let records = records as? [NSManagedObject] {
                result = records
            }

        } catch {
            print("Unable to fetch managed objects for entity \(entity).")
        }
        
        return result
    }

    private func seedPersistentStoreWithManagedObjectContext(_ managedObjectContext: NSManagedObjectContext) {
        guard !UserDefaults.standard.bool(forKey: didSeedPersistentStore) else { return }

        let listNames = ["Home", "Work", "Leisure"]

        for listName in listNames {
            // Create List
            if let list = createRecordForEntity("List", inManagedObjectContext: managedObjectContext) as? List {
                // Populate List
                list.name = listName
                list.createdAt = NSDate()

                // Add Items
                for i in 1...10 {
                    // Create Item
                    if let item = createRecordForEntity("Item", inManagedObjectContext: managedObjectContext) as? Item {
                        // Set Attributes
                        item.name = "Item \(i)"
                        item.createdAt = NSDate()
                        item.completed = (i % 3 == 0)

                        // Set List Relationship
                        item.list = list
                    }
                }
            }
        }
        
        do {
            // Save Managed Object Context
            try managedObjectContext.save()

        } catch {
            print("Unable to save managed object context.")
        }

        // Update User Defaults
        UserDefaults.standard.set(true, forKey: didSeedPersistentStore)
    }

}
