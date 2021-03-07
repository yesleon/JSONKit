//
//  ValueType.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

import Foundation


protocol ValueType {
    func getMember(by accessor: Accessor) -> Result<ValueType, Error>
}

extension ValueType {
    
    subscript(index: Int) -> Result<ValueType, Error> {
        return getMember(by: .index(index))
    }
    
    subscript(key: String) -> Result<ValueType, Error> {
        return getMember(by: .key(key))
    }
    
    subscript(path: [Accessor]) -> Result<ValueType, Error> {
        var value = Result<ValueType, Error>.success(self)
        
        path.forEach { accessor in
            value = value.getMember(by: accessor)
        }
        return value
    }
    
    func getMember(by accessor: Accessor) -> Result<ValueType, Error> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
}

extension Result where Success == ValueType, Failure == Error {
    
    subscript(index: Int) -> Result<ValueType, Error> {
        return self.getMember(by: .index(index))
    }
    
    subscript(key: String) -> Result<ValueType, Error> {
        return self.getMember(by: .key(key))
    }
    
    func getMember(by accessor: Accessor) -> Result<ValueType, Error> {
        switch accessor {
        case .index(let index):
            return self.flatMap { $0.getMember(by: .index(index)) }
        case .key(let key):
            return self.flatMap { $0.getMember(by: .key(key)) }
        }
    }
    
    func get<T: ValueType>(as type: T.Type = T.self) throws -> T {
        let content = try get()
        guard let value = content as? T else {
            throw Error.typeDoesNotMatch(content)
        }
        return value
    }
}

extension String: ValueType { }

extension Bool: ValueType { }

extension Int: ValueType { }

extension Dictionary: ValueType where Key == String, Value == ValueType {
    
    func getMember(by accessor: Accessor) -> Result<ValueType, Error> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key(let key):
            guard let value = self[key] else {
                return .success(Optional<ValueType>.none)
            }
            return .success(value)
        }
    }
}

extension Array: ValueType where Element == ValueType {
    
    func getMember(index: Int) -> Result<ValueType, Error> {
        return .success(self[index])
    }
    
    func getMember(by accessor: Accessor) -> Result<ValueType, Error> {
        switch accessor {
        case .index(let index):
            return .success(self[index])
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
}

extension Optional: ValueType where Wrapped == ValueType {
    
    func getMember(by accessor: Accessor) -> Result<ValueType, Error> {
        if let value = self {
            return value.getMember(by: accessor)
        } else {
            return .success(Self.none)
        }
    }
}

