import UIKit
import PromiseKit
import CoreLocation

protocol ForecastViewControllerDelegate: class {
    
    func forecastViewControllerDidReceiveNetworkError(_ viewController: ForecastViewController)
    func forecastViewControllerDidReceiveLocationError(_ viewController: ForecastViewController)
    func forecastViewControllerDidReceiveError(_ viewController: ForecastViewController, description: String)
}

final class ForecastViewController: UIViewController {
    // MARK: - Instance Properties
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self,
                                 action: #selector(refresh(_:)),
                                 for: UIControl.Event.valueChanged)

        refreshControl.attributedTitle = NSAttributedString(string: "Fetching Weather")
        return refreshControl
    }()
    
    private let weatherService: WeatherService
    private let locationService: LocationService
    
    weak var delegate: ForecastViewControllerDelegate?
    
    var indicator: UIView?
    var placemark: CLPlacemark?
    var viewModel: ForecastViewModel?
    
    var forecastView: ForecastView! {
        guard isViewLoaded else { return nil }
        return (view as! ForecastView)
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        forecastView.tableView.dataSource = self
        forecastView.tableView.delegate = forecastView
        forecastView.tableView.addSubview(refreshControl)
        
        registerCellForReuse()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if viewModel == nil {
            indicator = showActivityIndicatory(onView: self.view)
            requestCurrentLocation()
        }
    }
    
    @objc func refresh(_ sender: UIRefreshControl) {
        self.requestCurrentLocation()
    }
    
    private func registerCellForReuse() {
        forecastView.tableView.register(DailyWeatherTableViewCell.nib, forCellReuseIdentifier: DailyWeatherTableViewCell.reuseIdentifier)
    }
    
    private func requestCurrentLocation() {
        locationService.getLocation().done { location in
            self.placemark = location
            self.requestWeather(for: location)
        }.ensure {
            self.refreshControl.endRefreshing()
            
            guard let indicator = self.indicator else { return }
            self.removeIndicator(indicator: indicator)
        }.catch { (error) in
            switch error {
            case is CLError where (error as? CLError)?.code == .denied:
                self.delegate?.forecastViewControllerDidReceiveLocationError(self)
                
            case is CLError where (error as? CLError)?.code == .network:
                self.delegate?.forecastViewControllerDidReceiveNetworkError(self)
                
            case is CLLocationManager.PMKError:
                let error = error as! CLLocationManager.PMKError
                switch error {
                case .notAuthorized:
                    self.delegate?.forecastViewControllerDidReceiveLocationError(self)
                }
                
            default:
                self.delegate?.forecastViewControllerDidReceiveError(self, description: error.localizedDescription)
            }
        }
    }
    
    private func requestWeather(for location: CLPlacemark) {
        weatherService.getWeeklyWeatherForecast(location: location).done { (weathers) in
            self.viewModel = ForecastViewModel(place: self.placemark!, forecast: weathers)
            self.viewModel?.configureTitleForNavigationBar(self.forecastView)
            self.forecastView.tableView.reloadData()
            }.ensure {
                self.refreshControl.endRefreshing()
                
                guard let indicator = self.indicator else { return }
                self.removeIndicator(indicator: indicator)
            }.catch { (error) in
                print(error)
                self.delegate?.forecastViewControllerDidReceiveError(self, description: error.localizedDescription)
        }
    }
}

extension ForecastViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel?.numberOfSections ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberOfRowsInSection(section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel?.configureTitleForHeaderInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = forecastView.tableView.dequeueReusableCell(withIdentifier: DailyWeatherTableViewCell.reuseIdentifier, for: indexPath) as? DailyWeatherTableViewCell else {
            return self.tableView(tableView, cellForRowAt: indexPath)
        }
        
        viewModel?.configureDailyWeatherCell(cell, for: indexPath)
        cell.selectionStyle = .none
        
        return cell

    }
}
