import PromiseKit

protocol WeatherService: class {
    func getCurrentWeatherForecast(location: CLPlacemark) -> Promise<CurrentWeather>
    func getWeeklyWeatherForecast(location: CLPlacemark) -> Promise<[DailyWeather]>
}

final class OpenWeatherServiceImpl: WeatherService {
    let networking: Networking
    
    // MARK: - Object Lifecycle
    init(networking: Networking) {
        self.networking = networking
    }
    
    func getCurrentWeatherForecast(location: CLPlacemark) -> Promise<CurrentWeather> {
        let coordinate = location.location!.coordinate
        
        let result: Promise<CurrentWeatherForecastResponse>
        result = networking.responseDecodable(route: OpenWeatherRoute.currentWeather(lat: coordinate.latitude, lng: coordinate.longitude))
        
        return convert(result)
    }
    
    func getWeeklyWeatherForecast(location: CLPlacemark) -> Promise<[DailyWeather]> {
        let coordinate = location.location!.coordinate
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        let result: Promise<WeeklyForecastResponse>
        result = networking.responseDecodable(route: OpenWeatherRoute.forecast(lat: coordinate.latitude, lng: coordinate.longitude), decoder: decoder)
        
        return convert(result)
    }
    
    private func convert(_ input: Promise<CurrentWeatherForecastResponse>) -> Promise<CurrentWeather> {
        return input.then({ (response) -> Promise<CurrentWeather> in
            Promise.value(CurrentWeather(response: response))
        })
    }
    
    private func convert(_ input: Promise<WeeklyForecastResponse>) -> Promise<[DailyWeather]> {
        return input.map({ (response) -> [WeeklyForecastResponse.Item] in
            response.list
        }).mapValues({ (item) -> DailyWeather in
            return DailyWeather(response: item)
        })
    }
}
