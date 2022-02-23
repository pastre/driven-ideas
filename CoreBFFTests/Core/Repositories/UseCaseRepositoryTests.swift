import XCTest

@testable import CoreBFF

final class UseCaseRepositoryTests: XCTestCase {
    // MARK: - Properties
    
    private let sut = UseCaseRepository()
    private var sutAttributes: Mirror.Children {
        Mirror(reflecting: sut).children
    }
    
    // MARK: - Unit tests
    
    func test_register_itShouldAddDependencyToFactory() throws {
        // Given
        let expectation = expectation(description: "Must be called")
        
        // When
        sut.register(for: String.self) {
            expectation.fulfill()
            return NSString()
        }
        
        // Then
        let factories = try XCTUnwrap(sutAttributes
            .compactMap { $0.value as? [NSString : UseCaseRepository.DependencyFactory] }
            .first)
        let factory = try XCTUnwrap(factories["String"])
        let _ = factory()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func test_resolve_whenInstanceIsNotRegistered_itShouldReturnNil() {
        // Given / When
        let actualResolvedValue = sut.resolve(NSString.self)
        
        // Then
        XCTAssertNil(actualResolvedValue)
    }
    
    func test_resolve_whenValueIsRegistered_itShouldReturnProperInstance() {
        // Given
        let expectedString = UUID().uuidString as NSString
        sut.register(for: NSString.self) {
            expectedString
        }
        
        // When
        let actualString = sut.resolve(NSString.self)
        
        // Then
        XCTAssertEqual(actualString, expectedString)
    }
}
