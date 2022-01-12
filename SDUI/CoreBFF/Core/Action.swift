public protocol Action: TypeHolder, Decodable {
    func perform(using component: Component)
}
