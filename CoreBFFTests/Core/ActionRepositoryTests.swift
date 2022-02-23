import XCTest

@testable import CoreBFF

final class ActionRepositoryTests: XCTestCase {
    // MARK: - Properties
    
    private var sut = ActionRepository()
    
    // MARK: - Unit tests
    
    func test_action_whenNotRegistered_itShouldThrow() {
        // Given
        let actionType = UUID().uuidString
        
        // When / Then
        XCTAssertThrowsError(try sut.action(for: actionType),
                             "No action for this ID"
        ) { error in
            XCTAssertEqual(error as? RepositoryError, RepositoryError.notRegistered(actionType))
        }
    }
    
    func test_action_whenRegistered_itShouldReturnAction() {
        // Given
        sut.append(DummyAction.self)
        
        // When / Then
        XCTAssertNoThrow(try sut.action(for: DummyAction.type))
    }
}

struct DummyAction: Action {
    static var type: String { "dummy" }
    func perform(using component: Component) {}
}
