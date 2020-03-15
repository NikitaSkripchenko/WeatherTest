//
//  SettingsEnums.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 15.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import Foundation

public struct LocationPoint {
    let longitude : String
    let latitude : String
}

public enum Units : String {
    case imperial
    case metric
    
    func getTemperatureSign() -> String {
        switch self {
        case .imperial:
            return "°F"
        case .metric:
            return "°C"
        }
    }
    
    func getDistanceSign() -> String {
        switch self {
        case .imperial:
            return "ft/s"
        case .metric:
            return "m/s"
        }
    }
}

public enum LanguagesList : String, CaseIterable {
    case ru = "Russian"
    case en = "English"
    
    init?(id : Int) {
        switch id {
        case 1: self = .ru
        case 2: self = .en
        default: return nil
        }
    }
}
