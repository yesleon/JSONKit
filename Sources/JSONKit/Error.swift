//
//  Error.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/7.
//


enum Error: Swift.Error {
    case doesNotSupportSubscriptByIndex(Data)
    case doesNotSupportSubscriptByKey(Data)
    case typeDoesNotMatch(Data)
    case memberIsNotJSONType(Any)
}
