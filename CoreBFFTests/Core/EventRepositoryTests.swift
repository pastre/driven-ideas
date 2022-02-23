import XCTest

@testable import CoreBFF

final class EventRepositoryTests: XCTestCase {
    // MARK: - Properties
    
    private var sut = EventRepository()
    
    // MARK: - Unit tests
    
    func test_event_whenNotRegistered_itShouldThrow() {
        // Given
        let eventType = UUID().uuidString
        
        // When / Then
        XCTAssertThrowsError(try sut.event(for: eventType),
                             "No event for this ID"
        ) { error in
            XCTAssertEqual(error as? RepositoryError, RepositoryError.notRegistered(eventType))
        }
    }
    
    func test_event_whenRegistered_itShouldReturnEvent() {
        // Given
        sut.append(DummyEvent.self)
        
        // When / Then
        XCTAssertNoThrow(try sut.event(for: DummyEvent.type))
    }
}

struct DummyEvent: Event {
    static var type: String { "dummy" }
}
