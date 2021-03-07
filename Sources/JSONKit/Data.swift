//
//  Data.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

import Foundation


protocol Data {
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error>
}

extension Data {
    
    subscript(index: Int) -> Result<Data, Error> {
        return getMember(by: .index(index))
    }
    
    subscript(key: String) -> Result<Data, Error> {
        return getMember(by: .key(key))
    }
    
    subscript(path: [MemberAccessor]) -> Result<Data, Error> {
        var value = Result<Data, Error>.success(self)
        
        path.forEach { accessor in
            value = value.getMember(by: accessor)
        }
        return value
    }
    
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
}

extension Result where Success == Data, Failure == Error {
    
    subscript(index: Int) -> Result<Data, Error> {
        return self.getMember(by: .index(index))
    }
    
    subscript(key: String) -> Result<Data, Error> {
        return self.getMember(by: .key(key))
    }
    
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error> {
        switch accessor {
        case .index(let index):
            return self.flatMap { $0.getMember(by: .index(index)) }
        case .key(let key):
            return self.flatMap { $0.getMember(by: .key(key)) }
        }
    }
    
    func get<T: Data>(as type: T.Type = T.self) throws -> T {
        let content = try get()
        guard let value = content as? T else {
            throw Error.typeDoesNotMatch(content)
        }
        return value
    }
}

extension String: Data { }

extension Bool: Data { }

extension Int: Data { }

extension Dictionary: Data where Key == String {
    
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error> {
        switch accessor {
        case .index:
            return .failure(.doesNotSupportSubscriptByIndex(self))
        case .key(let key):
            guard let member = self[key] else {
                return .success(Optional<Data>.none)
            }
            guard let value = member as? Data else {
                return .failure(.memberIsNotJSONType(member))
            }
            return .success(value)
        }
    }
}

extension Array: Data {
    
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error> {
        switch accessor {
        case .index(let index):
            let member = self[index]
            guard let value = member as? Data else {
                return .failure(.memberIsNotJSONType(member))
            }
            return .success(value)
        case .key:
            return .failure(.doesNotSupportSubscriptByKey(self))
        }
    }
}

extension Optional: Data where Wrapped == Data {
    
    func getMember(by accessor: MemberAccessor) -> Result<Data, Error> {
        if let value = self {
            return value.getMember(by: accessor)
        } else {
            return .success(Self.none)
        }
    }
}

