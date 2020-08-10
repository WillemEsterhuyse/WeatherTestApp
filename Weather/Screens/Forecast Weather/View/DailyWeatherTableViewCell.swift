import UIKit

public protocol WeatherCell: class {
    var weatherIconImage: UIImageView! { get }
    var timeLabel: UILabel! { get }
    var descriptionLabel: UILabel! { get }
    var temperatureLabel: UILabel! { get }
}

class DailyWeatherTableViewCell: UITableViewCell, WeatherCell, ReusableView {    
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    @IBOutlet weak var timeLabel: UILabel! {
        didSet {
            timeLabel.font = theme.fonts.subHeadlineFont
            timeLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var descriptionLabel: UILabel! {
        didSet {
            descriptionLabel.font = theme.fonts.bodyFont
            descriptionLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.font = theme.fonts.forecastTemperatureFont
            temperatureLabel.textColor = UIColor(named: "secondaryTextColor")
        }
    }
}
