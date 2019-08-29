//
//  RawRepresentable+XCUIElement.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest


/*
 MARK: - PrettyRawRepresentable extension
 Get the `XCUIElement` from PrettyRawRepresentable's prettyRawValue which also been used as accessibilityIdentifier
 */
public extension PrettyRawRepresentable {
    
    var element: XCUIElement {
        // store query to aviod getter be called again
        let qry = query
        if qry.count > 1 {
            fatalError("There are \(qry.count) elements with identifier \(rawValue) found!")
        }
        return qry.firstMatch
    }
    
    var query: XCUIElementQuery {
        return queryFor(identifier: self)
    }
    
    var count: Int {
        return query.count
    }
    
    subscript(i: Int) -> XCUIElement {
        if i < 0 || i >= query.count {
            fatalError("Index \(i) falls out of range [0..\(query.count - 1)")
        }
        return query.allElementsBoundByIndex[i]
    }
    
    func queryFor(identifier: Self) -> XCUIElementQuery {
        return XCUIApplication().descendants(matching: .any).matching(identifier: identifier.prettyRawValue)
    }
}

// MARK: - PrettyRawRepresentable extension
public extension Sequence where Element: PrettyRawRepresentable {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - predicates: as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func elements(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [XCUIElement] {
        let elements = map { $0.query.first(predicate: predicates.merged(withLogic: logic)) }
        if elements.count > 0 || timeout <= 0 {
            return elements
        } else {
            sleep(1)
            return self.elements(predicates: predicates, logic: logic, timeout: timeout-1)
        }
    }
    
    /// get the first element was matched predicate
    func anyElement(predicate: EasyPredicate) -> XCUIElement? {
        return elements(predicates: [predicate], logic: .and, timeout: 0).first
    }
}
