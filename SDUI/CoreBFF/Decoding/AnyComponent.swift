import Foundation

struct AnyComponent: Decodable {
    let type: String
    let componentData: Data
    let action: AnyAction?
    
    init(from decoder: Decoder) throws {
        let keyedContainer = try decoder.container(keyedBy: CodingKeys.self)
        type = try keyedContainer.decode(String.self, forKey: .type)
        
        if keyedContainer.allKeys.contains(.action) {
            action = try keyedContainer.decode(AnyAction.self, forKey: .action)
        } else {
            action = nil
        }
        
        let component = try decoder.singleValueContainer().decode(AnyDecodable.self)
        componentData = try JSONSerialization.data(withJSONObject: component.value)
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
        case action
    }
}

struct AnyAction: Decodable {
    let type: String
    let data: Data
    
    init(from decoder: Decoder) throws {
        type = try decoder.container(keyedBy: CodingKeys.self).decode(String.self, forKey: .type)
        let component = try decoder.singleValueContainer().decode(AnyDecodable.self)
        data = try JSONSerialization.data(withJSONObject: component.value, options: [])
    }
    
    private enum CodingKeys: String, CodingKey {
        case type
    }
}
