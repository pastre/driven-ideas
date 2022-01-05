import Foundation

extension Component {
    init(
        from anyComponent: AnyComponent,
        decoder: DrivenDecoder.Type = JSONDecoder.self
    ) throws {
        self = try decoder.drivenDecode(Self.self, from: anyComponent.componentData)
    }
    
    func resolveAction(using actionRepository: ActionRepository, useCaseRepository: UseCaseRepository, anyAction: AnyAction?) throws {
        try Mirror(reflecting: self).children.forEach {
            guard let child = $0.value as? ComponentAction,
                  let anyAction = anyAction
            else { return }
            let type = try actionRepository.action(for: anyAction.type)
            let action = try type.init(from: anyAction)
            child.wrappedValue = action
            action.resolve(using: useCaseRepository)
        }
    }
}
