//
//  JSONStringifiable.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/8.
//

import Foundation


public protocol JSONStringifiable { }

public extension JSONStringifiable where Self: JSONData {
    func stringified(prettyPrinted: Bool = true) throws -> String {
        let options: JSONSerialization.WritingOptions = prettyPrinted ? [.fragmentsAllowed, .prettyPrinted] : .fragmentsAllowed
        let data = try JSONSerialization.data(withJSONObject: self, options: options)
        return String(data: data, encoding: .utf8)!
    }
}
