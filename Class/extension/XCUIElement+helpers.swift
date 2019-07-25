//
//  XCUIElement+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Then

/**
 Helper extension for performing functions on an element
 */
public extension XCUIElement {
    
    @discardableResult
    func waitUntil(predicate: Predicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {
        // return self directly
        switch predicate {
        case .exists(let e) where e == exists:
            return self
        case .isEnabled(let i) where i == isEnabled:
            return self
        default: break
        }
        // waiting
        let test = XCTestCase().then { $0.continueAfterFailure = true }
        let promise = test.expectation(for: predicate.convert, evaluatedWith: self, handler: handler)
        XCTWaiter().wait(for: [promise], timeout: timeout)
        return self
    }
    
    @discardableResult
    func waitUntilAssert(predicate: Predicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {
        return waitUntil(predicate: predicate, timeout: timeout, handler: handler).then {
            switch predicate {
            case .exists(let exists):
                XCTAssert(self.exists == exists, "Element should \(exists ? "exist" : "inexist"): \($0)")
            case .isEnabled(let isEnabled):
                XCTAssert(self.isEnabled == isEnabled, "Element should \(isEnabled ? "enabled" : "disabled"): \($0)")
            }
        }
    }

    @discardableResult
    func waitUntilExists(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: Predicate.exists(true), timeout: timeout)
    }

    @discardableResult
    func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntilAssert(predicate: Predicate.exists(true), timeout: timeout)
    }
    
    @discardableResult
    func waitUntilEnable(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: Predicate.isEnabled(true), timeout: timeout)
    }
    
    /// Wait until it's available and then type a text into it.
    @discardableResult
    func tapAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout: timeout).tap()
        sleep(1) //Wait for keyboard... test?
        typeText(text)
        return self
    }
    
    /// Wait until it's available and clear the text, then type a text into it.
    @discardableResult
    func clearAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout: timeout)
        sleep(1) //Wait for keyboard...
        coordinate(withNormalizedOffset: CGVector(dx: 0.99, dy: 0.99)).tap()
        
        let stringValue = (value as? String) ?? ""
        let deleteString = stringValue.map { _ in XCUIKeyboardKey.delete.rawValue }.joined()
        typeText(deleteString)
        typeText(text)
        
        return self
    }
    
    @discardableResult
    func hidenKeyboard(inApp: XCUIApplication) -> XCUIElement {
        inApp.keyboards.buttons["Hide keyboard"].tapIfExists()
        sleep(1)
        return self
    }
    
    @discardableResult
    func wait(_ s: UInt32 = 1) -> XCUIElement {
        sleep(s)
        return self
    }

    @discardableResult
    func setSwitch(on: Bool, timeout: TimeInterval = 10) -> XCUIElement  {
        waitUntilExists(timeout: timeout)
        if elementType == .`switch` {
            if (!on && "\(value ?? "0")" == "1") || (on && "\(value ?? "0")" != "1") {
                tap()
            }            
        } else {
            XCTAssert(false, "Element is not a switch: \(self)")
        }
        return self
    }
    
    @discardableResult
    func forceTap(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: Predicate.isEnabled(true), timeout: timeout).then {
            let vector = CGVector(dx: 0.5, dy: 0.5)
            $0.isHittable ? tap() : coordinate(withNormalizedOffset: vector).tap()
        }
    }
    
    @discardableResult
    func tapIfExists(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntilExists(timeout: timeout).then {
            if $0.exists { $0.tap() }
        }
    }
}

public extension Collection where Iterator.Element: XCUIElement {
    
    func waitUntil(predicate: Predicate, timeout: TimeInterval = 10) -> XCUIElement? {
        
        for _ in 1...Int(timeout) {
            let valid = self.first {
                switch predicate {
                case .exists(let e) where e == $0.exists:       return true
                case .isEnabled(let i) where i == $0.isEnabled: return true
                default: return false
                }
            }
            if let valid = valid { return valid }
            
            // NSCompoundPredicate
            let test = XCTestCase().then { $0.continueAfterFailure = true }
            let promise = test.expectation(for: predicate.convert, evaluatedWith: first, handler: nil)
            XCTWaiter().wait(for: [promise], timeout: 1)
        }
        return nil
    }
}
