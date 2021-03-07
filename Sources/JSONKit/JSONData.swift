//
//  JSONData.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

import Foundation

func castAsJSONData(_ object: Any) -> Result<JSONData, JSONError> {
    switch object {
    case let value as [String: Any]:
        return .success(value)
    case let value as [Any]:
        return .success(value)
    case let value as String:
        return .success(value)
    case let value as Int:
        return .success(value)
    case let value as Bool:
        return .success(value)
    default:
        return .failure(.memberIsNotJSONType(object))
    }
}

public extension Data {
    func toJSONData() throws -> JSONData {
        let object = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
        return try castAsJSONData(object).get()
    }
}

public extension String {
    func toJSONData() throws -> JSONData {
        let data = self.data(using: .utf8)!
        return try data.toJSONData()
    }
}

public protocol JSONStringifiable {
    func stringified() throws -> String
}

public typealias JSONData = JSONMemberAccessing & JSONCasting & JSONStringifiable

extension String: JSONData {
    public func stringified() throws -> String {
        return "\"\(self)\""
    }
}

extension Bool: JSONData {
    public func stringified() throws -> String {
        return self ? "true" : "false"
    }
}

extension Int: JSONData {
    public func stringified() throws -> String {
        return "\(self)"
    }
}

extension Dictionary: JSONData where Key == String {
    
    public func stringified() throws -> String {
        var string = "{"
        if !self.isEmpty {
            try self.forEach { key, value in
                let value = try castAsJSONData(value).get()
                try string += key.stringified() + ": " + value.stringified() + ","
            }
            string.removeLast()
        }
        string += "}"
        return string
    }
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key(let key):
            guard let member = self[key] else {
                return .success(Optional<JSONData>.none)
            }
            
            return castAsJSONData(member)
        }
    }
}

extension Array: JSONData {
    public func stringified() throws -> String {
        var string = "["
        if !self.isEmpty {
            try self.forEach { element in
                let element = try castAsJSONData(element).get()
                try string += element.stringified() + ","
            }
            string.removeLast()
        }
        string += "]"
        return string
    }
    
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index(let index):
            guard index < self.endIndex else {
                return .failure(.indexOutOfBound(self))
            }
            let member = self[index]
            
            return castAsJSONData(member)
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
}

extension Optional: JSONData where Wrapped == JSONData {
    public func stringified() throws -> String {
        if let self = self {
            return try self.stringified()
        }
        return "null"
    }
    
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        if let value = self {
            return value.getMember(by: accessor)
        } else {
            return .success(Self.none)
        }
    }
}
