import Foundation

extension Component {
    init(
        from anyComponent: LazilyDecodedTypeHolder,
        decoder: DrivenDecoder
    ) throws {
        print("Decoding", Self.self)
        self = try decoder.decode(Self.self, from: anyComponent.data)
    }
}

extension Event {
    init(
        from anyComponent: LazilyDecodedTypeHolder,
        decoder: DrivenDecoder
    ) throws {
        print("Decoding", Self.self)
        self = try decoder.decode(Self.self, from: anyComponent.data)
    }
}
