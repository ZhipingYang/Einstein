//
//  AccessibilityIdentifier.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/28.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

// MARK: - pretty RawRepresentable as a keypath string of object
public protocol PrettyRawRepresentable: RawRepresentable where RawValue == String {
    var prettyRawValue: RawValue { get }
}

public extension PrettyRawRepresentable {
    var prettyRawValue: String {
        let paths = String(reflecting: self).split(separator: ".").dropFirst()
        if String(paths.last ?? "") != rawValue {
            return rawValue
        }
        return paths.joined(separator: "_")
    }
}

// MARK: - accessibilityIdentifier assignment
/// method 1
infix operator >>>
public func >>> <T: RawRepresentable>(lhs: UIAccessibilityIdentification?, rhs: T) where T.RawValue == String {
    lhs?.accessibilityIdentifier = rhs.rawValue
}
public func >>> <T: PrettyRawRepresentable>(lhs: UIAccessibilityIdentification?, rhs: T) {
    lhs?.accessibilityIdentifier = rhs.prettyRawValue
}

/// method 2
public extension UIAccessibilityIdentification {
    func accessibilityID<T: RawRepresentable>(_ r: T) where T.RawValue == String {
        self.accessibilityIdentifier = r.rawValue
    }
    func accessibilityID<T: PrettyRawRepresentable>(_ r: T) {
        self.accessibilityIdentifier = r.prettyRawValue
    }
}
