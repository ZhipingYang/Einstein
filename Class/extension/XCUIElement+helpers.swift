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
    func waitUntil(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {
        if predicates.count <= 0 { fatalError("predicates cannpt be empty!") }
        
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        let compoundPredicate = NSCompoundPredicate(type: logic, subpredicates: subpredicates)
        
        let test = XCTestCase().then { $0.continueAfterFailure = true }
        let promise = test.expectation(for: compoundPredicate, evaluatedWith: self, handler: handler)
        XCTWaiter().wait(for: [promise], timeout: timeout)
        return self
    }

    @discardableResult
    func waitUntil(predicate: EasyPredicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {
        // return self directly
        switch predicate {
        case .exists(let e) where e == exists:
            return self
        case .isEnabled(let i) where i == isEnabled:
            return self
        case .identifier(let id) where id == identifier:
            return self
        case .isHittable(let h) where h == isHittable:
            return self
        case .isSelected(let s) where s == isSelected:
            return self
        default: break
        }
        // waiting
        let test = XCTestCase().then { $0.continueAfterFailure = true }
        let promise = test.expectation(for: predicate.rawValue.toPredicate, evaluatedWith: self, handler: handler)
        XCTWaiter().wait(for: [promise], timeout: timeout)
        return self
    }
    
    func assert(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        return self
    }
    
    @discardableResult
    func waitUntilAssert(predicate: EasyPredicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> XCUIElement {
        return waitUntil(predicate: predicate, timeout: timeout, handler: handler).then {
            switch predicate {
            case .exists(let e):
                XCTAssert(exists == e, "Element should be \(e ? "exist" : "inexist"): \($0)")
            case .isEnabled(let e):
                XCTAssert(isEnabled == e, "Element should be \(e ? "enabled" : "disabled"): \($0)")
            case .isHittable(let h):
                XCTAssert(isHittable == h, "Element should be \(h ? "hittable" : "unhittable"): \($0)")
            case .isSelected(let s):
                XCTAssert(isSelected == s, "Element should be \(s ? "selected" : "unselected"): \($0)")
            case .label(let comparison, let value):
                switch comparison {
                case .equals:
                    XCTAssert(value == label, "label:\(label) is not equal with \(value)")
                case .beginsWith:
                    XCTAssert(label.hasPrefix(value), "label:\(label) is not prefix with \(value)")
                case .contains:
                    XCTAssert(label.contains(value), "label:\(label) is not contains with \(value)")
                case .endsWith:
                    XCTAssert(label.hasSuffix(value), "label:\(label) is not suffix with \(value)")
                default: break
                }
            case .identifier(let i):
                XCTAssert(identifier == i, "identifier:\(identifier) is not equal with \(i)")
            case .other(_): break
                // TODO: asset log
            case .type(_): break
                // TODO: asset log
            }
        }
    }

    @discardableResult
    func waitUntilExists(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: EasyPredicate.exists(true), timeout: timeout)
    }

    @discardableResult
    func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntilAssert(predicate: EasyPredicate.exists(true), timeout: timeout)
    }
    
    @discardableResult
    func waitUntilEnable(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: EasyPredicate.isEnabled(true), timeout: timeout)
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
        return waitUntil(predicate: EasyPredicate.isEnabled(true), timeout: timeout).then {
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
