public protocol Component: TypeHolder, Decodable {
    var view: DrivenView<Self> { get }
    var action: Action? { get }
}

public extension Component {
    var action: Action? { nil } // Optional implementation
}
