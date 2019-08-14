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
    
    func matching(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        return matching(predicates.toPredicate(logic))
    }
    
    func element(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        return element(matching: predicates.toPredicate(logic))
    }
    
    func element(predicate: EasyPredicate) -> XCUIElement {
        return element(predicates: [predicate], logic: .and)
    }
}

