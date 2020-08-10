import UIKit
import Alamofire
import PromiseKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    public lazy var window: UIWindow? = UIWindow(frame: UIScreen.main.bounds)
    public lazy var appDependency = AppDependency()
    public lazy var tabBarRouter = TabBarRouter(window: window!)
    public lazy var forecastCoordinator = ForecastCoordinator(router: tabBarRouter, container: appDependency.container)
    public lazy var homeCoordinator = TodayCoordinator(router: tabBarRouter, container: appDependency.container)

    func application(_: UIApplication, willFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        appDependency.setupDependencies()
        return true
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        homeCoordinator.present(animated: true, onDismissed: nil)
        forecastCoordinator.present(animated: true, onDismissed: nil)
        return true
    }
}
