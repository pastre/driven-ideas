import XCTest

@testable import CoreBFF

final class EventDecodingTests: XCTestCase {
    func test_initFromDecoder_initializesEmpty() {
        let sut = HandledEvents()
        XCTAssertTrue(sut.wrappedValue.isEmpty)
    }
    
    func test_resolve_setWrappedValue() {
        let sut = HandledEvents(handledEvents: [DummyEvent()])
        XCTAssertEqual(1, sut.wrappedValue.count)
    }
    
    func test_decode_whenNoContext_itShouldReturnEmptyHandledEvent() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoded = try JSONDecoder().decode(DummyComponentWithEvent.self, from: componentData)
        
        XCTAssertTrue(decoded.events.isEmpty)
    }
    
    func test_decode_whenPayloadIsInvalid_itShouldReturnEmptyChildComponent() throws {
        let componentModel: [String : Any] = [:]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        let decoder = DefaultDrivenDecoder.fixture()
        let decoded = try decoder.decode(DummyComponentWithEvent.self, from: componentData)
        
        XCTAssertTrue(decoded.events.isEmpty)
    }
    
    func test_decode_whenPayloadContainsAction_itShouldResolve() throws {
        let componentModel: [String : Any] = [
            "type": "dummyWithChildren",
            "events": [
                [
                    "type": "dummy"
                ]
            ]
        ]
        let componentData = try JSONSerialization.data(withJSONObject: componentModel, options: [])
        var componentRepository = ComponentRepository()
        var eventRepository = EventRepository()
        componentRepository.append(DummyComponentWithEvent.self)
        eventRepository.append(DummyEvent.self)
        let decoder = DefaultDrivenDecoder.fixture(componentContainer: componentRepository,
                                                   eventContainer: eventRepository)
        let decoded = try decoder.decode(DummyComponentWithEvent.self, from: componentData)
        
        XCTAssertEqual(1, decoded.events.count)
    }
}

struct DummyComponentWithEvent: Component {
    var view: DrivenView<DummyComponentWithEvent> { fatalError() }
    
    static var type: String { "dummyWithEvent" }
    
    @HandledEvents
    var events: [Event]
}
