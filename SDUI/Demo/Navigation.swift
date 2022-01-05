import UIKit

final class NavigateUseCase {
    private weak var viewController: UIViewController?
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    func execute() {
        viewController?.present(ViewController(), animated: true, completion: nil)
    }
}

struct NavigationAction: Action {
    
    static var type: String { "navigation" }
    
    @Injected
    private var navigationUseCase: NavigateUseCase
    
    func perform(using component: Component) {
        navigationUseCase.execute()
    }
}
