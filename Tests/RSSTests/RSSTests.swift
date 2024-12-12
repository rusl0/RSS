import XCTest

@testable import RSS

#if canImport(FoundationNetworking)
    import FoundationNetworking
#endif

final class RSSTests: XCTestCase {
    func testRSS() throws {
        let path = Bundle.module.path(forResource: "SimpleRSS", ofType: "xml")
        let data = try Data(contentsOf: URL(fileURLWithPath: path!))
        let expected = simpleMock
        let actual = try RSSFeed(data: data)
        XCTAssertTrue(actual == expected, "feed not equal")
    }
}
