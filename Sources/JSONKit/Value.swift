//
//  Value.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

import Foundation

public typealias Number = Double

public typealias Key = String
public typealias Index = Int

public typealias StringifyOptions = JSONSerialization.WritingOptions
public typealias ParseOptions = JSONSerialization.ReadingOptions

public enum Error: Swift.Error {
    case wrongType(Any)
    case notObject(Value)
    case notArray(Value)
    case stringifyFailure(Data)
    case parseFailure(String)
}

public enum Value {
    
    case bool(Bool)
    case number(Number)
    case string(String)
    case array([Value])
    case object([Key: Value])
    case null
    
    public init(jsonString: String, options: ParseOptions) throws {
        guard let data = jsonString.data(using: .utf8) else {
            throw Error.parseFailure(jsonString)
        }
        try self.init(jsonData: data, options: options)
    }
    
    public init(jsonData: Data, options: ParseOptions) throws {
        let value = try JSONSerialization.jsonObject(with: jsonData, options: options)
        try self.init(value: value)
    }
    
    public init(value: Any) throws {
        switch value {
        case let object as [String: Any]:
            self = .object(try object.mapValues(Self.init(value:)))
            
        case let array as [Any]:
            self = .array(try array.map(Self.init(value:)))
            
        case let string as String:
            self = .string(string)

        case let number as Number:
            self = .number(number)

        case let bool as Bool:
            self = .bool(bool)

        case nil:
            self = .null

        default:
            throw Error.wrongType(value)
        }
    }
    
    public func member(for key: Key) throws -> Value? {
        guard case .object(let object) = self else {
            throw Error.notObject(self)
        }
        return object[key]
    }
    
    public func element(at index: Index) throws -> Value {
        guard case .array(let array) = self else {
            throw Error.notArray(self)
        }
        return array[index]
    }
    
    public func extracted() -> Any {
        switch self {
        case .array(let array):
            return array.map { $0.extracted() }
        case .bool(let bool):
            return bool
        case .null:
            return Optional<Any>.none as Any
        case .number(let number):
            return number
        case .object(let object):
            return object.mapValues { $0.extracted() }
        case .string(let string):
            return string
        }
    }
    
    public func serialized(options: StringifyOptions) throws -> Data {
        return try JSONSerialization.data(withJSONObject: extracted(), options: options)
    }
    
    public func stringified(options: StringifyOptions) throws -> String {
        let data = try serialized(options: options)
        guard let string = String(data: data, encoding: .utf8) else {
            throw Error.stringifyFailure(data)
        }
        return string
    }
}


//func castAsJSONData(_ object: Any) -> Result<JSONData, JSONError> {
//    switch object {
//    case let value as [String: Any]:
//        return .success(value)
//    case let value as [Any]:
//        return .success(value)
//    case let value as String:
//        return .success(value)
//    case let value as Int:
//        return .success(value)
//    case let value as Bool:
//        return .success(value)
//    default:
//        return .failure(.memberIsNotJSONType(object))
//    }
//}
//
//public extension Data {
//    func toJSONData() throws -> JSONData {
//        let object = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
//        return try castAsJSONData(object).get()
//    }
//}
//
//public extension String {
//    func toJSONData() throws -> JSONData {
//        let data = self.data(using: .utf8)!
//        return try data.toJSONData()
//    }
//}
//
//public typealias JSONData = JSONMemberAccessing & JSONCasting & JSONStringifiable
//
//extension String: JSONData {
//}
//
//extension Bool: JSONData {
//}
//
//extension Int: JSONData {
//}
//
//extension Dictionary: JSONData where Key == String {
//
//    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
//        switch accessor {
//        case .index(let index):
//            return getMember(by: .key("\(index)"))
//        case .key(let key):
//            guard let member = self[key] else {
//                return .success(Optional<JSONData>.none)
//            }
//
//            return castAsJSONData(member)
//        }
//    }
//}
//
//extension Array: JSONData {
//
//
//    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
//        switch accessor {
//        case .index(let index):
//            guard index < self.endIndex else {
//                return .failure(.indexOutOfBound(self))
//            }
//            let member = self[index]
//
//            return castAsJSONData(member)
//        case .key(let key):
//            if let index = Int(key) {
//                return getMember(by: .index(index))
//            } else {
//                return .failure(.doesNotSupportSubscriptByKey(self))
//            }
//        }
//    }
//}
//
//extension Optional: JSONData where Wrapped == JSONData {
//
//    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
//        if let value = self {
//            return value.getMember(by: accessor)
//        } else {
//            return .success(Self.none)
//        }
//    }
//}
