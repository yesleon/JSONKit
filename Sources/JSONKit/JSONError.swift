//
//  JSONError.swift
//  
//
//  Created by Li-Heng Hsu on 2021/3/7.
//


public enum JSONError: Swift.Error {
    case doesNotSupportSubscriptByIndex(JSONData)
    case doesNotSupportSubscriptByKey(JSONData)
    case typeDoesNotMatch(JSONData)
    case memberIsNotJSONType(Any)
    case indexOutOfBound(Array<Any>)
}
