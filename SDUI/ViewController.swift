import Foundation
import UIKit
import Combine

class ViewController: UIViewController {
    private let componentRepository: ComponentRepository = {
        let repository = ComponentRepository()
        repository.register(TextModel.self)
        repository.register(ButtonModel.self)
        return repository
        
    }()
    
    private lazy var engine = DrivenEngine(
        componentRepository: componentRepository
    )
    
    override func loadView() {
        view = engine.drivenView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = a.data(using: .utf8)!
        try! engine.render(data: data)
    }
}

let a = """
[
    {
        "type": "text",
        "content": "asd"
    },
    {
        "type": "text",
        "content" : "asd"
    },
    {
        "type": "text",
        "content" : "asd"
    },
    {
        "type": "text",
        "content" : "asd"
    },
    {
        "type": "button",
        "title" : "clica ai"
    }
]
"""
@resultBuilder
struct ConstraintCollector {
    static func buildBlock(_ components: NSLayoutConstraint...) -> [NSLayoutConstraint] {
        components
    }
}

extension UIView {
    func layout(@ConstraintCollector using constraints: (UIView) -> [NSLayoutConstraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints(self))
    }
}

extension Array where Element == UIView {
    func removeAll() {
        forEach { $0.removeFromSuperview() }
    }
}

extension NSObject {
    static var uniqueIdentifier: String { String(describing: self) }
}

extension UITableView {
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
