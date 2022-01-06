import Foundation
import UIKit
import Combine
import CoreBFF

final class ViewController: UIViewController {
    private let componentRepository: ComponentRepository = {
        var repository = ComponentRepository()
        repository.register(TextModel.self)
        repository.register(ButtonModel.self)
        repository.register(RandomNameGeneratorModel.self)
        repository.register(BannerCarouselModel.self)
        repository.register(BannerModel.self)
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
