import Swinject

final class AppDependency {
    let container: Container
    
    init(container: Container = .init()) {
        self.container = container
    }
    
    public func setupDependencies() {
        container.register(Networking.self) { _ in
            NetworkingManager()
        }
        
        container.register(LocationService.self) { _ in
            LocationServiceImpl()
        }
        
        container.register(WeatherService.self) { resolver in
            OpenWeatherServiceImpl(networking: resolver.resolve(Networking.self)!)
        }
        
        // ViewControllers
        container.register(ForecastViewController.self) { resolver  in
            let viewController = ForecastViewController(
                locationService: resolver.resolve(LocationService.self)!,
                weatherService: resolver.resolve(WeatherService.self)!)
            return viewController
        }
        
        container.register(TodayViewController.self) { resolver in
            let viewController = TodayViewController(
                locationService: resolver.resolve(LocationService.self)!,
                weatherService: resolver.resolve(WeatherService.self)!)
            return viewController
        }
    }
}
