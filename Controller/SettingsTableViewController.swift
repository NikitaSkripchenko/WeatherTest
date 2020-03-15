//
//  SettingsTableViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit


class SettingsTableViewController: UITableViewController {

    weak var unitsDelegate    : UnitsDelegate?
    weak var languageDelegate : LanguageDelegate?

    @IBOutlet weak var selectedLanguageLabel: UILabel!
    @IBOutlet weak var metricSystemControl: UISegmentedControl!

    @IBAction func segmentControlChanged(_ sender: Any) {
        switch metricSystemControl.selectedSegmentIndex {
        case 0:
            units = .metric
        default: //1
            units = .imperial
        }
        unitsDelegate?.change(for: units)
    }

    var language : LanguagesList!
    var units : Units!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupData()
        tableView.tableFooterView = UIView()
        self.clearsSelectionOnViewWillAppear = false
    }
    
    func setupData() {
        selectedLanguageLabel.text = language.rawValue
        switch units {
        case .imperial:
            metricSystemControl.selectedSegmentIndex = 1
        default:
            metricSystemControl.selectedSegmentIndex = 0
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let selectLanguageViewController = storyboard.instantiateViewController(withIdentifier: "LanguagesViewController") as! LanguagesViewController
            selectLanguageViewController.selectedLanguage = self.language
            selectLanguageViewController.languageDelegate = self.languageDelegate
            self.navigationController?.pushViewController(selectLanguageViewController, animated: true)
        }
    }
}
