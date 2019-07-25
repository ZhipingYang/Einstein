//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

enum StringComparisonOperator: RawRepresentable {
    case equals
    case beginsWith
    case contains
    case endsWith
    case like
    case matches
    case other(comparisonOperator: String)
    
    var rawValue: String {
        switch self {
        case .equals: return "=="
        case .beginsWith: return "BEGINSWITH"
        case .contains: return "CONTAINS"
        case .endsWith: return "ENDSWITH"
        case .like: return "LIKE"
        case .matches: return "MATCHES"
        case .other(let comparisonOperator): return comparisonOperator
        }
    }
    
    /// Initialize comparison operator with string.
    public init(rawValue: String) {
        switch rawValue {
        case "==": self = .equals
        case "BEGINSWITH": self = .beginsWith
        case "CONTAINS": self = .contains
        case "ENDSWITH": self = .endsWith
        case "LIKE": self = .like
        case "MATCHES": self = .matches
        default: self = .other(comparisonOperator: rawValue)
        }
    }
}

public enum Predicate: RawRepresentable {
    
    public struct RawRepresent : Equatable {
        let key: String
        let value: Bool
        public static func ==(l: RawRepresent, r: RawRepresent) -> Bool {
            return l.key == r.key && l.value == r.value
        }
        static var exists: RawRepresent { return RawRepresent(key: "exists", value: true) }
        static var notExists: RawRepresent { return RawRepresent(key: "exists", value: false) }
        static var enable: RawRepresent { return RawRepresent(key: "isEnabled", value: true) }
        static var disable: RawRepresent { return RawRepresent(key: "isEnabled", value: false) }
    }
    
    case exists(_ exists: Bool)
    case isEnabled(_ isEnabled: Bool)
    
    public init?(rawValue: RawRepresent) {
        switch rawValue {
        case RawRepresent.exists:    self = .exists(true)
        case RawRepresent.notExists: self = .exists(false)
        case RawRepresent.enable:    self = .isEnabled(true)
        case RawRepresent.disable:   self = .isEnabled(false)
        default: return nil
        }
    }
    
    public var rawValue: RawRepresent {
        switch self {
        case .exists(let value):
            return value ? RawRepresent.exists : RawRepresent.notExists
        case .isEnabled(let value):
            return value ? RawRepresent.enable : RawRepresent.disable
        }
    }
    public var convert: NSPredicate {
        return NSPredicate(format: "\(rawValue.key) == \(rawValue.value)")
    }
}

