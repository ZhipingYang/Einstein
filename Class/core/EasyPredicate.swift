//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation

// MARK: center string of Regular expression

enum ComparisonOperator: RawRepresentable {
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

public struct PredicateRawValue: Equatable {
    
    private var key: String = ""
    private var value: String = ""
    private var comparisonOperator: ComparisonOperator = .equals
    private var _regularStr: String?
    public var regularStr: String {
        if let regular = _regularStr { return regular }
        return "\(key) \(comparisonOperator.rawValue) \(value)"
    }
    public var toPredicate: NSPredicate {
        return NSPredicate(format: regularStr)
    }

    init(withKey key: String, value: String, comparisonOperator: ComparisonOperator) {
        self.key = key
        self.value = value
        self.comparisonOperator = comparisonOperator
    }
    
    init(_ regular: String) {
        self._regularStr = regular
    }
    
    // static cases
    static var exists: PredicateRawValue {
        return PredicateRawValue(withKey: "exists", value: "true", comparisonOperator: .equals)
    }
    static var notExists: PredicateRawValue {
        return PredicateRawValue(withKey: "exists", value: "false", comparisonOperator: .equals)
    }
    static var enable: PredicateRawValue {
        return PredicateRawValue(withKey: "isEnabled", value: "true", comparisonOperator: .equals)
    }
    static var disable: PredicateRawValue {
        return PredicateRawValue(withKey: "isEnabled", value: "false", comparisonOperator: .equals)
    }
    
    // Equatable
    public static func ==(l: PredicateRawValue, r: PredicateRawValue) -> Bool {
        return l.regularStr == r.regularStr
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
        default: self = .other(rawValue.regularStr)
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return value ? PredicateRawValue.exists : PredicateRawValue.notExists
        case .isEnabled(let value):
            return value ? PredicateRawValue.enable : PredicateRawValue.disable
        case .other(let value):
            return PredicateRawValue(value)
        }
    }
}
