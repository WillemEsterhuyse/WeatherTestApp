import Foundation

struct WeeklyForecastResponse: Codable {
  let list: [Item]
  
  struct Item: Codable {
    let date: Date
    let main: MainClass
    let weather: [WeeklyForecastResponse.Weather]
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case main
        case weather
    }
  }
  
  struct MainClass: Codable {
    let temp: Double
  }
  
  struct Weather: Codable {
    let weatherDescription: String
    let icon: String
    
    enum CodingKeys: String, CodingKey {
        case weatherDescription = "description"
        case icon
    }
  }
}
