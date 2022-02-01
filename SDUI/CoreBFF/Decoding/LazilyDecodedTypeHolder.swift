import Foundation

struct LazilyDecodedTypeHolder: Decodable {
    let type: String
    let data: Data
    
    init(from decoder: Decoder) throws {
        let component = try decoder.singleValueContainer().decode(AnyDecodable.self)
        type = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .type)
        data = try JSONSerialization.data(withJSONObject: component.value)
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
}
