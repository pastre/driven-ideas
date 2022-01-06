import Foundation

extension Action {
    init(
        from anyAction: AnyAction,
        decoder: DrivenDecoder.Type = JSONDecoder.self
    ) throws {
        self = try decoder.drivenDecode(Self.self, from: anyAction.data)
    }
}

extension Action {
    func resolve(using useCaseRepository: UseCaseRepository) {
        Mirror(reflecting: self).children
            .compactMap { $0.value as? InjectedResolving }
            .forEach { $0.resolveIfNeeded(using: useCaseRepository) }
    }
}

