//
//  LanguagesViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit

class LanguagesViewController: UIViewController {

    weak var languageDelegate : LanguageDelegate?

    @IBOutlet weak var languagesTable: UITableView!
    var languages : [LanguagesList] = []
    var selectedLanguage : LanguagesList!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
    }
    
    func setupTable() {
        for i in LanguagesList.allCases {
            languages.append(i)
        }
        languagesTable.delegate = self
        languagesTable.dataSource = self
        languagesTable.tableFooterView = UIView()
        languagesTable.register(UITableViewCell.self, forCellReuseIdentifier: "cellID")
        languagesTable.reloadData()
    }
}

extension LanguagesViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellID", for: indexPath)
        let language = languages[indexPath.row]
        cell.textLabel?.text = language.rawValue
        if language == self.selectedLanguage {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedLanguage = languages[indexPath.row]
        self.selectedLanguage = selectedLanguage
        self.languageDelegate?.change(for: selectedLanguage)
        tableView.reloadData()
    }
}
