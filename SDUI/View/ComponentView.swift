import UIKit

class ComponentView<Model>: UIView, ComponentRendering {
    
    public let model: Model
    
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
}

typealias DrivenView<Model> = ComponentView<Model> & ComponentRendering
