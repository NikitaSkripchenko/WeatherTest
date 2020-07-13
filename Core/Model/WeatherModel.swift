//
//  WeatherModel.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import Foundation
import UIKit

struct ForecastModel: Identifiable {
    var id: ObjectIdentifier = ObjectIdentifier(Int.self)
    
    let icon : String
    let date : String
    let time : String?
    let description : String
    let temp : String?
}

// MARK: - WeatherModel
struct WeatherModel: Codable {
    let cod: String?
    let message: Int?
    let cnt: Int?
    let list: [List]
    let city: City
    
    init(city: City = City()) {
        self.city = city
        self.cod = nil
        self.message = nil
        self.cnt = nil
        self.list = [List(dt: nil, main: nil, weather: nil, clouds: nil, wind:  nil, sys:  nil, dtTxt: "nil", rain: nil)]
    }
    
    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }
}

// MARK: - City
struct City: Codable {
    let id: Int
    let name: String
    let coord: Coord?
    let country: String
    let population: Int
    let timezone: Int
    let sunrise: Int
    let sunset: Int
    
    init(name: String = "London", id: Int = 1) {
        self.name = name
        self.id = id
        self.coord = nil
        self.country = ""
        self.population = 0
        self.timezone = 0
        self.sunrise = 0
        self.sunset = 0
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case coord = "coord"
        case country = "country"
        case population = "population"
        case timezone = "timezone"
        case sunrise = "sunrise"
        case sunset = "sunset"
    }
}

// MARK: - Coord
struct Coord: Codable {
    let lat: Double?
    let lon: Double?

    enum CodingKeys: String, CodingKey {
        case lat = "lat"
        case lon = "lon"
    }
}

// MARK: - List
struct List: Codable {
    let dt: Int?
    let main: MainClass?
    let weather: [Weather]?
    let clouds: Clouds?
    let wind: Wind?
    let sys: Sys?
    let dtTxt: String
    let rain: Rain?

    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case sys = "sys"
        case dtTxt = "dt_txt"
        case rain = "rain"
    }
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int?

    enum CodingKeys: String, CodingKey {
        case all = "all"
    }
}

// MARK: - MainClass
struct MainClass: Codable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressure: Int?
    let seaLevel: Int?
    let grndLevel: Int?
    let humidity: Int?
    let tempKf: Double?

    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure = "pressure"
        case seaLevel = "sea_level"
        case grndLevel = "grnd_level"
        case humidity = "humidity"
        case tempKf = "temp_kf"
    }
}

// MARK: - Rain
struct Rain: Codable {
    let the3H: Double?

    enum CodingKeys: String, CodingKey {
        case the3H = "3h"
    }
}

// MARK: - Sys
struct Sys: Codable {
    let pod: Pod?

    enum CodingKeys: String, CodingKey {
        case pod = "pod"
    }
}

enum Pod: String, Codable {
    case d = "d"
    case n = "n"
}

// MARK: - Weather
struct Weather: Codable {
    let id: Int?
    let main: MainEnum?
    let weatherDescription: String?
    let icon: String?

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case main = "main"
        case weatherDescription = "description"
        case icon = "icon"
    }
}

enum MainEnum: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Wind
struct Wind: Codable {
    let speed: Double?
    let deg: Int?

    enum CodingKeys: String, CodingKey {
        case speed = "speed"
        case deg = "deg"
    }
}

extension Double {
    func toInt() -> Int? {
        if self >= Double(Int.min) && self < Double(Int.max) {
            return Int(self)
        } else {
            return nil
        }
    }
}
