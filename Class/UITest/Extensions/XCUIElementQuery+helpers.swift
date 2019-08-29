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
    
    /// get ElementQuery of all child elements and child's child elements and so on
    ///
    /// - Parameters:
    ///   - predicates: EasyPredicate' rules
    ///   - logic: rules relate
    /// - Returns: ElementQuery
    func childrenFilter(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return matching(predicates.toPredicate(logic))
    }
    
    /// get target element of all child elements and child's child elements and so on
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: result target
    func childrenFirst(predicate: EasyPredicate) -> XCUIElement {
        return element(matching: predicate.toPredicate)
    }
    
    /// filter the query by rules to create new query
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: ElementQuery
    func filter(predicate: EasyPredicate) -> XCUIElementQuery {
        return containing(predicate.toPredicate)
    }
    
    /// filter the target element by rules to create new query
    ///
    /// - Parameter predicate: EasyPredicate' rules
    /// - Returns: the target XCUIElement
    func first(predicate: EasyPredicate) -> XCUIElement {
        return filter(predicate: predicate).firstMatch
    }
}

