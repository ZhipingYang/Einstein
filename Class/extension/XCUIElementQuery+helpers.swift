//
//  XCUIElementQuery+helpers.swift
//  DemoUITests
//
//  Created by Daniel Yang on 2019/7/4.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest

extension XCUIElementQuery {
    func element<T: RawRepresentable>(withIdentifier identifier: T, predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement where T.RawValue == String {
        let idPredicate = NSPredicate(format: "identifier == \(identifier.rawValue)")
        var subpredicates = predicates.map { $0.rawValue.toPredicate }
        subpredicates.append(idPredicate)
        return element(matching: NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }
    
    func element(predicates: [EasyPredicate], logic: NSCompoundPredicate.LogicalType = .and) -> XCUIElement {
        let subpredicates = predicates.map { $0.rawValue.toPredicate }
        return element(matching: NSCompoundPredicate(type: logic, subpredicates: subpredicates))
    }
}
