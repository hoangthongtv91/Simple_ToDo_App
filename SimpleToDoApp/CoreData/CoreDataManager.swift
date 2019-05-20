//
//  CoreDataManager.swift
//  SimpleToDoApp
//
//  Created by Thong Hoang Nguyen on 2019-05-17.
//  Copyright © 2019 Thong Hoang Nguyen. All rights reserved.
//

import Foundation
import CoreData
struct CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ToDoModel")
        container.loadPersistentStores(completionHandler: { (container, error) in
            if let error = error {
                fatalError("Loading persistent store failed: \(error)")
            }
        })
        return container
    }()
    
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch let Saveerr{
                let err = Saveerr as NSError
                fatalError("Unsolved error \(err): \(err.userInfo)")
            }
        }
    }
}
