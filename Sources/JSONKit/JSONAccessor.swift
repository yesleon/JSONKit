//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//





public enum JSONAccessor {
    case index(Int), key(String)
}

extension JSONAccessor: ExpressibleByStringLiteral {
    
    public init(stringLiteral value: String) {
        self = .key(value)
    }
}

extension JSONAccessor: ExpressibleByIntegerLiteral {
    
    public init(integerLiteral value: Int) {
        self = .index(value)
    }
}
