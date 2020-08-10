import Foundation

struct CurrentWeather {
    let icon: String
    let title: String
    let fullDescription: String
    let temperature: Double
    let humidity: Int?
    let pressure: Double?
    let wind: Wind
    let rain: Double?
    
    struct Wind {
        let deg: Double?
        let speed: Double?
    }
}

extension CurrentWeather {
    init(response: CurrentWeatherForecastResponse) {
        let weather = response.weather.first!
        
        self.icon = weather.icon
        self.title = weather.main
        self.fullDescription = weather.weatherDescription
        self.temperature = response.main.temperature
        self.humidity = response.main.humidity
        self.pressure = response.main.pressure
        self.wind = Wind(deg: response.wind.deg, speed: response.wind.speed)
        self.rain = response.rain?.volume
    }
}
