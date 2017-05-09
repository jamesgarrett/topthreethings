//
//  LaunchViewController.swift
//  TopThreeTasks
//
//  Created by Ruslan Kamalov on 5/9/17.
//  Copyright © 2017 Ruslan Kamalov. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let _ = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(showTasksTableViewController), userInfo: nil, repeats: false)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showTasksTableViewController() {
        performSegue(withIdentifier: "showTasks", sender: self)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
