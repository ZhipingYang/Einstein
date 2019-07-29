//
//  XCUIElementQuery+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/4.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Then

extension XCUIElementQuery {
    
    func matching(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElementQuery {
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        return matching(NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }

    func element(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        return element(matching: NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }
    
    func element(predicate: EasyPredicate) -> XCUIElement {
        return element(predicates: [predicate], logic: .and)
    }
}
