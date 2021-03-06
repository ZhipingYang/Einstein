//
//  Springboard.swift
//  GlipUITests
//
//  Created by Jesse Xie on 4/25/18.
//  Copyright © 2018 RingCentral. All rights reserved.
//

import XCTest

#if os(iOS)

/// get the home screen of device
public class Springboard {
    
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")
    
    /// delete Apps which matched the name until all be deleted
    ///
    /// - Parameter appName: will be deleted app name
    public class func deleteAppIfNeed(_ appName: String) {
        sleep(1)
        springboard.activate()
        
        sleep(1)
        let icons = springboard.icons.matching(predicate: .label(.equals, appName))
        
        for index in 0..<icons.count {
            let icon = icons.firstMatch
            if index == 0 { icon.waitUntilExistsAssert().press(forDuration: 4) }
            icon.buttons["DeleteButton"].tapIfExists(timeout: 1)
            springboard.alerts.buttons["Delete"].tapIfExists(timeout: 1)
        }
        sleep(2)
    }
}

#endif
