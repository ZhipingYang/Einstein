//
//  MacDemoTests.swift
//  MacDemoTests
//
//  Created by Daniel Yang on 2019/8/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Einstein

struct AccessibilityTestID {
    enum Home1: String { case setting = "HomeSetting1" }
    enum Home2: String, PrettyRawRepresentable { case setting }
    enum Home3: String, PrettyRawRepresentable { case setting = "HomeSetting3" }
}

class AccessibilityIdentifierTests: XCTestCase {
    
    func testEnumExample() {
        XCTContext.runActivity(named: "🙏: AccessibilityIdentifierTests -> Eunm") { _ in
            let path1 = AccessibilityTestID.Home1.setting.rawValue
            assert(path1 == "HomeSetting1")
            
            let path2_1 = AccessibilityTestID.Home2.setting.rawValue
            assert(path2_1 == "setting")
            
            let path2_2 = AccessibilityTestID.Home2.setting.prettyRawValue
            assert(path2_2 == "AccessibilityTestID_Home2_setting")
            
            let path3 = AccessibilityTestID.Home3.setting.prettyRawValue
            assert(path3 == "HomeSetting3")
        }
    }
    
    func testViewExample() {
        XCTContext.runActivity(named: "🙏: AccessibilityIdentifierTests -> View") { _ in
            let view1 = NSView()
            view1 <<< AccessibilityTestID.Home2.setting
            assert(view1.accessibilityIdentifier() == "AccessibilityTestID_Home2_setting")
            
            let view2 = NSView()
            view2.accessibilityID(AccessibilityTestID.Home2.setting)
            assert(view2.accessibilityIdentifier() == "AccessibilityTestID_Home2_setting")
            
            let view3 = NSView()
            view3 <<< AccessibilityTestID.Home3.setting
            assert(view3.accessibilityIdentifier() == "HomeSetting3")
            
            let view4 = NSView()
            view4.accessibilityID(AccessibilityTestID.Home3.setting)
            assert(view4.accessibilityIdentifier() == "HomeSetting3")
        }
    }
}
