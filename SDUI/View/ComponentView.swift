import UIKit

class ComponentView<Model>: UIView, ComponentRendering where Model: Component {

    public let model: Model
    
    init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
        renderModel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addSubviews() { fatalError() }
    func constraintSubviews() { fatalError() }
    func configureAdditionalSettings() {}
    func renderModel() { fatalError() }
    
    final func performAction() {
        model.action?.perform(using: model)
    }
}

typealias DrivenView<Model: Component> = ComponentView<Model> & ComponentRendering
