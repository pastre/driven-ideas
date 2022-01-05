import UIKit

final class OpenURLUseCase {
    func execute(using url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct OpenURLAction: Action {
    static var type: String { "openURL" }
    
    let url: URL
    
    @Injected
    private var openUrlUseCase: OpenURLUseCase
    
    func perform(using component: Component) {
        openUrlUseCase.execute(using: url)
    }
}
