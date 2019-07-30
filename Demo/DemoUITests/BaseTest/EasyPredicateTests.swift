//
//  EasyPredicateTests.swift
//  DemoTests
//
//  Created by Daniel Yang on 2019/7/30.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import UITestHelper

/// mock XCUIElement to test EasyPredicate
@objcMembers class EasyPredicateTestItem: NSObject {
    var exists: Bool = true
    var isEnabled: Bool = true
    var isHittable: Bool = true
    var isSelected: Bool = true
    var label: NSString = ""
    var identifier: NSString = ""
    var elementType: XCUIElement.ElementType = .button
}

class EasyPredicateTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }
    
    func testExample() {
        // compare two items diff
        let item0 = EasyPredicateTestItem()
        let item1 = EasyPredicateTestItem().then {
            $0.exists = false
            $0.isEnabled = false
            $0.isHittable = false
            $0.isSelected = false
            $0.label = "abcdefg"
            $0.identifier = "identifier"
            $0.elementType = .window
        }
        
        // test case array
        let testPredicates = [
            EasyPredicate.exists(false),
            EasyPredicate.isEnabled(false),
            EasyPredicate.isHittable(false),
            EasyPredicate.isSelected(false),
            EasyPredicate.label(comparison: .equals, value: "abcdefg"),
            EasyPredicate.label(comparison: .notEqual, value: ""),
            EasyPredicate.label(comparison: .beginsWith, value: "ab"),
            EasyPredicate.label(comparison: .endsWith, value: "fg"),
            EasyPredicate.label(comparison: .contains, value: "cde"),
            EasyPredicate.label(comparison: .other("!="), value: ""),
            EasyPredicate.identifier("identifier"),
            EasyPredicate.type(.window)
        ]
        
        // NSPredicate's API supports NSArray but not Array in swift
        let array = [item0, item1] as NSArray
        
        testPredicates.forEach { predicate in
            group(text: "🙏: EasyPredicate -> \(predicate.rawValue.regularString)", closure: { _ in
                array.testPredicateFilter(predicate: predicate, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "abcdefg")
                })
                array.testPredicateGroupFilter(predicates: [predicate], logic: .and, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "abcdefg")
                })
                array.testPredicateGroupFilter(predicates: [predicate], logic: .not, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "")
                })
            })
        }
        
        group(text: "🙏: TestEasyPredicateGroup", closure: { _ in
            array.testPredicateGroupFilter(predicates: [.exists(true), .exists(false)], logic: .and) { (ps, p) in
                assert(ps.isEmpty)
            }
            array.testPredicateGroupFilter(predicates: [.exists(true), .exists(false)], logic: .or) { (ps, p) in
                assert(ps.count == 2)
            }
        })
    }
}

extension NSArray {
    
    fileprivate func testPredicateFilter(predicate: EasyPredicate, block: ([EasyPredicateTestItem], EasyPredicate) -> Void) {
        guard let result = filtered(using: predicate.rawValue.toPredicate) as? [EasyPredicateTestItem] else {
            assert(false, "element type must be EasyPredicateTestItem")
        }
        block(result, predicate)
    }
    
    fileprivate func testPredicateGroupFilter(predicates: [EasyPredicate],
                                              logic: NSCompoundPredicate.LogicalType,
                                              block: ([EasyPredicateTestItem], [EasyPredicate]) -> Void) {
        let predicate = NSCompoundPredicate(type: logic, subpredicates: predicates.map { $0.rawValue.toPredicate })
        guard let result = filtered(using: predicate) as? [EasyPredicateTestItem] else {
            assert(false, "element type must be EasyPredicateTestItem")
        }
        block(result, predicates)
    }
}



