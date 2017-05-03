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

    fileprivate var taskLabels: [UILabel] {
        return [firstTaskLabel, secondTaskLabel, thirdTaskLabel]
    }

    fileprivate var tastTextViews: [UITextView] {
        return [firstTaskTextView, secondTaskTextView, thirdTaskTextView]
    }

    // MARK: - View Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
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
        guard textView.text.isEmpty else {
            return
        }
        label(for: textView)?.textColor = ColorPalette.inactiveGrayColor
    }

}
