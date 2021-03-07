//
//  File.swift
//  
//
//  Created by 許立衡 on 2021/3/7.
//



typealias AccessorPath = Array<Accessor>

enum Accessor {
    case index(Int), key(String)
}
