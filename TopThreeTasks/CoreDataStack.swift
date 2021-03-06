//
//  CoreDataStack.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/3/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import CoreData

final class CoreDataStack {
    static let shared = CoreDataStack()
    var isPersistentStoreReady = false
    var persistentContainer = NSPersistentContainer(name: "TopThreeTasks")

    func loadPersistentContainer(completion: @escaping () -> ()) {
        persistentContainer.loadPersistentStores { (persistentStoreDescriptor, error) in
            guard error == nil else {
                fatalError()
            }
            self.isPersistentStoreReady = true
            completion()
        }
    }

    @discardableResult func save() -> Bool {
        return persistentContainer.viewContext.saveOrRollback()
    }
}
