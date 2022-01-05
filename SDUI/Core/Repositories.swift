import Foundation

enum RepositoryError: Error {
    case notRegistered(String)
}

final class UseCaseRepository {
    // MARK: - Inner types
    typealias DependencyFactory = () -> AnyObject
    
    // MARK: - Properties
    
    private var dependencyFactories = [NSString : DependencyFactory]()
    private var dependencies: NSMapTable<NSString, AnyObject> = .init(keyOptions: .strongMemory, valueOptions: .weakMemory)
    
    // MARK: - Repository
    
    func resolve<T>(_ type: T.Type) -> T? {
        let name = name(for: type)
        let object = dependencies.object(forKey: name)
        
        if object != nil { return object as? T }
        
        guard let instance = dependencyFactories[name]?()
        else { return nil }
        
        dependencies.setObject(instance, forKey: name)
        return instance as? T
    }
    
    // MARK: - Registering
    
    func register<T>(for type: T.Type, _ factory: @escaping DependencyFactory) {
        dependencyFactories[name(for: type)] = factory
    }
    
    // MARK: - Helpers
    
    private func name<T>(for type: T.Type) -> NSString {
        String(describing: type) as NSString
    }
}

extension Array where Element == Action.Type {
    func action(for type: String) throws -> Element {
        guard let metatype = first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
}

extension Array where Element == Component.Type {
    func component(for type: String) throws -> Element {
        guard let metatype = first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
}

typealias ComponentRepository = Array<Component.Type>
typealias ActionRepository = Array<Action.Type>
