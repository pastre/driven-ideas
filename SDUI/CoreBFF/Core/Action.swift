public protocol Action: TypeHolder, Decodable {
    func perform(using component: Component)
}

@propertyWrapper
public final class ComponentAction {
    public private(set) var wrappedValue: Action?
    
    public init(wrappedValue: Action? = nil) {
        self.wrappedValue = wrappedValue
    }
    
    func resolve(using action: Action) {
        wrappedValue = action
    }
}

extension ComponentAction: Decodable {
    convenience public init(from decoder: Decoder) throws {
        self.init()
    }
}


public extension KeyedDecodingContainer {
    /// Ignore ComponentAction properties on JSON decoding
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: ComponentAction {
        T.init()
    }
}
