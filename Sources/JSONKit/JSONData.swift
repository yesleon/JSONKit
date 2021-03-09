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

public typealias JSONData = JSONMemberAccessing & JSONCasting & JSONStringifiable

extension String: JSONData {
}

extension Bool: JSONData {
}

extension Int: JSONData {
}

extension Dictionary: JSONData where Key == String {
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index(let index):
            return getMember(by: .key("\(index)"))
        case .key(let key):
            guard let member = self[key] else {
                return .success(Optional<JSONData>.none)
            }
            
            return castAsJSONData(member)
        }
    }
}

extension Array: JSONData {
    
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index(let index):
            guard index < self.endIndex else {
                return .failure(.indexOutOfBound(self))
            }
            let member = self[index]
            
            return castAsJSONData(member)
        case .key(let key):
            if let index = Int(key) {
                return getMember(by: .index(index))
            } else {
                return .failure(.doesNotSupportSubscriptByKey(self))
            }
        }
    }
}

extension Optional: JSONData where Wrapped == JSONData {
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        if let value = self {
            return value.getMember(by: accessor)
        } else {
            return .success(Self.none)
        }
    }
}
