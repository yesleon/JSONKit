//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//





enum Accessor {
    case index(Int), key(String)
}

extension Accessor: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        self = .key(value)
    }
}

extension Accessor: ExpressibleByIntegerLiteral {
    
    init(integerLiteral value: Int) {
        self = .index(value)
    }
}
