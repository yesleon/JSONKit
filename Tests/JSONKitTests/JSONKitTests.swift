import XCTest
@testable import JSONKit

final class JSONKitTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        
        let a: [String : Any] = [
            "asdf": ["dd", "gg", "77"],
            "FFF": true
        ]
        let aString = """
            {
                "asdf": ["dd", "gg", "77"]
            }
            """
        let b = try aString.data(using: .utf8)!.toJSONData()
        let z = try b.cast(as: [String: Any].self)
        print(try b.stringified())
        XCTAssertEqual(
            try b["asdf"][2].cast(),
            "77"
        )
        
        XCTAssertThrowsError(
            try b[3].get()
        )
        
        XCTAssertEqual(
            try b["asdf"][2].cast(as: String.self),
            try b.getDescendant(by: ["asdf", .index(2)]).cast(as: String.self)
        )
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
