import Foundation

extension Component {
    init(
        from anyComponent: AnyComponent,
        decoder: DrivenDecoder.Type = JSONDecoder.self
    ) throws {
        self = try decoder.drivenDecode(Self.self, from: anyComponent.componentData)
    }
    
    func resolveNestedComponents(
        from anyComponent: AnyComponent,
        componentRepository: ComponentRepository,
        actionRepository: ActionRepository,
        useCaseRepository: UseCaseRepository,
        decoder: DrivenDecoder.Type = JSONDecoder.self
    ) throws {
        try Mirror(reflecting: self).children.forEach {
            guard let child = $0.value as? ChildComponent,
                  let label = sanitizeLabel($0.label)
            else { return }
            let nested = try decoder.drivenDecode(LazyComponentDecoding.self, from: anyComponent.componentData)
            let components = try nested.components(at: label)
            try child.resolve(components: components, using: componentRepository)
            try child.resolveChildrenActions(
                using: actionRepository,
                useCaseRepository: useCaseRepository,
                actions: components.map(\.action)
            )
        }
    }
    
    func resolveAction(using actionRepository: ActionRepository,
                       useCaseRepository: UseCaseRepository,
                       anyAction: AnyAction?
    ) throws {
        try Mirror(reflecting: self).children.forEach {
            guard let child = $0.value as? ComponentAction,
                  let anyAction = anyAction
            else { return }
            let type = try actionRepository.action(for: anyAction.type)
            let action = try type.init(from: anyAction)
            child.resolve(using: action)
            action.resolve(using: useCaseRepository)
        }
    }
    
    private func sanitizeLabel(_ label: String?) -> String? {
        guard let sanitized = label?.dropFirst() else { return nil }
        return String(sanitized)
    }
}

struct LazyComponentDecoding: Decodable {
    private let decoder: Decoder

    init(from decoder: Decoder) throws {
        self.decoder = decoder
    }
    
    func components(at key: String) throws -> [AnyComponent] {
        let container = try decoder.container(keyedBy: AnyCodingKey.self)
        return try container.decode([AnyComponent].self, forKey: .init(key: key))
    }
}

struct AnyCodingKey: CodingKey {
    var intValue: Int? { Int(stringValue) }
    let stringValue: String
    
    init?(intValue: Int) {
        self.init(stringValue: .init(intValue))
    }
    
    init?(stringValue: String) {
        self.stringValue = stringValue
    }
    
    init(key: String) {
        stringValue = key
    }
}
