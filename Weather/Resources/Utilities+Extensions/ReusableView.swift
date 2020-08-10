import UIKit

protocol ReusableView: class {
    static var reuseIdentifier: String { get }
    static var nib: UINib { get }
}

extension ReusableView where Self: UIView {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
    
    static var nib: UINib {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
