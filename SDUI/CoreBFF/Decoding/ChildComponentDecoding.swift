@propertyWrapper
public final class ChildComponent: Decodable {
    public var wrappedValue: [Component]
    
    public init(_ wrappedValue: [Component] = []) {
        self.wrappedValue = wrappedValue
    }
    
    convenience public init(from decoder: Decoder) throws {
        self.init()
    }
    
    func resolve(
        using components: [Component]
    ) throws {
        wrappedValue = components
    }
}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T where T: ChildComponent {
        return try children(type, forKey: key) ?? .init()
    }
    
    private func children<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T? where T: ChildComponent {
        guard
            let context = try superDecoder().userInfo[DrivenContainerResolving.drivenContext] as? DrivenDecodingContext
        else { return nil }
        do {
            let wrapper = ChildComponent()
            var container = try nestedUnkeyedContainer(forKey: key)
            var components = [Component]()
            while !container.isAtEnd {
                let anyComponent = try container.decode(LazilyDecodedTypeHolder.self)
                let type = try context.componentContainer.component(for: anyComponent.type)
                let component = try type.init(from: try superDecoder())
                components.append(component)
            }
            try wrapper.resolve(using: components)
            return wrapper as? T
        } catch let DecodingError.keyNotFound(key, context) {
            // TODO throw proper error using key and context
            return nil
        }
    }
}
