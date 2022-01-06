import Foundation
import CoreBFF

struct BannerCarouselModel: Component {
    static var type: String { "bannerCarousel" }
    
    var view: DrivenView<BannerCarouselModel> { BannerCarouselView(model: self) }
    
    @ChildComponent
    var banners: [Component]
}
