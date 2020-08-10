import Alamofire

public enum OpenWeatherRoute {
    case currentWeather(lat: Double, lng: Double)
    case forecast(lat: Double, lng: Double)
}

extension OpenWeatherRoute: Route {
    var version: String {
        return "2.5"
    }
    
    var baseURL: String {
        return "https://api.openweathermap.org/data/\(version)"
    }
    
    var method: HTTPMethod {
        switch self {
        case .currentWeather:
            return .get
        case .forecast:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .currentWeather:
            return "/weather"
        case .forecast:
            return "/forecast"
        }
    }
    
    var apiKey: String {
        let file = Bundle.main.path(forResource: "OpenWeatherMap", ofType: "plist")!
        let dictionary = NSDictionary(contentsOfFile: file)!
        return dictionary["key"] as! String
    }
    
    var parameters: Parameters? {
        switch self {
        case .currentWeather(let lat, let lng):
            return [
                "lat": lat,
                "lon": lng,
                "units": "metric",
                "appid": apiKey
            ]
        case .forecast(let lat, let lng):
            return [
                "lat": lat,
                "lon": lng,
                "units": "metric",
                "appid": apiKey
            ]
        }
    }
}
