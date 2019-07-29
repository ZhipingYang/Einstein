//
//  DemoTests.swift
//  DemoTests
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import UITestHelper

struct AccessibilityTestID {}
extension AccessibilityTestID {
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

class DemoTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {

        XCTContext.runActivity(named: "AccessibilityIdentifierTests_Eunm") { _ in
            let path1 = AccessibilityTestID.Home1.setting.rawValue
            assert(path1 == "HomeSetting1")
            
            let path2_1 = AccessibilityTestID.Home2.setting.rawValue
            assert(path2_1 == "setting")
            
            let path2_2 = AccessibilityTestID.Home2.setting.prettyRawValue
            assert(path2_2 == "AccessibilityTestID_Home2_setting")
            
            let path3 = AccessibilityTestID.Home3.setting.prettyRawValue
            assert(path3 == "HomeSetting3")
        }
        
        XCTContext.runActivity(named: "AccessibilityIdentifierTests_View") { _ in
            let view1 = UIView()
            view1 >>> AccessibilityTestID.Home2.setting
            assert(view1.accessibilityIdentifier == "AccessibilityTestID_Home2_setting")
            
            let view2 = UIView()
            view2.accessibilityID(AccessibilityTestID.Home2.setting)
            assert(view2.accessibilityIdentifier == "AccessibilityTestID_Home2_setting")
        }
    }
}



