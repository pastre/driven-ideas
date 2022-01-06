import UIKit

final class TextView: ComponentView<TextModel> {
    private lazy var label: UILabel = {
        let view = UILabel()
        return view
    }()
    
    override func addSubviews() {
        addSubview(label)
    }
    
    override func constraintSubviews() {
        label.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    override func configureAdditionalSettings() {
        label.textColor = .cyan
    }
    
    override func renderModel() {
        label.text = model.content
    }
}
