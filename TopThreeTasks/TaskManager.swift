//
//  TaskManager.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/4/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import Foundation

final class TaskManager {

    enum DayTaskIndex: Int {
        case first = 0
        case second = 1
        case third = 2
    }

    private let coreDataStack = CoreDataStack.shared

    init() {
        if !coreDataStack.isPersistentStoreReady {
            coreDataStack.loadPersistentContainer {}
        }
    }

    func fetchTaskDayForToday() -> Day {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let predicate = NSPredicate(format: "date = %@", argumentArray: [startOfToday])
        let day = Day.findOrCreate(in: coreDataStack.persistentContainer.viewContext, matching: predicate) { (day) in
            day.date = startOfToday as NSDate
        }
        CoreDataStack.shared.save()
        return day
    }


    private func task(for day: Day, at index: DayTaskIndex) -> Task {
        guard let existingTask = day.tasks.first(where: { $0.id == Int16(index.rawValue) }) else {
            let newTask = Task(context: coreDataStack.persistentContainer.viewContext)
            newTask.id = Int16(index.rawValue)
            newTask.day = day
            return newTask
        }
        return existingTask
    }

    func descriptionOfTask(for day: Day, at index: DayTaskIndex) -> String? {
        return task(for: day, at: index).taskDescription
    }

    func updateTask(for day: Day, at index: DayTaskIndex, with text: String) {
        let taskToUpdate = task(for: day, at: index)
        taskToUpdate.taskDescription = text
        CoreDataStack.shared.save()
    }

    func clearTasks(for day: Day) {
        for task in day.tasks {
            coreDataStack.persistentContainer.viewContext.delete(task)
        }
        CoreDataStack.shared.save()
    }
}
