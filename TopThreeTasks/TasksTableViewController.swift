//
//  TasksTableViewController.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/3/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import UIKit

class TasksTableViewController: UITableViewController {

    @IBOutlet fileprivate weak var firstTaskLabel: UILabel!
    @IBOutlet fileprivate weak var firstTaskTextView: UITextView!
    @IBOutlet fileprivate weak var secondTaskLabel: UILabel!
    @IBOutlet fileprivate weak var secondTaskTextView: UITextView!
    @IBOutlet fileprivate weak var thirdTaskLabel: UILabel!
    @IBOutlet fileprivate weak var thirdTaskTextView: UITextView!

    fileprivate var taskDay: Day!

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        CoreDataStack.shared.loadPersistentContainer {
            self.loadTasks()
        }
        customizeTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Methods

    fileprivate func customizeTableView() {
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tableFooterView = UIView()
    }

    fileprivate func label(for textView: UITextView) -> UILabel? {
        switch textView {
        case firstTaskTextView:
            return firstTaskLabel
        case secondTaskTextView:
            return secondTaskLabel
        case thirdTaskTextView:
            return thirdTaskLabel
        default:
            return nil
        }
    }

    fileprivate func loadTasks() {
        let startOfToday = Calendar.current.startOfDay(for: Date())
        let predicate = NSPredicate(format: "date = %@", argumentArray: [startOfToday])
        let day = Day.findOrCreate(in: CoreDataStack.shared.persistentContainer.viewContext, matching: predicate) { (day) in
            day.date = startOfToday as NSDate
        }
        taskDay = day
        try! CoreDataStack.shared.persistentContainer.viewContext.save()
        firstTaskTextView.text = day.descriptionOfTask(at: .first) ?? ""
        secondTaskTextView.text = day.descriptionOfTask(at: .second) ?? ""
        thirdTaskTextView.text = day.descriptionOfTask(at: .third) ?? ""
    }

    fileprivate func saveTask(from textView: UITextView) {
        let taskIndex: Day.DayTaskIndex
        switch textView {
        case firstTaskTextView:
            taskIndex = .first
        case secondTaskTextView:
            taskIndex = .second
        case thirdTaskTextView:
            taskIndex = .third
        default:
            return
        }
        taskDay.updateTask(at: taskIndex, with: textView.text)
        try! CoreDataStack.shared.persistentContainer.viewContext.save()
    }

}

// MARK: - Table view delegate

extension TasksTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

extension TasksTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        label(for: textView)?.textColor = ColorPalette.activeGrayColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        saveTask(from: textView)
        if textView.text.isEmpty {
            label(for: textView)?.textColor = ColorPalette.inactiveGrayColor
        }
    }

}
