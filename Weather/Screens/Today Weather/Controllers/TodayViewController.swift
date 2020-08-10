import UIKit
import PromiseKit
import CoreLocation

protocol TodayViewControllerDelegate: class {
    func todayViewControllerDidPressShareButton(_ viewController: TodayViewController, text description: String?)
    func todayViewControllerDidReceiveNetworkError(_ viewController: TodayViewController)
    func todayViewControllerDidReceiveLocationError(_ viewController: TodayViewController)
    func todayViewControllerDidReceiveError(_ viewController: TodayViewController, description: String)
}

class TodayViewController: UIViewController {
    // MARK: - Instance Properties
    private let weatherService: WeatherService
    private let locationService: LocationService
    
    weak var delegate: TodayViewControllerDelegate?
    
    var indicator: UIView?
    var placemark: CLPlacemark?
    var viewModel: TodayWeatherViewModel?
    
    var todayView: TodayView! {
        guard isViewLoaded else { return nil }
        return (view as! TodayView)
    }
    
    // MARK: - Object Lifecycle
    init(locationService: LocationService, weatherService: WeatherService) {
        self.locationService = locationService
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel == nil {
            indicator = showActivityIndicatory(onView: self.view)
            requestCurrentLocation()
        }
    }
    
    // MARK: - Actions
    @IBAction func shareButtonTapped(_ sender: Any) {
        delegate?.todayViewControllerDidPressShareButton(self, text: viewModel?.description ?? "")
    }
    
    public func requestCurrentLocation() {
        locationService.getLocation().done { location in
            self.placemark = location
            self.requestWeather(for: location)
        }.ensure {
            guard let indicator = self.indicator else { return }
            self.removeIndicator(indicator: indicator)
        }.catch { (error) in
            switch error {
            case is CLError where (error as? CLError)?.code == .denied:
                self.delegate?.todayViewControllerDidReceiveLocationError(self)
            case is CLError where (error as? CLError)?.code == .network:
                self.delegate?.todayViewControllerDidReceiveNetworkError(self)
            case is CLLocationManager.PMKError:
                let error = error as! CLLocationManager.PMKError
                switch error {
                case .notAuthorized:
                    self.delegate?.todayViewControllerDidReceiveLocationError(self)
                }
            default:
                self.delegate?.todayViewControllerDidReceiveError(self, description: error.localizedDescription)
            }
        }
    }
    
    private func requestWeather(for location: CLPlacemark) {
        weatherService.getCurrentWeatherForecast(location: location).done { (weather) in
            self.viewModel = TodayWeatherViewModel(place: self.placemark!, weather: weather)
            self.viewModel?.configure(self.todayView)
        }.ensure {
            guard let indicator = self.indicator else { return }
            self.removeIndicator(indicator: indicator)
        }.catch { (error) in
            self.delegate?.todayViewControllerDidReceiveError(self, description: error.localizedDescription)
        }
    }
}
