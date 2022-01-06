protocol Action: TypeHolder, Decodable {
    func perform(using component: Component)
}

@propertyWrapper
final class ComponentAction {
    private(set) var wrappedValue: Action?
    
    init(wrappedValue: Action? = nil) {
        self.wrappedValue = wrappedValue
    }
    
    func resolve(using action: Action) {
        wrappedValue = action
    }
}

extension ComponentAction: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
    }
}
