import Foundation
import UIKit
import Combine

class ViewController: UIViewController {
    private let componentRepository: ComponentRepository = {
        var repository = ComponentRepository()
        repository.append(TextModel.self)
        repository.append(ButtonModel.self)
        repository.append(RandomNameGeneratorModel.self)
        return repository
    }()
    
    private let actionRepository: ActionRepository = {
        var repository = ActionRepository()
        repository.append(ButtonAction.self)
        repository.append(RandomNameGeneratorAction.self)
        repository.append(NavigationAction.self)
        repository.append(OpenURLAction.self)
        return repository
    }()
    
    private lazy var useCaseRepository: UseCaseRepository = {
        let repository = UseCaseRepository()
        
        repository.register(for: PrintUseCase.self) {
            PrintUseCase()
        }
        
        repository.register(for: RenameUseCase.self) {
            RenameUseCase()
        }
        
        repository.register(for: NavigateUseCase.self) { [unowned self] in
            NavigateUseCase(viewController: self)
        }
        
        repository.register(for: OpenURLUseCase.self) {
            OpenURLUseCase()
        }
        
        return repository
    }()
    
    private lazy var engine = DrivenEngine(
        componentRepository: componentRepository,
        actionRepository: actionRepository,
        useCaseRepository: useCaseRepository
    )
    
    override func loadView() {
        view = engine.view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let data = a.data(using: .utf8)!
        do {
            try engine.render(data: data)
        } catch let DecodingError.keyNotFound(codingKey, context) {
            print(codingKey, context)
        } catch {
            print("outro")
        }
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
        "content" : "wqe"
    },
    {
        "type": "button",
        "title" : "clica ai",
        "action": {
            "type": "buttonAction",
            "stringToPrint": "testeee"
        }
    },
    {
        "type": "randomNameGenerator",
        "name": "Generate new item",
        "action": {
            "type": "generateNewName"
        }
    },
    {
        "type": "button",
        "title": "Navigate",
        "action": {
            "type": "navigation"
        }
    },
    {
        "type": "button",
        "title": "Open URL",
        "action": {
            "type": "openURL",
            "url": "https://google.com"
        }
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
