//
//  ViewController.swift
//  WeatherTest
//
//  Created by Trexoz MCL on 14.03.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import UIKit
import CoreLocation

class MainViewController: UIViewController {

    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var weatherTable: UITableView!

    let locationManager = CLLocationManager()

    let router      = Router<WeatherEndPoint>()
    let repository  = Repository()
    
    var point : LocationPoint?
    var units : Units = .metric
    var language : LanguagesList = .en
    
    var sections = [ForecastSection]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        setupTable()
    }

    func getWeatherForecast() {
        repository.getSchedule(router: router, point: self.point!, units: units, language: language) { (weatherForecast, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let weather = weatherForecast {

                        var forecastModel = [ForecastModel]()
                        for i in weather.list {
                            let item = ForecastModel(icon: "icon", date: self.getDate(from: i.dtTxt), time: self.getTime(from: i.dtTxt), description: i.weather![0].weatherDescription!, temp: "\((i.main!.temp?.toInt())!)")
                            forecastModel.append(item)
                        }
                        self.sections = ForecastSection.group(forecastItems: forecastModel)
                        self.sections.sort{ lhs, rhs in lhs.day < rhs.day}
                        self.weatherTable.reloadData()

                        
                        self.title = weather.city.name
                        self.sunriseLabel.text = self.milisecondsToDateString(milisecond: weather.city.sunrise)
                        self.sunsetLabel.text = self.milisecondsToDateString(milisecond: weather.city.sunset)
                        self.temperatureLabel.text = "\(weather.list[0].main?.temp?.toInt() ?? 0) \(self.units.getTemperatureSign())"
                        self.weatherDescription.text = weather.list[0].weather![0].weatherDescription
                        self.windLabel.text = "\(weather.list[0].wind!.speed ?? 0.0) \(self.units.getDistanceSign())"
                    }
                }
            }
        }
    }

    func milisecondsToDateString(milisecond: Int) -> String {
        let dateVar = Date.init(timeIntervalSinceNow: TimeInterval(milisecond)/1000)
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm"
        let newDate = dateFormatter.string(from: dateVar)

        return newDate
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 100
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupTable() {
        weatherTable.dataSource = self
        weatherTable.delegate = self
        weatherTable.register(UINib(nibName: "WeatherTableViewCell", bundle: nil),forCellReuseIdentifier: "WeatherTableViewCell")
    }
    // "2020-03-19 15:00:00"
    // yyyy-mm-dd HH:mm:ss
    private func getDay(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let dateFormatter_ = DateFormatter()
        dateFormatter_.dateFormat = "yyyy-mm-dd"
        let day = dateFormatter_.date(from: date)!
        let dayInWeek = dateFormatter.string(from: day)
        return dayInWeek
    }
    
    private func getDate(from str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: str) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let dateCut = dateFormatter.string(from: date)
            return dateCut
        }
        return ""
    }
    
    private func getTime(from str: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = dateFormatter.date(from: str) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "HH:mm"
            let dateCut = dateFormatter.string(from: date)
            return dateCut
        }
        return ""
    }
}

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.point = LocationPoint(longitude: String(locValue.longitude), latitude: String(locValue.latitude))
        self.getWeatherForecast()
    }
}


extension MainViewController : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherTableViewCell", for: indexPath) as! WeatherTableViewCell

        let section = self.sections[indexPath.section]
        let headline = section.data[indexPath.row]
        cell.timeLabel?.text = headline.time
        cell.conditionDescriptionLabel?.text = headline.description
        cell.tempLabel?.text = headline.temp
        cell.unitsLabel?.text = units.getTemperatureSign()
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.sections[section]
        let date = self.getDay(date: section.day)
        return date
    }

    
}

struct ForecastSection {
    var day : String
    var data : [ForecastModel]
    
    static func group(forecastItems : [ForecastModel]) -> [ForecastSection] {
        let groups = Dictionary(grouping: forecastItems) { forecastItem in
            forecastItem.date
        }
        return groups.map(ForecastSection.init(day:data:))
    }
}

struct ForecastModel {
    let icon : String
    let date : String
    let time : String
    let description : String
    let temp : String
}
