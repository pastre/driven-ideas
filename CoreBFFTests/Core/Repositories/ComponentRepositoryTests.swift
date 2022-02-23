import XCTest

@testable import CoreBFF

final class ComponentRepositoryTests: XCTestCase {
    // MARK: - Properties
    
    private var sut = ComponentRepository()
    
    // MARK: - Unit tests
    
    func test_component_whenNotRegistered_itShouldThrow() {
        // Given
        let componentType = UUID().uuidString
        
        // When / Then
        XCTAssertThrowsError(try sut.component(for: componentType),
                             "No component for this ID"
        ) { error in
            XCTAssertEqual(error as? RepositoryError, RepositoryError.notRegistered(componentType))
        }
    }
    
    func test_component_whenRegistered_itShouldReturnComponent() {
        // Given
        sut.append(DummyComponent.self)
        
        // When / Then
        XCTAssertNoThrow(try sut.component(for: DummyComponent.type))
    }
}

struct DummyComponent: Component {
    var view: DrivenView<DummyComponent> { fatalError() }
    
    static var type: String { "dummy" }
}
