import XCTest
@testable import JSONKit

final class JSONKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let b: JSONType = [
            "asdf": ["dd", "gg", "77"]
        ]
        let c = b["asdf"]?[2]
        
        
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
