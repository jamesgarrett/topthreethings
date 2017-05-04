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
    @IBOutlet fileprivate weak var clearBarButtonItem: UIBarButtonItem!

    fileprivate var taskDay: Day!
    fileprivate var taskManager: TaskManager?

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        customizeTableView()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground(_:)), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(significantTimeChangeDidOccur(_:)), name: .UIApplicationSignificantTimeChange, object: nil)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = taskManager {
            loadTasks()
        } else {
            taskManager = TaskManager()
            loadTasks()
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
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
        guard let taskManager = taskManager else { return }
        taskDay = taskManager.fetchTaskDayForToday()
        updateUI()
    }

    fileprivate func updateTask(from textView: UITextView) {
        let taskIndex: TaskManager.DayTaskIndex
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
        taskManager?.updateTask(for: taskDay, at: taskIndex, with: textView.text)
    }

    fileprivate func updateUI() {
        guard let taskManager = taskManager else { return }
        firstTaskTextView.text = taskManager.descriptionOfTask(for: taskDay, at: .first) ?? ""
        secondTaskTextView.text = taskManager.descriptionOfTask(for: taskDay, at: .second) ?? ""
        thirdTaskTextView.text = taskManager.descriptionOfTask(for: taskDay, at: .third) ?? ""
        firstTaskLabel.textColor = firstTaskTextView.text.isEmpty ? ColorPalette.inactiveGrayColor : ColorPalette.activeGrayColor
        secondTaskLabel.textColor = secondTaskTextView.text.isEmpty ? ColorPalette.inactiveGrayColor : ColorPalette.activeGrayColor
        thirdTaskLabel.textColor = thirdTaskTextView.text.isEmpty ? ColorPalette.inactiveGrayColor : ColorPalette.activeGrayColor
        updateClearButton()
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    fileprivate func updateClearButton() {
        if !thirdTaskTextView.text.isEmpty {
            clearBarButtonItem.image = #imageLiteral(resourceName: "topThree-allFilled")
        } else if !secondTaskTextView.text.isEmpty {
            clearBarButtonItem.image = #imageLiteral(resourceName: "topThree-2Filled")
        } else if !firstTaskTextView.text.isEmpty {
            clearBarButtonItem.image = #imageLiteral(resourceName: "topThree-1Filled")
        } else {
            clearBarButtonItem.image = #imageLiteral(resourceName: "topThree-noneFilled")
        }
    }

    func willEnterForeground(_ notification: Notification) {
        loadTasks()
    }

    func significantTimeChangeDidOccur(_ notification: Notification) {
        loadTasks()
    }

    // MARK: - Actions

    @IBAction func clearButtonPressed(_ sender: UIBarButtonItem) {
        view.endEditing(true)
        taskManager?.clearTasks(for: taskDay)
        updateUI()
    }
}

// MARK: - Table view delegate

extension TasksTableViewController {

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

}

// MARK: - Text view delegate

extension TasksTableViewController: UITextViewDelegate {

    func textViewDidChange(_ textView: UITextView) {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        label(for: textView)?.textColor = ColorPalette.activeGrayColor
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        updateTask(from: textView)
        updateClearButton()
        if textView.text.isEmpty {
            label(for: textView)?.textColor = ColorPalette.inactiveGrayColor
        }
    }

}
