//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

// MARK: center string of Regular expression

public enum ComparisonOperator: RawRepresentable {
    case equals
    case beginsWith
    case contains
    case endsWith
    case like
    case matches
    case other(comparisonOperator: String)
    
    public var rawValue: String {
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

public enum PredicateKey: String {
    case exists
    case isEnabled
    case isHittable
    case identifier
    case label
    case isSelected
}

public enum PredicateRawValue {
    case keyBool(key: PredicateKey, comparison: ComparisonOperator, value: Bool)
    case keyString(key: PredicateKey, comparison: ComparisonOperator, value: String)
    case custom(regular: String)
}

extension PredicateRawValue: Equatable {
    // Equatable
    public static func ==(l: PredicateRawValue, r: PredicateRawValue) -> Bool {
        return l.regularString == r.regularString
    }
    
    // static cases
    static var exists: PredicateRawValue {
        return PredicateRawValue.keyBool(key: .exists, comparison: .equals, value: true)
    }
    static var notExists: PredicateRawValue {
        return PredicateRawValue.keyBool(key: .exists, comparison: .equals, value: false)
    }
    static var enable: PredicateRawValue {
        return PredicateRawValue.keyBool(key: .isEnabled, comparison: .equals, value: true)
    }
    static var disable: PredicateRawValue {
        return PredicateRawValue.keyBool(key: .isEnabled, comparison: .equals, value: false)
    }
    
    // methods
    var regularString: String {
        switch self {
        case .keyBool(let key, let comparison, let value):
            return "\(key.rawValue) \(comparison.rawValue) \(value)"
        case .keyString(let key, let comparison, let value):
            return "\(key.rawValue) \(comparison.rawValue) \(value)"
        case .custom(let regular):
            return regular
        }
    }
    
    var toPredicate: NSPredicate {
        return NSPredicate(format: regularString)
    }
}

public enum EasyPredicate: RawRepresentable {
    
    case exists(_ exists: Bool)
    case isEnabled(_ isEnabled: Bool)
    case other(_ rawValue: String)
    
    public init?(rawValue: PredicateRawValue) {
        switch rawValue {
        case PredicateRawValue.exists:    self = .exists(true)
        case PredicateRawValue.notExists: self = .exists(false)
        case PredicateRawValue.enable:    self = .isEnabled(true)
        case PredicateRawValue.disable:   self = .isEnabled(false)
        default: self = .other(rawValue.regularString)
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return value ? PredicateRawValue.exists : PredicateRawValue.notExists
        case .isEnabled(let value):
            return value ? PredicateRawValue.enable : PredicateRawValue.disable
        case .other(let value):
            return PredicateRawValue.custom(regular: value)
        }
    }
}
