import UIKit
import Swinject

class TodayCoordinator: Coordinator {
    public var container: Container
    public var children: [Coordinator] = []
    public let router: Router
    
    // MARK: - Object Lifecycle
    public init(router: Router, container: Container) {
        self.router = router
        self.container = container
    }
    
    func present(animated: Bool, onDismissed: (() -> Void)?) {
        let viewController = container.resolve(TodayViewController.self)!
        viewController.delegate = self
        viewController.tabBarItem = UITabBarItem(title: "Today", image: UIImage(named: "today"), selectedImage: UIImage(named: "today"))
        router.present(viewController, animated: animated, onDismissed: onDismissed)
    }
}

extension TodayCoordinator: TodayViewControllerDelegate {
    func todayViewControllerDidReceiveError(_ viewController: TodayViewController, description: String) {
        viewController.presentAlertAction(withTitle: "Ups, Something Happenned", message: description)
    }
    
    func todayViewControllerDidReceiveNetworkError(_ viewController: TodayViewController) {
        viewController.presentAlertAction(withTitle: "Ups, Network Error", message: "You seem to be offline, or the service is unavailable. Please, try it again later.")
    }
    
    func todayViewControllerDidReceiveLocationError(_ viewController: TodayViewController) {
        let alertAction = UIAlertAction(title: "Enable location service", style: .cancel) { _ in
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
        }
        
        viewController.presentAlertAction(withTitle: "Location Service Turned Off", message: "Enable location permissions in your device settings to localizate your current position.", alertActions: [alertAction])
    }
    
    func todayViewControllerDidPressShareButton(_ viewController: TodayViewController, text description: String?) {
        let activityViewController = UIActivityViewController(activityItems: [description ?? ""], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = viewController.view

        viewController.present(activityViewController, animated: true, completion: nil)
    }
}
