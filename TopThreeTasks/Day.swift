//
//  Day+CoreDataClass.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/3/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import Foundation
import CoreData

public class Day: NSManagedObject {

    enum DayTaskIndex: Int {
        case first = 0
        case second = 1
        case third = 2
    }

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Day> {
        return NSFetchRequest<Day>(entityName: "Day")
    }

    @NSManaged public var date: NSDate
    @NSManaged private var tasks: Set<Task>

    private func task(with index: DayTaskIndex) -> Task {
        guard let existingTask = tasks.first(where: { $0.id == Int16(index.rawValue) }) else {
            let newTask = Task(context: managedObjectContext!)
            newTask.id = Int16(index.rawValue)
            newTask.day = self
            return newTask
        }
        return existingTask
    }

    func descriptionOfTask(at index: DayTaskIndex) -> String? {
        return task(with: index).taskDescription
    }

    func updateTask(at index: DayTaskIndex, with text: String) {
        let taskToUpdate = task(with: index)
        taskToUpdate.taskDescription = text
    }

}

extension Day: Managed {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "date", ascending: false)]
    }
}
