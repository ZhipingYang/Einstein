//
//  AccessibilityID.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import UITestHelper

// demo for test
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

func ss() {
    let view = UIView()
    view >>> AccessibilityID.Home2.setting
    print(view.accessibilityIdentifier ?? "null")
}


