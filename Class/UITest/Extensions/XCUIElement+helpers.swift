//
//  XCUIElement+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Then


// MARK: - Base
public extension XCUIElement {
    
    // MARK: - wait
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
        return waitUntil(predicates: [predicate], logic: .and, timeout: timeout, handler: handler)
    }
    
    @discardableResult
    func waitUntilExists(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: EasyPredicate.exists(true), timeout: timeout)
    }
    
    @discardableResult
    func wait(_ s: UInt32 = 1) -> XCUIElement {
        sleep(s)
        return self
    }
    
    // MARK: - assert
    func assert(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        if predicates.first == nil { fatalError("predicates can't be empty") }
        
        let predicate = NSCompoundPredicate(type: logic, subpredicates: predicates.map {
            $0.rawValue.toPredicate
        })
        let filteredElements = ([self] as NSArray).filtered(using: predicate)
        if filteredElements.isEmpty {
            let predicateStr = predicates.map { "\n <\($0.rawValue.regularString)>" }.joined()
            assertionFailure("\(self) is not satisfied: \(predicateStr)")
        }
        return self
    }
    
    func assert(predicate: EasyPredicate) -> XCUIElement {
        return assert(predicates: [predicate])
    }
    
    @discardableResult
    func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: EasyPredicate.exists(true), timeout: timeout).assert(predicate: .exists(true))
    }
}

// MARK: - Extension
public extension XCUIElement {
    
    /// Wait until it's available and then type a text into it.
    @discardableResult
    func tapAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout: timeout).tap()
        sleep(1) // Wait for keyboard... test?
        typeText(text)
        return self
    }
    
    /// Wait until it's available and clear the text, then type a text into it.
    @discardableResult
    func clearAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout: timeout)
        sleep(1) // Wait for keyboard...
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

extension Sequence where Element: XCUIElement {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - subpredicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func anyElements(subpredicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [Element] {
        if subpredicates.count <= 0 { fatalError("predicates cannpt be empty!") }
        
        let predicate = NSCompoundPredicate(type: logic, subpredicates: subpredicates.map {
            $0.rawValue.toPredicate
        })
        let filteredElements = (map { $0 } as NSArray).filtered(using: predicate)
        if filteredElements.count > 0 || timeout <= 0 {
            return filteredElements as! [Element]
        } else {
            sleep(1)
            return anyElements(subpredicates: subpredicates, logic: logic, timeout: timeout - 1)
        }
    }
    
    /// get the first element was matched predicate
    func anyElements(predicate: EasyPredicate) -> Element? {
        return anyElements(subpredicates: [predicate], logic: .and, timeout: 0).first
    }
}

