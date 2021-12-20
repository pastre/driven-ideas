protocol Component: TypeHolder, Decodable {
    var view: DrivenView<Self> { get }
    var action: AnyAction? { get }
}

extension Component {
    var action: AnyAction? { nil }
}
