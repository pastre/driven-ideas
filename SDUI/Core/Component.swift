protocol Component: TypeHolder, Decodable {
    var view: DrivenView<Self> { get }
    var action: Action? { get }
}

extension Component {
    var action: Action? { nil }
}
