//
//  RawRepresentable+XCUIElement.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/6/26.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest

/*
 MARK: - RawRepresentable
 Retrieving an `XCUIElement` from RawRepresentable value which also been used as accessibility identifier.
*/
public extension RawRepresentable where Self.RawValue == String {
    
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


// MARK: - RawRepresentable, Element.RawValue == String
public extension Sequence where Element: RawRepresentable, Element.RawValue == String {
    
    /// get all elements match the predicates
    ///
    /// - Parameters:
    ///   - subpredicates: predicates as the match rules
    ///   - logic: relation of predicates
    /// - Returns: get the elements
    func elements(subpredicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> [XCUIElement] {
        let elements = self.map { rawRepresentable -> XCUIElement in
            let query = XCUIApplication().descendants(matching: .any).matching(identifier: rawRepresentable.rawValue)
            return query.element(withIdentifier: rawRepresentable, predicates: subpredicates, logic: logic)
        }
        return elements
    }

    /// get the first element was matched predicate
    func firstEmenet(predicate: EasyPredicate) -> XCUIElement? {
        return elements(subpredicates: [predicate]).first
    }
}


// MARK: - String as RawRepresentable self
extension String: RawRepresentable {
    public var rawValue: String { return self }
    public init?(rawValue: String) {
        self = rawValue
    }
}
