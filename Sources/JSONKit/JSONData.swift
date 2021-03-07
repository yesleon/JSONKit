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

public protocol JSONData {
    func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError>
    func cast<T: JSONData>(as type: T.Type) throws -> T
}

public extension JSONData {
    
    subscript(index: Int) -> Result<JSONData, JSONError> {
        return getMember(by: .index(index))
    }
    
    subscript(key: String) -> Result<JSONData, JSONError> {
        return getMember(by: .key(key))
    }
    
    subscript(path: [JSONAccessor]) -> Result<JSONData, JSONError> {
        var value = Result<JSONData, JSONError>.success(self)
        
        path.forEach { accessor in
            value = value.getMember(by: accessor)
        }
        return value
    }
    
    func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
    
    func cast<T: JSONData>(as type: T.Type = T.self) throws -> T {

        return try castAsJSONData(self).cast(as: T.self)
    }
}

extension Result: JSONData where Success == JSONData, Failure == JSONError {
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index(let index):
            return self.flatMap { $0.getMember(by: .index(index)) }
        case .key(let key):
            return self.flatMap { $0.getMember(by: .key(key)) }
        }
    }
    
    public func cast<T: JSONData>(as type: T.Type = T.self) throws -> T {
        let content = try get()
        guard let value = content as? T else {
            throw JSONError.typeDoesNotMatch(content)
        }
        return value
    }
}

extension String: JSONData { }

extension Bool: JSONData { }

extension Int: JSONData { }

extension Dictionary: JSONData where Key == String {
    
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
    
    public func getMember(by accessor: JSONAccessor) -> Result<JSONData, JSONError> {
        switch accessor {
        case .index(let index):
            let member = self[index]
            
            return castAsJSONData(member)
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
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

