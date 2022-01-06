@propertyWrapper
public final class ChildComponent {
    public var wrappedValue: [Component]
    
    init(_ wrappedValue: [Component]) {
        self.wrappedValue = wrappedValue
    }
    
    func resolve(components: [AnyComponent], using container: ComponentRepository) throws {
        wrappedValue = []
        try components.forEach {
            let type = try container.component(for: $0.type)
            let component = try type.init(from: $0)
            wrappedValue.append(component)
        }
    }
    
    func resolveChildrenActions(
        using actionRepository: ActionRepository,
        useCaseRepository: UseCaseRepository,
        actions: [AnyAction?]
    ) throws {
        try zip(wrappedValue, actions).forEach { component, anyAction in
            try component.resolveAction(using: actionRepository, useCaseRepository: useCaseRepository, anyAction: anyAction)
        }
    }
}


extension ChildComponent: Decodable {
    convenience public init(from decoder: Decoder) throws {
        self.init([])
    }
}

