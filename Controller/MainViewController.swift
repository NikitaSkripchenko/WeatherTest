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
    let locationManager = CLLocationManager()

    let router      = Router<WeatherEndPoint>()
    let repository  = Repository()
    
    var point : LocationPoint?
    var units : Units = .metric
    var language : LanguagesList = .en

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLocationManager()
        
    }
    
    func getWeatherForecast() {
        repository.getSchedule(router: router, point: self.point!, units: units, language: language) { (weatherForecast, error) in
            if error == nil {
                DispatchQueue.main.async {
                    if let weather = weatherForecast {
                        self.title = weather.city.name
                        self.sunriseLabel.text = self.milisecondsToDateString(milisecond: weather.city.sunrise)
                        self.sunsetLabel.text = self.milisecondsToDateString(milisecond: weather.city.sunset)
                        self.temperatureLabel.text = "\((weather.list![0].main?.temp)!)°"
                        self.weatherDescription.text = weather.list![0].weather![0].weatherDescription
                        self.windLabel.text = "\(weather.list![0].wind!.speed ?? 0.0)"
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
}

extension MainViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        self.point = LocationPoint(longitude: String(locValue.longitude), latitude: String(locValue.latitude))
        self.getWeatherForecast()
    }
}

