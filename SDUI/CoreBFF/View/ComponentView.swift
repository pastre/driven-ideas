import UIKit

open class ComponentView<Model>: UIView, ComponentRendering where Model: Component {

    public let model: Model
    
    public init(model: Model) {
        self.model = model
        super.init(frame: .zero)
        addSubviews()
        constraintSubviews()
        configureAdditionalSettings()
        renderModel()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func addSubviews() { fatalError() }
    open func constraintSubviews() { fatalError() }
    open func configureAdditionalSettings() {}
    open func renderModel() { fatalError() }
    
    public final func performAction() {
        model.action?.perform(using: model)
    }
}

public typealias DrivenView<Model: Component> = ComponentView<Model> & ComponentRendering
