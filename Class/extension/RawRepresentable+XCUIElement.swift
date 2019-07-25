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
        return queryFor(identifier: rawValue)
    }
    
    subscript(i: Int) -> XCUIElement {
        if i < 0 || i >= query.count {
            fatalError("Index \(i) falls out of range [0..\(query.count - 1)")
        }
        return query.allElementsBoundByIndex[i]
    }
}

public func queryFor(identifier: String) -> XCUIElementQuery {
    return XCUIApplication().descendants(matching: .any).matching(identifier: identifier)
}
