import Foundation

extension Component {
    init(
        from anyComponent: AnyComponent,
        decoder: DrivenDecoder.Type = JSONDecoder.self
    ) throws {
        self = try decoder.drivenDecode(Self.self, from: anyComponent.componentData)
    }
}

extension Action {
    init(
        from anyAction: AnyAction,
        decoder: DrivenDecoder.Type = JSONDecoder.self) throws {
            self = try decoder.drivenDecode(Self.self, from: anyAction.data)
    }
}
