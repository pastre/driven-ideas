import XCTest

@testable import CoreBFF

final class DefaultDrivenDecoderTests: XCTestCase {
    // MARK: - Unit tests
    
    func test_drivenDecoder_whenInitializedUsingContainers_properlyConfiguresUserInfo() {
        let sut = DefaultDrivenDecoder(
            actionContainer: .init(),
            componentContainer: .init(),
            useCaseContainer: .init(),
            eventContainer: .init())
        XCTAssertNotNil(sut.userInfo[DrivenContainerResolving.drivenContext])
    }
    
    func test_drivenDecoder_whenInitializedWithUserInfo_properlyConfiguresUserInfo() {
        let sut = DefaultDrivenDecoder(userInfo: [DrivenContainerResolving.drivenContext : ""])
        XCTAssertNotNil(sut.userInfo[DrivenContainerResolving.drivenContext])
    }
}
