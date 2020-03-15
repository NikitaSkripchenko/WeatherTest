//
//  SettingsViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    weak var embededTable  : SettingsTableViewController?
    weak var unitsDelegate : UnitsDelegate?

    var selectedLanguage  : String!
    var selectedUnits     : Units!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "showTable") {
            
            let detailScene = segue.destination as! SettingsTableViewController
            self.embededTable = detailScene
            self.embededTable?.language = selectedLanguage
            self.embededTable?.units = selectedUnits
            self.embededTable?.unitsDelegate = self.unitsDelegate
        }
    }
}

