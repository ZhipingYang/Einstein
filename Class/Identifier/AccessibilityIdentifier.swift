//
//  AccessibilityIdentifier.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/28.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//
#if os(macOS)
    import AppKit
#else
    import UIKit
#endif

/**
 MARK: - pretty RawRepresentable as a keypath string of object
 
 **NOTE:** the priority level
 
 `DefineRawValue > FollowPrettyProtocolButNotDefineRawValue > NoProtocolAndNoDefine`
 
 check the result as follow case:
 
 ```
 struct AccessibilityID {
    enum Home1: String {
        case setting = "HomeSetting1"
    }
    enum Home2: String, PrettyRawRepresentable {
        case setting
    }
    enum Home3: String, PrettyRawRepresentable {
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
 ```
 */
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

/*
 MARK: - accessibilityIdentifier assignment
 
 method 1
 
 use case:
 settingButton <<< AccessibilityID.Home1.setting // "HomeSetting1"
 settingButton <<< AccessibilityID.Home2.setting // "AccessibilityID_Home2_setting"
 settingButton <<< AccessibilityID.Home3.setting // "HomeSetting3"
 */
infix operator <<<
#if os(macOS)

/// set AccessibilityIdentifier on UI elements
///
/// - Parameters:
///   - lhs: UI element
///   - rhs: AccessibilityIdentifier's value
public func <<< <T: RawRepresentable>(lhs: NSAccessibilityProtocol?, rhs: T) where T.RawValue == String {
    lhs?.setAccessibilityIdentifier(rhs.rawValue)
}

/// set AccessibilityIdentifier pretty path value on UI elements
///
/// - Parameters:
///   - lhs: UI element
///   - rhs: AccessibilityIdentifier's value
public func <<< <T: PrettyRawRepresentable>(lhs: NSAccessibilityProtocol?, rhs: T) {
    lhs?.setAccessibilityIdentifier(rhs.prettyRawValue)
}
#else

/// set AccessibilityIdentifier on UI elements
///
/// - Parameters:
///   - lhs: UI element
///   - rhs: AccessibilityIdentifier's value
public func <<< <T: RawRepresentable>(lhs: UIAccessibilityIdentification?, rhs: T) where T.RawValue == String {
    lhs?.accessibilityIdentifier = rhs.rawValue
}

/// set AccessibilityIdentifier pretty path value on UI elements
///
/// - Parameters:
///   - lhs: UI element
///   - rhs: AccessibilityIdentifier's value
public func <<< <T: PrettyRawRepresentable>(lhs: UIAccessibilityIdentification?, rhs: T) {
    lhs?.accessibilityIdentifier = rhs.prettyRawValue
}
#endif



/**
 **use case:**
 ```
 settingButton.accessibilityID(AccessibilityID.Home1.setting) // "HomeSetting1"
 ```
 */
#if os(macOS)
public extension NSAccessibilityProtocol {
    func accessibilityID<T: RawRepresentable>(_ r: T) where T.RawValue == String {
        self.setAccessibilityIdentifier(r.rawValue)
    }
    func accessibilityID<T: PrettyRawRepresentable>(_ r: T) {
        self.setAccessibilityIdentifier(r.prettyRawValue)
    }
}
#else
public extension UIAccessibilityIdentification {
    func accessibilityID<T: RawRepresentable>(_ r: T) where T.RawValue == String {
        self.accessibilityIdentifier = r.rawValue
    }
    func accessibilityID<T: PrettyRawRepresentable>(_ r: T) {
        self.accessibilityIdentifier = r.prettyRawValue
    }
}
#endif
