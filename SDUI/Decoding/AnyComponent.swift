import Foundation

struct AnyComponent: Decodable {
    let type: String
    let componentData: Data
    
    init(from decoder: Decoder) throws {
        type = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .type)
        let component = try decoder.singleValueContainer().decode(AnyDecodable.self)
        componentData = try JSONSerialization.data(withJSONObject: component.value, options: [])
    }
    private enum CodingKeys: String, CodingKey {
        case type
    }
}
