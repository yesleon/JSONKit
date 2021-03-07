//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//





enum JSONAccessor {
    case index(Int), key(String)
}

extension JSONAccessor: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        self = .key(value)
    }
}

extension JSONAccessor: ExpressibleByIntegerLiteral {
    
    init(integerLiteral value: Int) {
        self = .index(value)
    }
}
