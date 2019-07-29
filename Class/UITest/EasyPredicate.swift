//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation
import XCTest

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
    case exists, isEnabled, isHittable, isSelected, identifier, label, elementType
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
    
    // methods
    var predicateKey: PredicateKey? {
        switch self {
        case .keyBool(let key, _, _): return key
        case .keyString(let key, _, _): return key
        default: return nil }
    }

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
    case type(_ type: XCUIElement.ElementType)
    case other(_ ragular: String)
    
    public init?(rawValue: PredicateRawValue) {
        switch rawValue {
        case .keyBool(let key, _, let value):
            switch key {
            case .exists:       self = .exists(value)
            case .isEnabled:    self = .isEnabled(value)
            case .isSelected:   self = .isSelected(value)
            case .isHittable:   self = .isHittable(value)
            default: return nil
            }
        case PredicateRawValue.keyString(let key, let comparison, let value):
            switch key {
            case .label:        self = .label(comparison: comparison, value: value)
            case .identifier:   self = .identifier(value)
            case .elementType:
                guard let _rawValue = UInt(value), let _type = XCUIElement.ElementType(rawValue: _rawValue) else {
                    fatalError("Element Type setting wrong!")
                    return nil
                }
                self = .type(_type)
            default: return nil
            }
        case .custom(let regular): self = .other(regular)
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return .keyBool(key: .exists, comparison: .equals, value: value)
        case .isEnabled(let value):
            return .keyBool(key: .isEnabled, comparison: .equals, value: value)
        case .isHittable(let value):
            return .keyBool(key: .isHittable, comparison: .equals, value: value)
        case .isSelected(let value):
            return .keyBool(key: .isSelected, comparison: .equals, value: value)
        case .label(let comparison, let value):
            return .keyString(key: .label, comparison: comparison, value: value)
        case .identifier(let value):
            return .keyString(key: .identifier, comparison: .equals, value: value)
        case .type(let value):
            return .keyString(key: .elementType, comparison: .equals, value: "\(value.rawValue)")
        case .other(let value):
            return .custom(regular: value)
        }
    }
}



