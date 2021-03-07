//
//  JSONType.swift
//  JSONKit
//
//  Created by Li-Heng Hsu on 2021/3/7.
//

import Foundation

enum JSONError: Error {
    case falseType(JSONType)
    case missingKey(JSONType)
}

protocol JSONType {
    func getMember(index: Int) throws -> JSONType
    func getMember(key: String) throws -> JSONType
}

extension JSONType {
    
    subscript(index: Int) -> JSONType? {
        try? getMember(index: index)
    }
    
    subscript(key: String) -> JSONType? {
        try? getMember(key: String)
    }
    
    func getMember(index: Int) throws -> JSONType {
        throw JSONError.falseType(self)
    }
    
    func getMember(key: String) throws -> JSONType {
        throw JSONError.falseType(self)
    }
}

extension String: JSONType { }

extension Bool: JSONType { }

extension Int: JSONType { }

extension Dictionary: JSONType where Key == String, Value == Any {
    
    func getMember(key: String) throws -> JSONType {
        guard let value = self[key] else {
            throw JSONError.missingKey(self)
        }
        guard let member = value as? JSONType else {
            throw JSONError.falseType(self)
        }
        return member
    }
}

extension Array: JSONType {
    
    func getMember(index: Int) throws -> JSONType {
        guard let member = self[index] as? JSONType else {
            throw JSONError.falseType(self)
        }
        return member
    }
}
