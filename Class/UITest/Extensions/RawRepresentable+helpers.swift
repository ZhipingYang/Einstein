//
//  RawRepresentable+XCUIElement.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest


/*
 MARK: - String extension
 Note: string value can be a RawRepresentable and String at the same time
 for example:
 `let element: XCUIElement = "SomeString".element`
 */
extension String: RawRepresentable {
    public var rawValue: String { return self }
    public init?(rawValue: String) {
        self = rawValue
    }
}

/*
 MARK: - RawRepresentable extension
 Get the `XCUIElement` from RawRepresentable's RawValue which also been used as accessibilityIdentifier
 */
public extension RawRepresentable where RawValue == String {
    
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
        return XCUIApplication().descendants(matching: .any).matching(identifier: identifier.rawValue)
    }
}


// MARK: - RawRepresentables extension
public extension Sequence where Element: RawRepresentable, Element.RawValue == String {
    
    /// get the elements which match with identifiers and predicates limited in timeout
    ///
    /// - Parameters:
    ///   - subpredicates: predicates as the match rules
    ///   - logic: relation of predicates
    ///   - timeout: if timeout == 0, return the elements immediately otherwise retry until timeout
    /// - Returns: get the elements
    func anyElements(subpredicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType, timeout: Int) -> [XCUIElement] {
        let elements = map { $0.query.element(predicates: subpredicates, logic: logic) }
        if elements.count > 0 || timeout <= 0 {
            return elements
        } else {
            sleep(1)
            return anyElements(subpredicates: subpredicates, logic: logic, timeout: timeout - 1)
        }
    }
    
    /// get the first element was matched predicate
    func anyElements(predicate: EasyPredicate) -> XCUIElement? {
        return anyElements(subpredicates: [predicate], logic: .and, timeout: 0).first
    }
}


