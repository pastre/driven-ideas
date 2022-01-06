struct TextModel: Component {
    static var type: String { "text" }
    var view: DrivenView<TextModel> { TextView(model: self) }
    let content: String
    
    @ComponentAction
    var action: Action?
}
