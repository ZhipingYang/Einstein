//
//  XCUIElementQuery+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/4.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Then

public extension XCUIElementQuery {
    
    /// safe to get index
    ///
    /// - Parameter index: index
    /// - Returns: optional element
    func element(safeIndex index: Int) -> XCUIElement? {
        if index >= count { return nil }
        return element(boundBy: index)
    }
    
    /// asset empty of query
    ///
    /// - Parameter empty: bool value
    /// - Returns: optional query self
    func assertEmpty(empty: Bool = false) -> XCUIElementQuery? {
        if empty && self.count > 0 {
            assertionFailure("XCUIElementQuery is not empty")
        } else if empty == false && self.count <= 0 {
            assertionFailure("XCUIElementQuery is empty")
        } else {
            return self
        }
        return nil
    }
}


public extension XCUIElementQuery {
    
    /// get the results which matching the EasyPredicates
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate's rules
    ///   - logic: rules relate
    /// - Returns: ElementQuery
    func matching(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return matching(predicates.toPredicate(logic))
    }
    func matching(predicate: EasyPredicate) -> XCUIElementQuery {
        return matching(predicate.toPredicate)
    }
    
    /// get the taget element which matching the EasyPredicates
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate's rules
    ///   - logic: rule's relate
    /// - Returns: result target
    func element(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        return element(matching: predicates.toPredicate(logic))
    }
    func element(predicate: EasyPredicate) -> XCUIElement {
        return element(matching: predicate.toPredicate)
    }

    /// get the results in the query's descendants which matching the EasyPredicates
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate's rules
    ///   - logic: rule's relate
    /// - Returns: result target
    func descendants(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return descendants(matching: .any).matching(predicates: predicates, logic: logic)
    }
    func descendants(predicate: EasyPredicate) -> XCUIElementQuery {
        return descendants(matching: .any).matching(predicate: predicate)
    }

    /// filter the query by rules to create new query
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate's rules
    ///   - logic: rule's relate
    /// - Returns: result target
    func containing(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return containing(predicates.toPredicate(logic))
    }
    func containing(predicate: EasyPredicate) -> XCUIElementQuery {
        return containing(predicate.toPredicate)
    }
}

