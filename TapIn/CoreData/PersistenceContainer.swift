//
//  NSPersistenceContainer+.swift
//  TapIn
//
//  Created by Fredrik Skjelvik on 25/01/2022.
//

import CoreData

class PersistentContainer: NSPersistentContainer {
    func saveContext(_ backgroundContext: NSManagedObjectContext? = nil) {
        let context = backgroundContext ?? viewContext
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
