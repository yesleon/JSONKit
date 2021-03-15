//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//





//public enum JSONAccessor {
//    case index(Int), key(String)
//}
//
//extension JSONAccessor: ExpressibleByStringLiteral {
//    
//    public init(stringLiteral value: String) {
//        self = .key(value)
//    }
//}
//
//extension JSONAccessor: ExpressibleByIntegerLiteral {
//    
//    public init(integerLiteral value: Int) {
//        self = .index(value)
//    }
//}
//
//public protocol JSONMemberAccessing {
//    func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError>
//}
//
//public extension JSONMemberAccessing {
//    
//    subscript(index: Int) -> Result<JSONData, JSONError> {
//        return getMember(by: .index(index))
//    }
//    
//    subscript(key: String) -> Result<JSONData, JSONError> {
//        return getMember(by: .key(key))
//    }
//}
//
//public extension JSONMemberAccessing where Self: JSONData {
//    
//    func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
//        switch accessor {
//        case .index:
//            return .failure(.doesNotSupportSubscriptByIndex(self))
//        case .key:
//            return .failure(.doesNotSupportSubscriptByKey(self))
//        }
//    }
//    
//    func getDescendant(by path: [JSONAccessor]) -> Result<JSONData, JSONError> {
//        var value = Result<JSONData, JSONError>.success(self)
//        
//        path.forEach { accessor in
//            value = value.getMember(by: accessor)
//        }
//        return value
//    }
//}
//
//
//
//extension Result: JSONMemberAccessing where Success == JSONData, Failure == JSONError {
//    
//    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
//        switch accessor {
//        case .index(let index):
//            return self.flatMap { $0.getMember(by: .index(index)) }
//        case .key(let key):
//            return self.flatMap { $0.getMember(by: .key(key)) }
//        }
//    }
//}
//
//extension Result: JSONCasting where Success == JSONData {
//    
//    public func cast<T: JSONData>(as type: T.Type = T.self) throws -> T {
//        let content = try get()
//        guard let value = content as? T else {
//            throw JSONError.typeDoesNotMatch(content)
//        }
//        return value
//    }
//}

