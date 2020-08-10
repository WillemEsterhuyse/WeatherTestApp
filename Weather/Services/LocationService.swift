import PromiseKit
import CoreLocation

protocol LocationServiceDelegate: class {
    func openWeatherServiceDidReceivedNetworkError(_ viewController: UIViewController)
}

protocol LocationService: class {
    func getLocation() -> Promise<CLPlacemark>
}

class LocationServiceImpl: LocationService {
    let geocoder: CLGeocoder
    weak var delegate: LocationServiceDelegate?
    
    // MARK: - Object Lifecycle
    init(geocoder: CLGeocoder = .init()) {
        self.geocoder = geocoder
    }
    
     func getLocation() -> Promise<CLPlacemark> {
        return CLLocationManager.requestLocation()
                                .lastValue.then { (location) -> Promise<CLPlacemark> in
                                    return self.geocoder.reverseGeocode(location: location).firstValue
                                }
    }
    
}
