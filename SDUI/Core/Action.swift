protocol Action: TypeHolder, Decodable {
    var delegate: ActionDelegate? { get set }
}

extension Action {
    init(from decoder: Decoder) throws {
        delegate = nil
        try self.init(from: decoder)
    }
}
