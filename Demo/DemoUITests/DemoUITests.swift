//
//  DemoUITests.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Einstein

class DemoUITests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        group(text: "Delete app before app launch") { _ in
            Springboard.deleteAppIfNeed("Demo")
        }
        app.launch()
    }
    
    override func tearDown() {
        group(text: "Delete App") { _ in
            XCUIApplication().terminate()
            Springboard.deleteAppIfNeed("Demo")
        }
        super.tearDown()
    }
    
    func testExample() {
        
        typealias InterfacePage = AccessibilityDemoID.Interface
        
        AccessibilityDemoID.TabItem.second.element.tap()
        AccessibilityDemoID.BarItem.Push.element.assert(predicate: .exists(false))
        
        AccessibilityDemoID.TabItem.first.element.tap()
        AccessibilityDemoID.BarItem.Push.element.assert(predicate: .exists(true))
        
        InterfacePage.button.element.tap()
        InterfacePage.buttonLabel.element.assert(predicate: .label(.equals, "clicked"))
        
        InterfacePage.segment.element.children(predicate:.label(.equals, "Second")).element.tap()
        InterfacePage.segmentLabel.element.assert(predicate: .label(.equals, "1"))
        
        InterfacePage.slider.element.assertBreak(predicate: .isHittable(true))?.press(forDuration: 0.3, thenDragTo: InterfacePage.sliderLabel.element)
        InterfacePage.sliderLabel.element.assert(predicate: .label(.equals, "0.0"))
        
        InterfacePage.switch.element.setSwitch(on: false)
        InterfacePage.switchLabel.element.assert(predicate: .label(.equals, "off"))
    }
}

