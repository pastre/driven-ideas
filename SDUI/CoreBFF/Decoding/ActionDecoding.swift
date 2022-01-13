import Foundation

@propertyWrapper
public final class ComponentAction: Decodable {
    public private(set) var wrappedValue: Action?
    
    public init(wrappedValue: Action? = nil) {
        self.wrappedValue = wrappedValue
    }
    
    func resolve(using action: Action) {
        wrappedValue = action
    }
    
    convenience public init(from decoder: Decoder) throws {
        self.init()
    }
}

public extension KeyedDecodingContainer {
    func decode<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T where T: ComponentAction {
        return try action(type, forKey: key) ?? .init()
    }
    
    func action<T>(
        _ type: T.Type,
        forKey key: KeyedDecodingContainer<K>.Key
    ) throws -> T? where T: ComponentAction {
        guard let decodingContext = try superDecoder().userInfo[DrivenContainerResolving.drivenContext] as? DrivenDecodingContext
        else { return nil }
        
        do {
            let wrapper = ComponentAction() 
            let container = try self.nestedContainer(keyedBy: TypeCodingKey.self, forKey: key)
            let typeName = try container.decode(String.self, forKey: .type)
            let type = try decodingContext.actionContainer.action(for: typeName)
            let action = try type.init(from: superDecoder(forKey: key))
            action.resolve(using: decodingContext.useCaseContainer)
            wrapper.resolve(using: action)
            return wrapper as? T
        } catch let DecodingError.keyNotFound(key, context) {
            // TODO throw proper error using key and context
            return nil
        }
    }
}

extension Action {
    func resolve(using useCaseRepository: UseCaseRepository) {
        Mirror(reflecting: self).children
            .compactMap { $0.value as? InjectedResolving }
            .forEach { $0.resolveIfNeeded(using: useCaseRepository) }
    }
}
