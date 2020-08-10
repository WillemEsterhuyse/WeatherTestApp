import UIKit
import Swinject

public class TabBarRouter: NSObject, Router {
    // MARK: - Instance Properties
    public let window: UIWindow
    public let tabBarController = UITabBarController()
    private let theme: ThemeStrategy
    
    // MARK: - Object Lifecycle
    init(window: UIWindow, theme: ThemeStrategy = DefaultTheme()) {
        self.window = window
        self.theme = theme
        super.init()
        
        setAppearance()
        
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
    }
    
    private func setAppearance() {
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: DefaultTheme().fonts.tapBarFont], for: .normal)
        
        tabBarController.tabBar.tintColor = UIColor(named: "secondaryTextColor")
        tabBarController.tabBar.unselectedItemTintColor = UIColor(named: "primaryTextColor")
    }
    
    // MARK: - Router
    public func present(_ viewController: UIViewController, animated: Bool, onDismissed: (() -> Void)?) {
        if tabBarController.viewControllers == nil {
            tabBarController.viewControllers = [viewController]
        } else {
            tabBarController.viewControllers?.append(viewController)
        }
    }
    
    public func dismiss(animated: Bool) {
        // don't do anything
    }
}
