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
 Use generic protocols to better extend functionality in both engineering and testing projects
 
 ```
 // for project
 extension XCUIElement: PredicateBaseExtensionProtocol {
    public typealias T = XCUIElement
 }
 
 // for test
 extension EasyPredicateTestItem: PredicateBaseExtensionProtocol {
    typealias T = EasyPredicateTestItem
 }
 ```
 */
public protocol PredicateBaseExtensionProtocol {
    
    associatedtype T
    
    /// create a new preicate with EasyPredicates and LogicalType to judge is it satisfied on self
    ///
    /// - Parameters:
    ///   - predicates: predicates rules
    ///   - logic: rules relative
    ///   - timeout: time limit
    ///   - handler: expectation handler
    /// - Returns: a tuple of waiting result and element
    func waitUntil(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: TimeInterval, handler: XCTNSPredicateExpectation.Handler?) -> (result: XCTWaiter.Result, element: T)
    
    /// assert by new preicate with EasyPredicates and LogicalType, if assert is passed then return self or return nil
    ///
    /// - Parameters:
    ///   - predicates: predicates rules
    ///   - logic: rules relative
    /// - Returns: self or nil
    func assertBreak(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType) -> T?
}

public extension PredicateBaseExtensionProtocol where Self == T {
    
    @discardableResult
    func waitUntil(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> (result: XCTWaiter.Result, element: T) {
        if predicates.count <= 0 { fatalError("predicates cannpt be empty!") }
        
        let test = XCTestCase().then { $0.continueAfterFailure = true }
        let promise = test.expectation(for: predicates.toPredicate(logic), evaluatedWith: self, handler: handler)
        let result = XCTWaiter().wait(for: [promise], timeout: timeout)
        return (result, self)
    }
    
    @discardableResult
    func assertBreak(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> T? {
        if predicates.first == nil { fatalError("❌ predicates can't be empty") }
        
        let filteredElements = ([self] as NSArray).filtered(using: predicates.toPredicate(logic))
        if filteredElements.isEmpty {
            let predicateStr = predicates.map { "\n <\($0.regularString)>" }.joined()
            assertionFailure("❌ \(self) is not satisfied logic:\(logic) about rules: \(predicateStr)")
        }
        return filteredElements.isEmpty ? nil : self
    }
}

extension XCUIElement: PredicateBaseExtensionProtocol { public typealias T = XCUIElement }

public extension XCUIElement {
    
    // MARK: - Wait
    @discardableResult
    func waitUntil(predicate: EasyPredicate, timeout: TimeInterval = 10, handler: XCTNSPredicateExpectation.Handler? = nil) -> (result: XCTWaiter.Result, element: XCUIElement) {
        return waitUntil(predicates: [predicate], logic: .and, timeout: timeout, handler: handler)
    }
    
    @discardableResult
    func waitUntilExists(timeout: TimeInterval = 10) -> (result: XCTWaiter.Result, element: XCUIElement) {
        return waitUntil(predicate: .exists(true), timeout: timeout)
    }
    
    @discardableResult
    func waitUntilExistsAssert(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: .exists(true), timeout: timeout).element.assert(predicate: .exists(true))
    }
    
    @discardableResult
    func wait(_ s: UInt32 = 1) -> XCUIElement {
        sleep(s)
        return self
    }
    
    // MARK: - Assert
    @discardableResult
    func assertBreak(predicate: EasyPredicate) -> XCUIElement? {
        return assertBreak(predicates: [predicate])
    }
    
    @discardableResult
    func assert(predicate: EasyPredicate) -> XCUIElement {
        return assertBreak(predicates: [predicate]) ?? self
    }
    
    @discardableResult
    func assert(predicate: EasyPredicate, timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: predicate, timeout: timeout).element.assert(predicate: predicate)
    }
}

// MARK: - Custom Extension
public extension XCUIElement {
    
    // MARK: - Traversing
    
    /// get the results in the descendants which matching the EasyPredicates
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate's rules
    ///   - logic: rule's relate
    /// - Returns: result target
    @discardableResult
    func descendants(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return descendants(matching: .any).matching(predicates: predicates, logic: logic)
    }
    @discardableResult
    func descendants(predicate: EasyPredicate) -> XCUIElementQuery {
        return descendants(matching: .any).matching(predicate.toPredicate)
    }
    
    /// Returns a query for direct children of the element matching with EasyPredicates
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate rules
    ///   - logic: rules relate
    /// - Returns: result query
    @discardableResult
    func children(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return children(matching: .any).matching(predicates: predicates, logic: logic)
    }
    @discardableResult
    func children(predicate: EasyPredicate) -> XCUIElementQuery {
        return children(matching: .any).matching(predicate: predicate)
    }

    // MARK: - Functions

    /// Wait until it's available and then type a text into it.
    @discardableResult
    func tapAndType(text: String, timeout: TimeInterval = 10) -> XCUIElement {
        waitUntilExists(timeout: timeout).element.tap()
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
        sleep(1)
        return self
    }
    
    /// hiden Keyboard, especial when you finished typ text to go next step
    ///
    /// - Returns: self
    @discardableResult
    func hidenKeyboard(inApp: XCUIApplication? = nil) -> XCUIElement {
        (inApp ?? XCUIApplication()).keyboards.buttons["Hide keyboard"].tapIfExists(timeout: 0)
        sleep(1)
        return self
    }
    
    /// set switch on or off
    /// if is not `switch` element, then assert fail
    ///
    /// - Parameters:
    ///   - on: on or off
    ///   - timeout: wait Until Exists
    /// - Returns: self
    @discardableResult
    func setSwitch(on: Bool, timeout: TimeInterval = 10) -> XCUIElement  {
        waitUntilExists(timeout: timeout)
        if elementType == .`switch` {
            if (!on && "\(value ?? "0")" == "1") || (on && "\(value ?? "0")" != "1") {
                tap()
            }
        } else {
            assertionFailure("❌ Element is not a switch: \(self)")
        }
        return self
    }
    
    /// some elemnt is exists but can not tap
    ///
    /// - Parameter timeout: wait Until enable
    /// - Returns: self
    @discardableResult
    func forceTap(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntil(predicate: .isEnabled(true), timeout: timeout).element.then {
            let vector = CGVector(dx: 0.5, dy: 0.5)
            $0.isHittable ? tap() : coordinate(withNormalizedOffset: vector).tap()
        }
    }
    
    /// tap If Exists
    ///
    /// - Parameter timeout: wait Until enable
    /// - Returns: self
    @discardableResult
    func tapIfExists(timeout: TimeInterval = 10) -> XCUIElement {
        return waitUntilExists(timeout: timeout).element.then {
            if $0.exists { $0.tap() }
        }
    }
}

public extension Sequence where Element: XCUIElement {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - predicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func elements(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [Element] {
        if predicates.count <= 0 { fatalError("predicates cannpt be empty!") }
        
        let array = map { $0 } as NSArray
        let filteredElements = array.filtered(using: predicates.toPredicate(logic))
        if filteredElements.count > 0 || timeout <= 0 {
            return filteredElements as! [Element]
        } else {
            sleep(1)
            return self.elements(predicates: predicates, logic: logic, timeout: timeout - 1)
        }
    }
    
    /// get the first element was matched predicate
    func anyElement(predicate: EasyPredicate) -> Element? {
        return elements(predicates: [predicate], logic: .and, timeout: 0).first
    }
}
