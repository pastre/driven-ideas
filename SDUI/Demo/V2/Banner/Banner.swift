import Foundation

struct BannerModel: Component {
    
    static var type: String { "banner" }
    
    var view: DrivenView<BannerModel> { BannerView(model: self) }
    
    let imageURL: URL

    @ComponentAction
    var action: Action?
}


