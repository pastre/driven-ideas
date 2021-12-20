struct ButtonModel: Component {
    static var type: String { "button" }
    var view: DrivenView<ButtonModel> { ButtonView(model: self) }
    let title: String
}

struct ButtonAction: Action {
    weak var delegate: ActionDelegate?
    
    static var type: String { "buttonAction" }
}

