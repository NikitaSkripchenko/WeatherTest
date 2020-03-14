//
//  SettingsTableViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
         self.clearsSelectionOnViewWillAppear = false
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let selectLanguageViewController = storyboard.instantiateViewController(withIdentifier: "LanguagesViewController") as! LanguagesViewController
            
            self.navigationController?.pushViewController(selectLanguageViewController, animated: true)
            
        }
    }
    
}
