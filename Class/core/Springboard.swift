//
//  Springboard.swift
//  DemoUITests
//
//  Created by Jesse Xie on 4/25/18.
//  Copyright © 2018 RingCentral. All rights reserved.
//

import XCTest

class Springboard {
    static let springboard = XCUIApplication(bundleIdentifier: "com.apple.springboard")

    class func deleteMyApp() {
        sleep(1)
        XCUIApplication().terminate()
        deleteMyAppIfNeed()
    }

    class func deleteMyAppIfNeed() {
        sleep(1)
        springboard.activate()
        sleep(1)
        let icons = springboard.icons.matching(identifier: "RCV Rooms")
        for index in 0..<icons.count {
            let icon = icons.firstMatch
            if index == 0 { icon.waitUntilExistsAssert().press(forDuration: 4) }
            icon.buttons["DeleteButton"].tapIfExists(timeout: 1)
            springboard.alerts.buttons["Delete"].tapIfExists(timeout: 1)
        }
        sleep(2)
    }

    class func hideAlertsIfNeeded() {
        let systemAlerts = springboard.alerts
        if systemAlerts.count > 0 {
            if systemAlerts.buttons["Allow"].exists {
                systemAlerts.buttons["Allow"].tap()
                sleep(1)
                hideAlertsIfNeeded()
                sleep(1)
            } else if systemAlerts.buttons["OK"].exists {
                systemAlerts.buttons["OK"].tap()
                sleep(1)
                hideAlertsIfNeeded()
                sleep(1)
            }
        }
    }
}