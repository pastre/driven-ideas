import Foundation

protocol DrivenDecoder: AnyObject {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

enum TypeCodingKey: String, CodingKey {
    case type
}

struct DrivenDecodingContext {
    let componentContainer: ComponentRepository
    let actionContainer: ActionRepository
    let useCaseContainer: UseCaseRepository
    let eventContainer: EventRepository
}

enum DrivenContainerResolving {
    static let drivenContext: CodingUserInfoKey = .init(rawValue: "Driven context")!
}

final class DefaultDrivenDecoder: JSONDecoder, DrivenDecoder {
    
    typealias UserInfo = [CodingUserInfoKey : Any]
    
    init(actionContainer: ActionRepository,
         componentContainer: ComponentRepository,
         useCaseContainer: UseCaseRepository,
         eventContainer: EventRepository
    ) {
        super.init()
        userInfo[DrivenContainerResolving.drivenContext] = DrivenDecodingContext(
            componentContainer: componentContainer,
            actionContainer: actionContainer,
            useCaseContainer: useCaseContainer,
            eventContainer: eventContainer)
    }
    
    init(userInfo: UserInfo) {
        super.init()
        self.userInfo = userInfo
    }
}

