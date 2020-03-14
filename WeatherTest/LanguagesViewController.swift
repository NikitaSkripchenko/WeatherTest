//
//  LanguagesViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {

    @IBOutlet weak var languagesTable: UITableView!
    var languages = ["Russian", "English"]

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    func setupTable() {
        languagesTable.delegate = self
        languagesTable.dataSource = self
        languagesTable.tableFooterView = UIView()
        languagesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
    }
}

extension LanguagesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language
        cell.accessoryType = .checkmark
        return cell
    }
}
