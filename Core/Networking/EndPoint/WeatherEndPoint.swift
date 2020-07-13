//
//  WeatherEndPoint.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import Foundation

public enum WeatherEndPoint {

    case getForecast(point: LocationPoint, units: Units, language: LanguagesList)

}

extension WeatherEndPoint : EndPointType {

    var environmentBaseUrl : String {
        return Constants.url
    }

    var baseUrl: URL {
        guard let url = URL(string: environmentBaseUrl) else { fatalError("baseURL could not be configured.") }
        return url
    }

    var path: String {
        switch self {
        case .getForecast:
            return "forecast"
        }
    }

    var httpMethod: HTTPMethods {
        .get
    }

    var task: HTTPTask {
        switch self {
        case .getForecast(let point, let units, let language):
            return .requestParameters(bodyParameters: nil, urlParameters: [
                "lat"   : point.latitude,
                "lon"   : point.longitude,
                "units" : units,
                "lang"  : language,
                "appid" : Constants.weatherAPIkey
            ])
        }
    }

    var headers: HTTPHeaders? {
        return nil
    }
}

