import UIKit
import Swinject

class ForecastCoordinator: Coordinator {
    public var container: Container
    public var children: [Coordinator] = []
    public let router: Router
    
    // MARK: - Object Lifecycle
    public init(router: Router, container: Container) {
        self.router = router
        self.container = container
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = container.resolve(ForecastViewController.self)!
        viewController.delegate = self
        viewController.tabBarItem = UITabBarItem(title: "Forecast", image: UIImage(named: "forecast"), selectedImage: UIImage(named: "forecast"))
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension ForecastCoordinator: ForecastViewControllerDelegate {
    func forecastViewControllerDidReceiveError(_ viewController: ForecastViewController, description: String) {
        viewController.presentAlertAction(withTitle: "Ups, Something Happenned", message: description)
    }
    
    func forecastViewControllerDidReceiveNetworkError(_ viewController: ForecastViewController) {
        viewController.presentAlertAction(withTitle: "Ups, Network Error", message: "You seem to be offline, or the service is unavailable. Please, try it again later.")
    }
    
    func forecastViewControllerDidReceiveLocationError(_ viewController: ForecastViewController) {
        let alertAction = UIAlertAction(title: "Enable location service", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        viewController.presentAlertAction(withTitle: "Location Service Turned Off", message: "Enable location permissions in your device settings to localizate your current position.", alertActions: [alertAction])
    }
}
