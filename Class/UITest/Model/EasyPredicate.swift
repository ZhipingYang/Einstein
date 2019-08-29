//
//  Predicate.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/2.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation
import XCTest

/// infix string of Regular expression
public enum Comparison: RawRepresentable {
    case equals
    case notEqual
    case beginsWith
    case contains
    case endsWith
    case like
    case matches
    case other(String)
    
    public var rawValue: String {
        switch self {
        case .equals: return "="
        case .notEqual: return "!="
        case .beginsWith: return "BEGINSWITH"
        case .contains: return "CONTAINS"
        case .endsWith: return "ENDSWITH"
        case .like: return "LIKE"
        case .matches: return "MATCHES"
        case .other(let comparisonOperator): return comparisonOperator
        }
    }
    
    public init(rawValue: String) {
        switch rawValue {
        case "=": self = .equals
        case "!=": self = .notEqual
        case "BEGINSWITH": self = .beginsWith
        case "CONTAINS": self = .contains
        case "ENDSWITH": self = .endsWith
        case "LIKE": self = .like
        case "MATCHES": self = .matches
        default: self = .other(rawValue)
        }
    }
}

/// PredicateKey
public enum PredicateKey {
    public enum bool: String    { case exists, isEnabled, isHittable, isSelected }
    public enum string: String  { case identifier, label }
    public enum type: String    { case elementType }
}

/// PredicateRawValue
public enum PredicateRawValue: RawRepresentable {
    public var rawValue: String { return regularString }
    public init?(rawValue: String) {
        self = .custom(regular: rawValue)
    }
    
    case bool(key: PredicateKey.bool, comparison: Comparison, value: Bool)
    case string(key: PredicateKey.string, comparison: Comparison, value: String)
    case type(value: XCUIElement.ElementType)
    case custom(regular: String)
}

public extension PredicateRawValue {
    // convert to regularString
    var regularString: String {
        switch self {
        case .bool(let key, let comparison, let value):
            return "\(key.rawValue) \(comparison.rawValue) \(value ? "true" : "false")"
        case .string(let key, let comparison, let value):
            return "\(key.rawValue) \(comparison.rawValue) '\(value)'"
        case .type(let value):
            return "\(PredicateKey.type.elementType.rawValue) \(Comparison.equals.rawValue) \(value.rawValue)"
        case .custom(let regular):
            return regular
        }
    }
}

/*
 MARK: - EasyPredicate
 
 Although `NSPredicate` is powerfull but the developer interface is not good enough,
 We can try to convert the hard code style into the object-oriented style as below.
 */
public enum EasyPredicate: RawRepresentable {
    
    case exists(_ exists: Bool)
    case isEnabled(_ isEnabled: Bool)
    case isHittable(_ isHittable: Bool)
    case isSelected(_ isSelected: Bool)
    case label(_ comparison: Comparison, _ value: String)
    case identifier(_ identifier: String)
    case type(_ type: XCUIElement.ElementType)
    case other(_ ragular: String)
    
    public init?(rawValue: PredicateRawValue) {
        switch rawValue {
        case .bool(let key, _, let value):
            switch key {
            case .exists:       self = .exists(value)
            case .isEnabled:    self = .isEnabled(value)
            case .isSelected:   self = .isSelected(value)
            case .isHittable:   self = .isHittable(value)
            }
        case .type(let value):  self = .type(value)
        case .string(let key, let comparison, let value):
            switch key {
            case .label:        self = .label(comparison, value)
            case .identifier:   self = .identifier(value)
            }
        case .custom(let regular): self = .other(regular)
        }
    }
    
    public var rawValue: PredicateRawValue {
        switch self {
        case .exists(let value):
            return .bool(key: .exists, comparison: .equals, value: value)
        case .isEnabled(let value):
            return .bool(key: .isEnabled, comparison: .equals, value: value)
        case .isHittable(let value):
            return .bool(key: .isHittable, comparison: .equals, value: value)
        case .isSelected(let value):
            return .bool(key: .isSelected, comparison: .equals, value: value)
        case .label(let comparison, let value):
            return .string(key: .label, comparison: comparison, value: value)
        case .identifier(let value):
            return .string(key: .identifier, comparison: .equals, value: value)
        case .type(let value):
            return .type(value: value)
        case .other(let value):
            return .custom(regular: value)
        }
    }
}

extension EasyPredicate: Equatable {
    // Equatable
    public static func ==(l: EasyPredicate, r: EasyPredicate) -> Bool {
        return l.rawValue.regularString == r.rawValue.regularString
    }
    public var toPredicate: NSPredicate {
        return NSPredicate(format: rawValue.regularString)
    }
}

public extension Sequence where Element == EasyPredicate {
    /// convert EasyPredicates to NSCompoundPredicate
    func toPredicate(_ logic: NSCompoundPredicate.LogicalType) -> NSCompoundPredicate {
        return NSCompoundPredicate(type: logic, subpredicates: map { $0.toPredicate })
    }
    
    func merged(withLogic logic: NSCompoundPredicate.LogicalType = .and) -> EasyPredicate {
        let regulars = map { "(\($0.rawValue.regularString))" }
        let _logic = (logic == .not) ? .and : logic
        var result = regulars.joined(separator: _logic.regularString)
        if logic == .not { result = "!(\(result))" }
        return EasyPredicate.other(result)
    }
}

extension NSCompoundPredicate.LogicalType {
    var regularString: String {
        switch self {
        case .and: return " AND "
        case .or: return " OR "
        case .not: return " NOT "
        @unknown default: fatalError()
        }
    }
}
