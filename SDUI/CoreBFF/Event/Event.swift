public protocol Event: TypeHolder, Decodable {
    var id: String { get }
}
