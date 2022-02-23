import XCTest

@testable import CoreBFF

final class ChildComponentDecodingTests: XCTestCase {
    func test_initFromDecoder_initializesEmpty() throws {
        let sut = try ChildComponent(from: DummyDecoder())
        XCTAssertTrue(sut.wrappedValue.isEmpty)
    }
    
    func test_resolve_setWrappedValue() throws {
        let sut = ChildComponent()
        try sut.resolve(using: [DummyComponent()])
        XCTAssertEqual(1, sut.wrappedValue.count)
    }
    
    func test_decode_whenNoContext_itShouldReturnEmptyChildComponent() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoded = try JSONDecoder().decode(DummyChildComponent.self, from: componentData)
        
        XCTAssertTrue(decoded.children.isEmpty)
    }
    
    func test_decode_whenPayloadIsInvalid_itShouldReturnEmptyChildComponent() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoder = DefaultDrivenDecoder.fixture()
        let decoded = try decoder.decode(DummyChildComponent.self, from: componentData)
        
        XCTAssertNil(decoded.action)
    }
    
    func test_decode_whenPayloadContainsAction_itShouldResolve() throws {
        let componentModel: [String : Any] = [
            "type": "dummyWithChildren",
            "children": [
                [
                    "type": "dummy"
                ]
            ]
        ]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        var componentRepository = ComponentRepository()
        componentRepository.append(DummyChildComponent.self)
        componentRepository.append(DummyComponent.self)
        let decoder = DefaultDrivenDecoder.fixture(componentContainer: componentRepository)
        let decoded = try decoder.decode(DummyChildComponent.self, from: componentData)
        
        XCTAssertEqual(1, decoded.children.count)
    }
}

struct DummyChildComponent: Component {
    var view: DrivenView<DummyChildComponent> { fatalError() }
    static var type: String { "dummyWithChildren" }
    
    @ChildComponent
    var children: [Component]
}
