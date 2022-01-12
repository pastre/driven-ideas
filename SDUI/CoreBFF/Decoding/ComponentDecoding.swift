import Foundation

extension Component {
    init(
        from anyComponent: AnyComponent,
        decoder: DrivenDecoder
    ) throws {
        self = try decoder.decode(Self.self, from: anyComponent.componentData)
    }
}
