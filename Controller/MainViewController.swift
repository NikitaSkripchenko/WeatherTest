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

    let locationManager = CLLocationManager()

    let router      = Router<WeatherEndPoint>()
    let repository  = Repository()
    
    var point : LocationPoint?
    var units : Units = .imperial
    var language : LanguagesList = .en

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "London"
        setupLocationManager()
        
    }
    
    func getWeatherForecast() {
        repository.getSchedule(router: router, point: self.point!, units: units, language: language) { (weatherForecast, error) in
            if error == nil {
                print(weatherForecast)
            }
        }
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

