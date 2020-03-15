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

public enum LanguagesList : String {
    case ru = "Russian"
    case en = "English"
}
