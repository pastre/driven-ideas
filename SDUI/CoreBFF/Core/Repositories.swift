import Foundation

enum RepositoryError: Error {
    case notRegistered(String)
}

public final class UseCaseRepository {
    // MARK: - Inner types
    
    public typealias DependencyFactory = () -> AnyObject
    
    // MARK: - Properties
    
    private var dependencyFactories = [NSString : DependencyFactory]()
    private var dependencies: NSMapTable<NSString, AnyObject> = .init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Repository
    
    public func resolve<T>(_ type: T.Type) -> T? {
        let name = name(for: type)
        let object = dependencies.object(forKey: name)
        
        if object != nil { return object as? T }
        
        guard let instance = dependencyFactories[name]?()
        else { return nil }
        
        dependencies.setObject(instance, forKey: name)
        return instance as? T
    }
    
    // MARK: - Registering
    
    public func register<T>(for type: T.Type, _ factory: @escaping DependencyFactory) {
        dependencyFactories[name(for: type)] = factory
    }
    
    // MARK: - Helpers
    
    private func name<T>(for type: T.Type) -> NSString {
        String(describing: type) as NSString
    }
}

public extension Array where Element == Action.Type {
    func action(for type: String) throws -> Element {
        guard let metatype = first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
}

public extension Array where Element == Component.Type {
    func component(for type: String) throws -> Element {
        guard let metatype = first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
    
    mutating func register<T>(_ type: T.Type) where T: Component {
        append(type)
    }
}


extension Array where Element == Event.Type {
    func event(for type: String) throws -> Element {
        guard let metatype = first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
}

public typealias EventRepository = Array<Event.Type>
public typealias ComponentRepository = Array<Component.Type>
public typealias ActionRepository = Array<Action.Type>


final class TypeHolderRepository {
    public typealias DependencyFactory = () -> AnyObject
    
    // MARK: - Properties
    
    private var dependencyFactories = [NSString : DependencyFactory]()
    private var dependencies: NSMapTable<NSString, AnyObject> = .init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    // MARK: - Initialization
    
    public init() {}
    
    // MARK: - Repository
    
    public func resolve<T>(_ type: T.Type) -> T? {
        let name = name(for: type)
        let object = dependencies.object(forKey: name)
        
        if object != nil { return object as? T }
        
        guard let instance = dependencyFactories[name]?()
        else { return nil }
        
        dependencies.setObject(instance, forKey: name)
        return instance as? T
    }
    
    // MARK: - Registering
    
    public func register<T>(for type: T.Type, _ factory: @escaping DependencyFactory) {
        dependencyFactories[name(for: type)] = factory
    }
    
    // MARK: - Helpers
    
    private func name<T>(for type: T.Type) -> NSString {
        String(describing: type) as NSString
    }
}
