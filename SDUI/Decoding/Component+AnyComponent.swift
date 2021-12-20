import Foundation

extension Component {
    init(from anyComponent: AnyComponent) throws {
        self = try ComponentDecoder().decode(Self.self, from: anyComponent.componentData)
    }
}
