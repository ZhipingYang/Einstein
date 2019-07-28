//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

// MARK: center string of Regular expression

public enum Comparison: RawRepresentable {
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
    case exists, isEnabled, isHittable, identifier, label, isSelected
}

public enum PredicateRawValue {
    case keyBool(key: PredicateKey, comparison: Comparison, value: Bool)
    case keyString(key: PredicateKey, comparison: Comparison, value: String)
    case custom(regular: String)
}

extension PredicateRawValue: Equatable {
    // Equatable
    public static func ==(l: PredicateRawValue, r: PredicateRawValue) -> Bool {
        return l.regularString == r.regularString
    }
    
    // static cases
    static var exists: PredicateRawValue {
        return .keyBool(key: .exists, comparison: .equals, value: true)
    }
    static var notExists: PredicateRawValue {
        return .keyBool(key: .exists, comparison: .equals, value: false)
    }
    static var enable: PredicateRawValue {
        return .keyBool(key: .isEnabled, comparison: .equals, value: true)
    }
    static var disable: PredicateRawValue {
        return .keyBool(key: .isEnabled, comparison: .equals, value: false)
    }
    static var selected: PredicateRawValue {
        return .keyBool(key: .isSelected, comparison: .equals, value: true)
    }
    static var unselected: PredicateRawValue {
        return .keyBool(key: .isSelected, comparison: .equals, value: false)
    }
    static var hittable: PredicateRawValue {
        return .keyBool(key: .isHittable, comparison: .equals, value: true)
    }
    static var unhittable: PredicateRawValue {
        return .keyBool(key: .isHittable, comparison: .equals, value: false)
    }
    static func identifier(_ value: String) -> PredicateRawValue {
        return .keyString(key: .identifier, comparison: .equals, value: value)
    }
    static func label(comparison: Comparison, value: String) -> PredicateRawValue {
        return .keyString(key: .label, comparison: comparison, value: value)
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
    case isHittable(_ isHittable: Bool)
    case isSelected(_ isSelected: Bool)
    case label(comparison: Comparison, value: String)
    case identifier(_ identifier: String)
    case other(_ ragular: String)
    
    public init?(rawValue: PredicateRawValue) {
        switch rawValue {
        case .exists:    self = .exists(true)
        case .notExists: self = .exists(false)
        case .enable:    self = .isEnabled(true)
        case .disable:   self = .isEnabled(false)
        default: self = .other(rawValue.regularString)
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return value ? .exists : .notExists
        case .isEnabled(let value):
            return value ? .enable : .disable
        case .other(let value):
            return .custom(regular: value)
        case .label(let comparison, let value):
            return .label(comparison: comparison, value: value)
        case .identifier(let value):
            return .identifier(value)
        case .isHittable(let value):
            return value ? .hittable : .unhittable
        case .isSelected(let value):
            return value ? .selected : .unselected
        }
    }
}
