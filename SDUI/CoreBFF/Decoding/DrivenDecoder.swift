import Foundation

protocol DrivenDecoder: AnyObject {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable
}

enum TypeCodingKey: String, CodingKey {
    case type
}

enum DrivenContainerResolving {
    static let actionsKey: CodingUserInfoKey = .init(rawValue: "Actions container")!
    static let componentsKey: CodingUserInfoKey = .init(rawValue: "Components container")!
    static let useCasesKey: CodingUserInfoKey = .init(rawValue: "UseCases container")!
}

final class DefaultDrivenDecoder: JSONDecoder, DrivenDecoder {
    
    typealias UserInfo = [CodingUserInfoKey : Any]
    
    init(actionContainer: ActionRepository,
         componentContainer: ComponentRepository,
         useCaseContainer: UseCaseRepository
    ) {
        super.init()
        userInfo[DrivenContainerResolving.actionsKey] = actionContainer
        userInfo[DrivenContainerResolving.componentsKey] = componentContainer
        userInfo[DrivenContainerResolving.useCasesKey] = useCaseContainer
    }
    
    init(userInfo: UserInfo) {
        super.init()
        self.userInfo = userInfo
    }
}

