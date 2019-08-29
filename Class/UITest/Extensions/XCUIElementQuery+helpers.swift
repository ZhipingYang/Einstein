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
    
    func childrenFilter(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return matching(predicates.toPredicate(logic))
    }
    
    func childrenFirst(predicate: EasyPredicate) -> XCUIElement {
        return element(matching: predicate.toPredicate)
    }
    
    func filter(predicate: EasyPredicate) -> XCUIElementQuery {
        return containing(predicate.toPredicate)
    }
    
    func first(predicate: EasyPredicate) -> XCUIElement {
        return filter(predicate: predicate).firstMatch
    }
}

