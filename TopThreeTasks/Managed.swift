//
//  Managed.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/3/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import CoreData

protocol Managed: class, NSFetchRequestResult {

    static var entity: NSEntityDescription { get }
    static var entityName: String { get }
    static var defaultSortDescriptors: [NSSortDescriptor] { get }
    static var defaultPredicate: NSPredicate { get }
    var managedObjectContext: NSManagedObjectContext? { get }

}

extension Managed where Self: NSManagedObject {

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    static var entity: NSEntityDescription {
        return entity()
    }
    static var entityName: String {
        return entity.name!
    }
    static var defaultPredicate: NSPredicate {
        return NSPredicate(value: true)
    }

    static var sortedFetchRequest: NSFetchRequest<Self> {
        let request: NSFetchRequest<Self> = Self.fetchRequest() as! NSFetchRequest<Self>
        request.sortDescriptors = defaultSortDescriptors
        request.predicate = defaultPredicate
        return request
    }

    static func sortedFetchRequest(with predicate: NSPredicate) -> NSFetchRequest<Self> {
        let request = sortedFetchRequest
        if let existingPredicate = request.predicate {
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [existingPredicate, predicate])
            request.predicate = compoundPredicate
        } else {
            request.predicate = predicate
        }
        return request
    }

    static func findOrCreate(in context: NSManagedObjectContext, matching predicate: NSPredicate, configure: (Self) -> ()) -> Self {
        guard let object = findOrFetch(in: context, matching: predicate) else {
            let newObject = Self(context: context)
            configure(newObject)
            return newObject
        }
        return object
    }

    static func findOrFetch(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        guard let object = materializedObject(in: context, matching: predicate) else {
            return fetch(in: context) { request in
                request.predicate = predicate
                request.returnsObjectsAsFaults = false
                request.fetchLimit = 1
            }.first
        }
        return object
    }

    static func fetch(in context: NSManagedObjectContext, configure: (NSFetchRequest<Self>) -> () = { _ in }) -> [Self] {
        let request: NSFetchRequest<Self> = Self.fetchRequest() as! NSFetchRequest<Self>
        configure(request)
        return try! context.fetch(request)
    }

    static func count(in context: NSManagedObjectContext, configure: (NSFetchRequest<Self>) -> () = { _ in }) -> Int {
        let request: NSFetchRequest<Self> = Self.fetchRequest() as! NSFetchRequest<Self>
        configure(request)
        return try! context.count(for: request)
    }

    static func materializedObject(in context: NSManagedObjectContext, matching predicate: NSPredicate) -> Self? {
        for object in context.registeredObjects where !object.isFault {
            guard let result = object as? Self, predicate.evaluate(with: result) else { continue }
            return result
        }
        return nil
    }

}
