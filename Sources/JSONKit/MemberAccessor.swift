//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//





enum MemberAccessor {
    case index(Int), key(String)
}

extension MemberAccessor: ExpressibleByStringLiteral {
    
    init(stringLiteral value: String) {
        self = .key(value)
    }
}

extension MemberAccessor: ExpressibleByIntegerLiteral {
    
    init(integerLiteral value: Int) {
        self = .index(value)
    }
}
