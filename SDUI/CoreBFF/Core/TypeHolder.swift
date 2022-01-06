public protocol TypeHolder {
    static var type: String { get }
}

extension TypeHolder {
    var type: String { Self.type }
}
