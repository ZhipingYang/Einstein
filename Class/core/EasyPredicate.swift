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

public struct PredicateRawValue : Equatable {
    let key: String
    let value: Bool
    let comparisonOperator: StringComparisonOperator
    
    static var exists: PredicateRawValue {
        return PredicateRawValue(key: "exists", value: true, comparisonOperator: .equals)
    }
    static var notExists: PredicateRawValue {
        return PredicateRawValue(key: "exists", value: false, comparisonOperator: .equals)
    }
    static var enable: PredicateRawValue {
        return PredicateRawValue(key: "isEnabled", value: true, comparisonOperator: .equals)
    }
    static var disable: PredicateRawValue {
        return PredicateRawValue(key: "isEnabled", value: false, comparisonOperator: .equals)
    }
    
    public static func ==(l: PredicateRawValue, r: PredicateRawValue) -> Bool {
        return l.key == r.key
            && l.value == r.value
            && l.comparisonOperator == r.comparisonOperator
    }
    
    public var toPredicate: NSPredicate {
        return NSPredicate(format: "\(key) \(comparisonOperator.rawValue) \(value)")
    }
}

public enum EasyPredicate: RawRepresentable {
    
    case exists(_ exists: Bool)
    case isEnabled(_ isEnabled: Bool)
    case other(_ rawValue: PredicateRawValue)
    
    public init?(rawValue: PredicateRawValue) {
        switch rawValue {
        case PredicateRawValue.exists:    self = .exists(true)
        case PredicateRawValue.notExists: self = .exists(false)
        case PredicateRawValue.enable:    self = .isEnabled(true)
        case PredicateRawValue.disable:   self = .isEnabled(false)
        default: return nil
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return value ? PredicateRawValue.exists : PredicateRawValue.notExists
        case .isEnabled(let value):
            return value ? PredicateRawValue.enable : PredicateRawValue.disable
        case .other(let value):
            return value
        }
    }
}

