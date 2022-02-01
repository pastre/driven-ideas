import CoreBFF

struct EyeModel: Component {
    
    var view: DrivenView<EyeModel> { EyeView(model: self) }
    static var type: String { "eye" }
    
    let imageName: String
}
