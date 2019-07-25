//: [Previous](@previous)

//
//  AccessibilityIdentifier.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/28.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit


public protocol PrettyRawValue: RawRepresentable where RawValue == String {
    var prettyRawValue: RawValue { get }
}
public extension PrettyRawValue {
    var prettyRawValue: RawValue {
        let paths = String(reflecting: self).split(separator: ".").dropFirst()
        if String(paths.last ?? "") != rawValue {
            return rawValue
        }
        return paths.joined(separator: "_")
    }
}




infix operator >>>
public func >>> <T: RawRepresentable>(lhs: UIAccessibilityIdentification?, rhs: T) where T.RawValue == String {
    lhs?.accessibilityIdentifier = rhs.rawValue
}
public func >>> <T: PrettyRawValue>(lhs: UIAccessibilityIdentification?, rhs: T) {
    lhs?.accessibilityIdentifier = rhs.prettyRawValue
}

extension UIAccessibilityIdentification {
    func accessibilityID<T: RawRepresentable>(_ r: T) where T.RawValue == String {
        self.accessibilityIdentifier = r.rawValue
    }
    func accessibilityID<T: PrettyRawValue>(_ r: T) {
        self.accessibilityIdentifier = r.prettyRawValue
    }
}



extension String: RawRepresentable {
    public var rawValue: String { return self }
    public init?(rawValue: String) {
        self = rawValue
    }
}




struct AccessibilityID {}
extension AccessibilityID {
    enum Home1: String {
        case setting = "HomeSetting1"
    }
    enum Home2: String, PrettyRawValue {
        case setting
    }
    enum Home3: String, PrettyRawValue {
        case setting = "HomeSetting3"
    }
}

let path1 = AccessibilityID.Home1.setting.rawValue
// "HomeSetting1"

let path2_1 = AccessibilityID.Home2.setting.rawValue
// "setting"
let path2_2 = AccessibilityID.Home2.setting.prettyRawValue
// "AccessibilityID_Home2_setting"

let path3 = AccessibilityID.Home3.setting.prettyRawValue
// "HomeSetting3"

//let view = UIView()
//view >>> AccessibilityID.Home2.setting
//print(view.accessibilityIdentifier ?? "null")
