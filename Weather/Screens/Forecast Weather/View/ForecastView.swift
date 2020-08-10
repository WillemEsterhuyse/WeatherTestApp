import UIKit

public class ForecastView: UIView {
    @IBOutlet weak var navigationBar: UINavigationBar! {
        didSet {
            let attrs: [NSAttributedString.Key: Any] = [
                .foregroundColor: UIColor.white,
                .font: theme.fonts.navigationBarFont
            ]
            
            navigationBar.titleTextAttributes = attrs
            navigationBar.topItem?.title = "Forecast"
        }
    }
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.sectionHeaderHeight = 45
            tableView.tableFooterView = UIView()
        }
    }
}

extension ForecastView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        view.tintColor = UIColor.systemBlue
        
        let header = view as! UITableViewHeaderFooterView
        header.layer.borderWidth = 1
        header.layer.borderColor = UIColor(named: "borderColor")?.cgColor
        
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = theme.fonts.forecastHeadlineFont
        header.fadeTransition()
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.fadeTransition(delay: 0.05 * Double(indexPath.row), duration: 0.5)
    }
}
