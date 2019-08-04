//
//  DemoUITests.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest

class DemoUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        //        continueAfterFailure = true
        //        group(text: "Delete app before app launch") { _ in
        //            self.deleteMyAppIfNeed()
        //        }
        app.launch()
    }
    
    override func tearDown() {
        //        group(text: "Delete App") { _ in
        //            XCUIApplication().terminate()
        //            self.deleteMyAppIfNeed()
        //        }
        super.tearDown()
    }
    
    func testExample() {
        
        AccessibilityDemoID.TabItem.second.element.assertBreak(predicate: .isHittable(true))?.tap()
        AccessibilityDemoID.TabItem.first.element.assertBreak(predicate: .isHittable(true))?.tap()
        
        AccessibilityDemoID.Interface.button.element.assertBreak(predicate: .isHittable(true))?.tap()
        AccessibilityDemoID.Interface.segment.element.assertBreak(predicate: .isHittable(true))?.tap()
        AccessibilityDemoID.Interface.slider.element.assertBreak(predicate: .isHittable(true))?.tap()
        AccessibilityDemoID.Interface.switch.element.assertBreak(predicate: .isHittable(true))?.setSwitch(on: false)
        AccessibilityDemoID.Interface.switch.element.assertBreak(predicate: .isHittable(true))?.setSwitch(on: true)
        AccessibilityDemoID.Interface.stepper.element.assertBreak(predicate: .isHittable(true))?.tap()
        
        AccessibilityDemoID.Show.progress.element.tap()
        AccessibilityDemoID.Show.activity.element.tap()
        AccessibilityDemoID.Show.pageControl.element.tap()
        AccessibilityDemoID.Show.imageView.element.tap()
    }
}

