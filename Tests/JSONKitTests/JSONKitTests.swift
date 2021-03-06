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
        let b = try Value(value: a)
        let z = b.extracted() as? [String: Any]
//        print(z)
        
        let c = try Value(jsonString: aString, options: .fragmentsAllowed)
//        let data = try c.serialized(options: .prettyPrinted)
        print(try c.stringified(options: [.withoutEscapingSlashes, .prettyPrinted]))
//        print(try b.stringified())
//        XCTAssertEqual(
//            try b["asdf"][2].cast(),
//            "77"
//        )
//
//        XCTAssertThrowsError(
//            try b[3].get()
//        )
//
//        XCTAssertEqual(
//            try b["asdf"][2].cast(as: String.self),
//            try b.getDescendant(by: ["asdf", .index(2)]).cast(as: String.self)
//        )
    }
//
//    func test2() throws {
//        let subscription: JSONData = [
//            "action": "sub",
//            "subscriptions": [
//                ["channel": "book", "market": "btctwd", "depth": 1],
//                ["channel": "trade", "market": "btctwd"],
//                ["channel": "ticker", "market": "btctwd"]
//            ]
//        ]
//
//        let subscriptionString = try subscription.stringified()
//        print(subscriptionString)
//        let newData = try subscriptionString.toJSONData()
//        let a = try newData.cast(as: [String: Any].self)
//        let aString = try a.stringified()
//    }
//
//    func test3() throws {
//        let a = try "3".toJSONData()
//        print(a)
//    }

//    static var allTests = [
//        ("testExample", testExample),
//    ]
}
