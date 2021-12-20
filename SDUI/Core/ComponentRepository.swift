import Foundation

enum RepositoryError: Error {
    case notRegistered(String)
}

final class ComponentRepository {
    private var components: [Component.Type] = []
    
    func component(for type: String) throws -> Component.Type {
        guard let metatype = components.first(where: { $0.type == type })
        else { throw RepositoryError.notRegistered(type) }
        return metatype
    }
    
    func register<ComponentType>(_ type: ComponentType.Type) where ComponentType: Component {
        components.append(type)
    }
}
