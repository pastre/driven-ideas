import XCTest

@testable import CoreBFF

final class ActionDecodingTests: XCTestCase {
    func test_initFromDecoder_initializesEmpty() throws {
        let sut = try ComponentAction(from: DummyDecoder())
        XCTAssertNil(sut.wrappedValue)
    }
    
    func test_resolve_setWrappedValue() {
        let sut = ComponentAction()
        sut.resolve(using: DummyAction())
        XCTAssertNotNil(sut.wrappedValue)
    }
    
    func test_decode_whenNoContext_itShouldReturnEmptyComponentAction() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoded = try JSONDecoder().decode(DummyComponentWithAction.self, from: componentData)
        
        XCTAssertNil(decoded.action)
    }
    
    func test_decode_whenPayloadIsInvalid_itShouldReturnEmptyComponentAction() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoder = DefaultDrivenDecoder.fixture()
        let decoded = try decoder.decode(DummyComponentWithAction.self, from: componentData)
        
        XCTAssertNil(decoded.action)
    }
    
    func test_decode_whenPayloadContainsAction_itShouldResolve() throws {
        let componentModel: [String : Any] = [
            "type": "dummy",
            "action": [
                "type": "dummy"
            ]
        ]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        var componentRepository = ComponentRepository()
        var actionRepository = ActionRepository()
        componentRepository.append(DummyComponentWithAction.self)
        actionRepository.append(DummyAction.self)
        let decoder = DefaultDrivenDecoder.fixture(actionContainer: actionRepository, componentContainer: componentRepository)
        let decoded = try decoder.decode(DummyComponentWithAction.self, from: componentData)
        
        XCTAssertNotNil(decoded.action)
    }
}

struct DummyComponentWithAction: Component {
    static var type: String { "dummy" }
    var view: DrivenView<DummyComponentWithAction> { fatalError() }
    
    @ComponentAction
    var action: Action?
}

struct DummyDecoder: Decoder {
    var codingPath: [CodingKey] { [] }
    var userInfo: [CodingUserInfoKey : Any] { [:] }
    
    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
        fatalError()
    }
    
    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError()
    }
    
    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError()
    }
}

extension DefaultDrivenDecoder {
    static func fixture(actionContainer: ActionRepository = .init(),
                        componentContainer: ComponentRepository = .init(),
                        useCaseContainer: UseCaseRepository = .init(),
                        eventContainer: EventRepository = .init()
    ) -> DefaultDrivenDecoder {
        .init(
            actionContainer: actionContainer,
            componentContainer: componentContainer,
            useCaseContainer: useCaseContainer,
            eventContainer: eventContainer)
    }
}
