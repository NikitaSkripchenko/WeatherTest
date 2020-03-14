//
//  EndPointType.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import Foundation

protocol EndPointType {

    var baseUrl: URL {get}
    var path: String {get}
    var httpMethod: HTTPMethods {get}
    var task: HTTPTask {get}
    var headers: HTTPHeaders? {get}

}
