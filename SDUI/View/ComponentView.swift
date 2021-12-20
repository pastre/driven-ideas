import UIKit

protocol ActionDelegate: AnyObject {
    func perform(action: AnyAction?)
}

class ComponentView<Model>: UIView, ComponentRendering where Model: Component {
    
    public let model: Model
    
    public weak var delegate: ActionDelegate?
    
    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() { fatalError() }
    func constraintSubviews() { fatalError() }
    func configureAdditionalSettings() {}
    
    final func performAction() {
        delegate?.perform(action: model.action)
    }
}

typealias DrivenView<Model: Component> = ComponentView<Model> & ComponentRendering
