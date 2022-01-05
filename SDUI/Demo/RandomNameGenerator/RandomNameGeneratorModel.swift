import Foundation
import UIKit

final class RandomNameGeneratorModel: Component {
    static var type: String { "randomNameGenerator" }
    
    var name: String
    
    @ComponentAction
    var action: Action?
    
    lazy var view: DrivenView<RandomNameGeneratorModel> = { [unowned self] in
        RandomNameGeneratorView(model: self)
    }()
}


extension RandomNameGeneratorModel: Nameable {
    func set(name: String) {
        self.name = name
        view.renderModel()
    }
}
