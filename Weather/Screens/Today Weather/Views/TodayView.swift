import UIKit

public class TodayView: UIView {
    @IBOutlet weak var navigationBar: UINavigationBar! {
        didSet {
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: theme.fonts.navigationBarFont
            ]
            
            navigationBar.titleTextAttributes = attrs
        }
    }
    
    @IBOutlet weak var weatherIconImage: UIImageView!
    
    @IBOutlet weak var curentLocationImage: UIImageView! {
        didSet {
            curentLocationImage.isHidden = true
        }
    }
    
    @IBOutlet weak var currentLocationLabel: UILabel! {
        didSet {
            currentLocationLabel.text = ""
            currentLocationLabel.font = theme.fonts.subHeadlineFont
            currentLocationLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var temperatureLabel: UILabel! {
        didSet {
            temperatureLabel.text = "---"
            temperatureLabel.font = UIFont(name: "Arial", size: 30)
            temperatureLabel.textColor = UIColor.white//(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var humidityLabel: UILabel! {
        didSet {
            humidityLabel.text = "---"
            humidityLabel.font = theme.fonts.bodyFont
            humidityLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var precipitationLabel: UILabel! {
        didSet {
            precipitationLabel.text = "---"
            precipitationLabel.font = theme.fonts.bodyFont
            precipitationLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var pressureLabel: UILabel! {
        didSet {
            pressureLabel.text = "---"
            pressureLabel.font = theme.fonts.bodyFont
            pressureLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var windSpeedLabel: UILabel! {
        didSet {
            windSpeedLabel.text = "---"
            windSpeedLabel.font = theme.fonts.bodyFont
            windSpeedLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
    
    @IBOutlet weak var windDirectionLabel: UILabel! {
        didSet {
            windDirectionLabel.text = "---"
            windDirectionLabel.font = theme.fonts.bodyFont
            windDirectionLabel.textColor = UIColor(named: "primaryTextColor")
        }
    }
}
