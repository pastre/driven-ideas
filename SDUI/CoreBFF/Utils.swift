// TODO review all of this. You might not need it

import UIKit

@resultBuilder
public struct ConstraintCollector {
    public static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        components
    }
}

public extension UIView {
    func layout(@ConstraintCollector using constraints: (UIView) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self))
    }
}

public extension Array where Element == UIView {
    func removeSubviews() {
        forEach { $0.removeFromSuperview() }
    }
}

public extension NSObject {
    static var uniqueIdentifier: String { String(describing: self) }
}
 
public extension UITableView {
    func register<T>(_ type: T.Type) where T: UITableViewCell {
        register(type, forCellReuseIdentifier: type.uniqueIdentifier)
    }
    
    func dequeue<T>(_ type: T.Type, at indexPath: IndexPath) -> T where T: UITableViewCell {
        guard let cell = dequeueReusableCell(
            withIdentifier: type.uniqueIdentifier, for: indexPath) as? T
        else { fatalError() }
        return cell
    }
}

public extension UICollectionView {
    func register<T>(_ type: T.Type) where T: UICollectionViewCell {
        register(type, forCellWithReuseIdentifier: type.uniqueIdentifier)
    }
}

public extension UICollectionView {
    func dequeue<T>(_ type: T.Type, at indexPath: IndexPath) -> T where T: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: type.uniqueIdentifier, for: indexPath) as? T else {
            fatalError()
        }
        return cell
    }
}


open class CodedCollectionViewCell: UICollectionViewCell, CodedViewLifecycle {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
    
    open func addSubviews() {
        fatalError()
    }
    
    open func constraintSubviews() {
        fatalError()
    }
    
    open func configureAdditionalSettings() {}
}
