//
//  WidgetKit.swift
//  WidgetKit
//
//  Created by Trexoz MCL on 13.07.2020.
//  Copyright © 2020 nktskr. All rights reserved.
//

import WidgetKit
import SwiftUI
import CoreLocation

class CllocationService: NSObject {
    let locationManager = CLLocationManager()
    var point = LocationPoint(longitude: "", latitude: "")
    func getPoint(completion: @escaping (LocationPoint) -> Void) {
        completion(point)
    }
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}
extension CllocationService: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue = locations.last else { return }
        print("locations = \(locValue.coordinate.latitude) \(locValue.coordinate.longitude)")
        self.point = LocationPoint(longitude: String(locValue.coordinate.longitude), latitude: String(locValue.coordinate.latitude))
    }
}

struct Provider: TimelineProvider {
    
    let router      = Router<WeatherEndPoint>()
    let repository  = Repository()
    var service = CllocationService()
    
    //var point : LocationPoint = CllocationService()
    var units : Units = .metric
    var language : LanguagesList = .en
    
    
    func getWeather(completion: (([ForecastModel]) -> Void)? = nil) {
        service.getPoint { (point) in
            repository.getSchedule(router: router, point: point, units: units, language: language) { (weatherForecast, error) in
                if error == nil {
                    var forecastModel = [ForecastModel]()
                    if let weather = weatherForecast {
                        for i in weather.list {
                            let item = ForecastModel(icon: i.weather![0].icon!, date: self.getDate(from: i.dtTxt), time: self.getTime(from: i.dtTxt), description: i.weather![0].weatherDescription!, temp: "\((i.main!.temp?.toInt())!)")
                            forecastModel.append(item)
                            
                        }
                    }
                    completion?(forecastModel)
                }
            }
        }
    }
     
    private func getDay(date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        
        let dateFormatter_ = DateFormatter()
        dateFormatter_.dateFormat = "yyyy-MM-dd"
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
            dateFormatter.dateFormat = "HH:mm a"
            let dateCut = dateFormatter.string(from: date)
            return dateCut
        }
        return ""
    }
    
    public typealias Entry = SimpleEntry
    
    public func snapshot(with context: Context, completion: @escaping (SimpleEntry) -> ()) {
        self.getWeather { (updates) in
            let entry = SimpleEntry(date: Date(), weather: updates)
            completion(entry)
        }
    }

    public func timeline(with context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        self.getWeather { (updates) in
            let entry = SimpleEntry(date: Date(), weather: updates)
            // Refresh the data every two minutes:
            let expiryDate = Calendar
                .current.date(byAdding: .second, value: 10,
                              to: Date()) ?? Date()
            let timeline = Timeline(entries: [entry], policy: .after(expiryDate))
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    public let date: Date
    public var weather: [ForecastModel]
}


struct WidgetKitEntryView : View {
    var entry: Provider.Entry
    public var weather: [ForecastModel]

    var body: some View {
        Text(entry.date, style: .time)
    }
}

@main
struct AllLinesWidget: Widget {
    public var body: some WidgetConfiguration {
        StaticConfiguration(kind: "All Lines",
                            provider: Provider(),
                            placeholder: AllLinesPlaceholderView()) { entry in
            ContentView(updates: entry.weather, height: 50)
        }
        .configurationDisplayName("Tube Status")
        .description("See the status board for all underground lines")
        //.supportedFamilies([.systemLarge])
    }
}

struct AllLinesPlaceholderView: View {
    var body: some View {
        GeometryReader { metrics in
            ContentView(updates: [ForecastModel(icon: "", date: "", time: "", description: "", temp: "sadsfs")], height: metrics.size.height)
        }
    }
}

public struct ContentView: View {
    let updates: [ForecastModel]
    let displayReason: Bool
    let height: CGFloat

    init(updates: [ForecastModel], displayReason: Bool = false, height: CGFloat) {
        self.updates = updates
        self.displayReason = displayReason
        self.height = height
    }

    public var body: some View {
        VStack(spacing: 0) {
            ForEach(updates) { update in
                VStack {
                    Text(update.time ?? "0")
                    Text(update.temp ?? "0")
                }
                .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(updates: [ForecastModel(icon: "", date: "", time: "", description: "", temp: "sadsfs")], height: 60)
    }
}
