import UIKit

final class ButtonView: ComponentView<ButtonModel> {
    private lazy var button: UIButton = {
        let view = UIButton()
        view.addTarget(self, action: #selector(handleTap), for: .touchUpInside)
        return view
    }()
    
    override func addSubviews() {
        addSubview(button)
    }
    
    override func constraintSubviews() {
        button.layout {
            $0.topAnchor.constraint(equalTo: topAnchor)
            $0.leadingAnchor.constraint(equalTo: leadingAnchor)
            $0.trailingAnchor.constraint(equalTo: trailingAnchor)
            $0.bottomAnchor.constraint(equalTo: bottomAnchor)
        }
    }
    
    override func configureAdditionalSettings() {
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(.blue, for: .normal)
    }
    
    @objc
    private func handleTap() {
        performAction()
    }
}
