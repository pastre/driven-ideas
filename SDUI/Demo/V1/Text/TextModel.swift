import CoreBFF
import UIKit

final class TextModel: Component {
    static var type: String { "text" }
    lazy var view: DrivenView<TextModel> = { [unowned self] in
        TextView(model: self)
    }()
    
    var content: String
    
    @ComponentAction
    var action: Action?
    
    @HandledEvents
    var handleableEvents: [Event]
}

extension TextModel: EventHandler {
    func handle(event: Event) {
        guard var value = Int(self.content)
        else { return }
        value += 1
        content = String(value)
        view.renderModel()
    }
}
