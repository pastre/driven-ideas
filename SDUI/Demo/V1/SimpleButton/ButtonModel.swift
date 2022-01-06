import Foundation

struct ButtonModel: Component {
    static var type: String { "button" }
    var view: DrivenView<ButtonModel> { ButtonView(model: self) }
    
    let title: String
    
    @ComponentAction
    var action: Action?
}

@propertyWrapper
public struct OmitDecoding<WrappedType: Decodable>: OmitableFromDecoding {

    public var wrappedValue: WrappedType?
    public init(wrappedValue: WrappedType?) {
        self.wrappedValue = wrappedValue
    }
}

public protocol OmitableFromDecoding: Decodable {
    associatedtype WrappedType: ExpressibleByNilLiteral
    init(wrappedValue: WrappedType)
}

extension KeyedDecodingContainer {
    // This is used to override the default decoding behavior for OptionalCodingWrapper to allow a value to avoid a missing key Error
    public func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: OmitableFromDecoding {
        return try decodeIfPresent(T.self, forKey: key) ?? T(wrappedValue: nil)
    }
}
