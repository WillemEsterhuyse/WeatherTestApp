import UIKit
import CoreLocation

public class ForecastViewModel {
    // MARK: - Instance Properties
    private let place: CLPlacemark
    private var forecast: [DateComponents: [DailyWeather]]
    
    // MARK: - Object Lifecycle
    init(place: CLPlacemark, forecast: [DailyWeather]) {
        self.place = place
        
        self.forecast = Dictionary(grouping: forecast) { (weather) -> DateComponents in
            let date = Calendar.current.dateComponents([.day, .month, .year, .weekday], from: weather.date)
            return date
        }
    }
    
    public var city: String {
        guard let country = place.locality else {
            return "Forecast"
        }
        
        return country
    }
    
    public var numberOfSections: Int {
        return forecast.count
    }
}

extension ForecastViewModel {
    private func isCurrentDateInToday(from date: DateComponents) -> Bool {
        guard let date = Calendar.current.date(from: date) else { return false }
        
        return Calendar.current.isDateInToday(date)
    }
    
    private func getKeyFrom(_ section: Int) -> DateComponents {
        return Array(forecast.keys).sorted(by: { (firstDate, secondDate) -> Bool in
            let calendar = Calendar.current
            return calendar.date(from: firstDate)!.timeIntervalSince1970 < calendar.date(from: secondDate)!.timeIntervalSince1970
        })[section]
    }
    
    private func getWeatherFrom(_ indexPath: IndexPath) -> DailyWeather? {
        let key = getKeyFrom(indexPath.section)
        let weather = forecast[key]?[indexPath.row]
        return weather
    }
}

extension ForecastViewModel {
    public func numberOfRowsInSection(_ section: Int) -> Int {
        let key = getKeyFrom(section)
        return forecast[key]!.count
    }
    
    public func configureTitleForHeaderInSection(_ section: Int) -> String? {
        let calendar = Calendar.current
        
        let dateComponent = getKeyFrom(section)
        
        if isCurrentDateInToday(from: dateComponent) {
            return "Today"
        } else {
            let localizedWeekday = calendar.weekdaySymbols[dateComponent.weekday! - 1]
            return localizedWeekday
        }
    }
    
    public func configureTitleForNavigationBar(_ view: ForecastView) {
        view.navigationBar.topItem?.title = city
    }
    
    public func configureDailyWeatherCell(_ view: WeatherCell, for indexPath: IndexPath) {
        guard let weather = getWeatherFrom(indexPath) else { return }
        
        let format = DateFormatter()
        format.dateFormat = "HH:mm"
        
        view.timeLabel.text = format.string(from: weather.date)
        view.descriptionLabel.text = weather.description
        view.temperatureLabel.text = "\(String(format: "%.0f", weather.temperature)) °"
    }
}
