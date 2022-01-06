import Foundation
import UIKit
import Combine

final class ViewController: UIViewController {
    private let componentRepository: ComponentRepository = {
        var repository = ComponentRepository()
        repository.append(TextModel.self)
        repository.append(ButtonModel.self)
        repository.append(RandomNameGeneratorModel.self)
        repository.append(BannerCarouselModel.self)
        repository.append(BannerModel.self)
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
        let data = Payloads.b
        do {
            print("Rendering...")
            try engine.render(data: data)
            print("Rendered!")
        } catch {
            // TODO log error on crashlytics...
            print(error)
        }
    }
}


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
    func removeSubviews() {
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

extension UICollectionView {
    func register<T>(_ type: T.Type) where T: UICollectionViewCell {
        register(type, forCellWithReuseIdentifier: type.uniqueIdentifier)
    }
}

extension UICollectionView {
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
    
    func addSubviews() {
        fatalError()
    }
    
    func constraintSubviews() {
        fatalError()
    }
    
    func configureAdditionalSettings() {}
}
