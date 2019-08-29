//
//  XCTestCase+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import ObjectiveC

/**
 associated object
 */
public extension XCTestCase {
    
    private struct XCTestCaseAssociatedKey {
        static var app = 0
    }
    
    /// stored an associated app in XCTestCase‘s instance
    var app: XCUIApplication {
        set {
            objc_setAssociatedObject(self, &XCTestCaseAssociatedKey.app, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        get {
            let _app = objc_getAssociatedObject(self, &XCTestCaseAssociatedKey.app) as? XCUIApplication
            guard let app = _app else { return XCUIApplication().then { self.app = $0 } }
            return app
        }
    }
}

/**
 Helper extension for various function to help with writing UI tests.
 */
public extension XCTestCase {
    
    /// Try to force launch the application. This structure tries to ovecome the issues described at https://forums.developer.apple.com/thread/15780
    ///
    /// - Parameters:
    ///   - arguments: An array of RawRepresentable iterms that will be passed on as arguments
    ///   - counter: The retry counter for trying to startup the app (Default is 10)
    ///   - wait: The number of seconds to wait. Slower test machines might require a longer wait
    func tryLaunch<T: RawRepresentable>(arguments: [T], count counter: Int = 10, wait: UInt32 = 2) where T.RawValue == String {
        sleep(wait)
        XCUIApplication().terminate()
        sleep(wait)
        
        app = XCUIApplication().then {
            $0.launchArguments = arguments.map { para in para.rawValue }
            $0.launch()
        }
        sleep(wait)
        
        if !app.exists && counter > 0 {
            tryLaunch(arguments: arguments, count: counter - 1)
        }
    }
    
    func tryLaunch(count counter: Int = 10) {
        sleep(3)
        XCUIApplication().terminate()
        sleep(3)
        
        app = XCUIApplication().then { $0.launch() }
        sleep(3)
        
        if !app.exists && counter > 0 {
            tryLaunch(count: counter - 1)
        }
    }
    
    /// kill App And Relaunch
    func killAppAndRelaunch() {
        group(text: "Kill App and Relaunch") { _ in
            sleep(2)
            app.terminate()
            app.launch()
            sleep(2)
        }
    }
    
    /// Try to force closing the application
    ///
    /// - Parameter wait: The number of seconds to wait. Slower test machines might require a longer wait
    func tryTearDown(wait: UInt32 = 2) {
        super.tearDown()
        sleep(wait)
        XCUIApplication().terminate()
        sleep(wait)
    }
}

public extension XCTestCase {
    
    func isSimulator() -> Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    /// take a Screenshot
    ///
    /// - Parameters:
    ///   - activity: XCTContext.runActivity
    ///   - name: the name of attachment
    func takeScreenshot(activity: XCTActivity, name: String = "Screenshot") {
        activity.add(XCTAttachment(screenshot: XCUIScreen.main.screenshot()).then {
            $0.name = name
            $0.lifetime = .keepAlways
        })
    }
    
    /// defalut a Screenshot
    ///
    /// - Parameters:
    ///   - groupName: groupName description
    ///   - name: attachment name
    func takeScreenshot(groupName: String = "--- Screenshot ---", name: String = "Screenshot") {
        group(text: groupName) { takeScreenshot(activity: $0, name: name) }
    }
    
    /// swifty UITest syntactic sugar
    ///
    /// - Parameters:
    ///   - text: group text description
    ///   - closure: group content code
    func group(text: String = "Group", closure: (_ activity: XCTActivity) -> ()) {
        XCTContext.runActivity(named: text) { closure($0) }
    }
    
    /// hide the system's and app's alerts
    func hideAlertsIfNeeded() {
        let systemAlerts = XCUIApplication(bundleIdentifier: "com.apple.springboard").alerts
        let alerts = systemAlerts.count<=0 ? app.alerts : systemAlerts
        let alert = alerts.firstMatch
        
        if alert.buttons.count == 1 {
            alerts.buttons.firstMatch.tapIfExists(timeout: 1)
        } else if alert.buttons.count > 1 {
            sleep(1)
            let allow = alert.buttons["Allow"]
            let ok = alert.buttons["OK"]
            if allow.exists {
                allow.tap()
            } else if ok.exists {
                ok.tap()
            } else {
                alert.buttons.element(boundBy: alert.buttons.count-1).tap()
            }
        }
        if alerts.count > 1 {
            hideAlertsIfNeeded()
        }
    }
    
    #if os(iOS)
    /// only apply real iOS machine
    ///
    /// - Parameter value: trigger airplane
    func setAirplane(_ value: Bool) {
        if isSimulator() { fatalError("There are no airplane mode in simulator") }
        
        let settingsApp = XCUIApplication(bundleIdentifier: "com.apple.Preferences")
        settingsApp.launch()
        settingsApp.tables.cells["Airplane Mode"].children(matching: .switch).firstMatch.setSwitch(on: true)
        app.activate()
    }
    #endif
}

