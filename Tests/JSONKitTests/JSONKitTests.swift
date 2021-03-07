import XCTest
@testable import JSONKit

final class JSONKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let b: ValueType = [
            "asdf": ["dd", "gg", "77"]
        ]
        
        XCTAssertEqual(
            try b["asdf"][2].get(),
            "77"
        )
        
        XCTAssertThrowsError(
            try b[3].get()
        )
        
        XCTAssertEqual(
            try b["asdf"][2].get(as: String.self),
            try b[["asdf", .index(2)]].get(as: String.self)
        )
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
