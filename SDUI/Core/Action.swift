protocol Action: TypeHolder, Decodable {
    func perform(using component: Component)
}

@propertyWrapper
final class ComponentAction {
    var wrappedValue: Action?
    
    init(wrappedValue: Action? = nil) {
        self.wrappedValue = wrappedValue
    }
}

extension ComponentAction: Decodable {
    convenience init(from decoder: Decoder) throws {
        self.init()
    }
}
