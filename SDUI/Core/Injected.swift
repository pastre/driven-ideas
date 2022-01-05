protocol InjectedResolving: Decodable {
    init()
    func resolveIfNeeded(using repository: UseCaseRepository)
}

@propertyWrapper
final class Injected<T>: InjectedResolving {
    // MARK: - Inner types
    
    typealias ErrorHandler = (Error<T>) -> Void
    
    enum Error<T>: Swift.Error {
        case unresolved(T.Type)
        case notRegistered(T.Type)
    }
    
    // MARK: - Dependencies
    
    private let errorHandler: ErrorHandler
    
    // MARK: - Properties
    
    private var value: T?
    var wrappedValue: T {
        guard let value = value else {
            errorHandler(.unresolved(T.self))
            preconditionFailure()
        }
        return value
    }
    
    // MARK: - Initialization
    
    init(errorHandler: ErrorHandler? = nil) {
        self.errorHandler = errorHandler ?? {
            preconditionFailure($0.localizedDescription)
        }
    }
    
    convenience init() {
        self.init(errorHandler: nil)
    }
    
    convenience init(from decoder: Decoder) throws {
        self.init()
    }
    
    // MARK: - Internal API
    
    func resolveIfNeeded(using repository: UseCaseRepository) {
        guard value == nil else { return }
        guard let resolved = repository.resolve(T.self) else {
            errorHandler(.notRegistered(T.self))
            return
        }
        self.value = resolved
    }
}

extension KeyedDecodingContainer {
    /// Ignore injected properties on JSON decoding
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: InjectedResolving {
        T.init()
    }
}
