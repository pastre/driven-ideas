protocol Component: TypeHolder, Decodable {
    var view: DrivenView<Self> { get }
}
