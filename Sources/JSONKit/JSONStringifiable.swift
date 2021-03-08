//
//  JSONStringifiable.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/8.
//

import Foundation


public protocol JSONStringifiable { }
public extension JSONStringifiable where Self: JSONData {
    func stringified() throws -> String {
        let data = try JSONSerialization.data(withJSONObject: self, options: [.fragmentsAllowed, .prettyPrinted])
        return String(data: data, encoding: .utf8)!
    }
}
