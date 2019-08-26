//
//  EasyPredicateTests.swift
//  DemoTests
//
//  Created by Daniel Yang on 2019/7/30.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Einstein

/// mock XCUIElement to test EasyPredicate, key1: @objcMembers, key2: NSObject
@objcMembers private class EasyPredicateTestItem: NSObject {
    var exists: Bool = true
    var isEnabled: Bool = true
    var isHittable: Bool = true
    var isSelected: Bool = true
    var label: NSString = ""
    var identifier: NSString = ""
    var elementType: XCUIElement.ElementType = .button
}

extension EasyPredicateTestItem: PredicateBaseExtensionProtocol { typealias T = EasyPredicateTestItem }

class EasyPredicateTests: XCTestCase {
    
    // test case array
    private let testPredicates: [EasyPredicate] = [
        .exists(false),
        .isEnabled(false),
        .isHittable(false),
        .isSelected(false),
        .label(.equals, "DanielYang"),
        .label(.notEqual, ""),
        .label(.beginsWith, "Daniel"),
        .label(.endsWith, "Yang"),
        .label(.contains, "lY"),
        .label(.other("!="), ""),
        .identifier("xcodeyang"),
        .type(.window)
    ]
    
    private let item0 = EasyPredicateTestItem()
    private let item1 = EasyPredicateTestItem().then {
        $0.exists = false
        $0.isEnabled = false
        $0.isHittable = false
        $0.isSelected = false
        $0.label = "DanielYang"
        $0.identifier = "xcodeyang"
        $0.elementType = .window
    }
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = true
    }
    
    func testEasyPredicate() {
        
        // NSPredicate's API supports NSArray but not Array in swift
        let array = [item0, item1] as NSArray
        
        testPredicates.forEach { predicate in
            group(text: "🙏: EasyPredicate -> \(predicate.rawValue.regularString)", closure: { _ in
                array.testPredicateFilter(predicate: predicate, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "DanielYang")
                })
                array.testPredicateGroupFilter(predicates: [predicate], logic: .and, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "DanielYang")
                })
                array.testPredicateGroupFilter(predicates: [predicate], logic: .not, block: { (ps, p) in
                    assert(ps.count == 1)
                    assert(ps.first?.label == "")
                })
            })
        }
        group(text: "🙏: EasyPredicateGroup", closure: { _ in
            array.testPredicateGroupFilter(predicates: [.exists(true), .exists(false)], logic: .and) { (ps, p) in
                assert(ps.isEmpty)
            }
            array.testPredicateGroupFilter(predicates: [.exists(true), .exists(false)], logic: .or) { (ps, p) in
                assert(ps.count == 2)
            }
        })
    }
    
    func testWaitUntil() {
        
        testPredicates.forEach { predicate in
            let trueBlock = { return true }
            let falseBlock = { return false }
            group(text: "🙏: waitUntil -> falseBlock <\(predicate.rawValue.regularString)>") { _ in
                let tuple = item0.waitUntil(predicates: [predicate], logic: .and, timeout: 0.1, handler: falseBlock)
                assert(tuple.result == .timedOut)
                let tuple1 = item1.waitUntil(predicates: [predicate], logic: .and, timeout: 0.1, handler: falseBlock)
                assert(tuple1.result == .timedOut)
            }
            group(text: "🙏: waitUntil -> <\(predicate.rawValue.regularString)>") { _ in
                let tuple = item1.waitUntil(predicates: [predicate], logic: .and, timeout: 1, handler: nil)
                assert(tuple.result == .completed || tuple.result == .timedOut)
                assert(tuple.element == item1)
            }
            group(text: "🙏: waitUntil -> logic: .not <\(predicate.rawValue.regularString)>") { _ in
                let tuple = item1.waitUntil(predicates: [predicate], logic: .not, timeout: 0.1, handler: trueBlock)
                assert(tuple.result == .timedOut)
                assert(tuple.element == item1)
            }
        }
        
        group(text: "🙏: waitUntil -> group") { _ in
            let tuple = item1.waitUntil(predicates: [.exists(true), .exists(false)])
            assert(tuple.result == .timedOut)
            
            let tuple1 = item1.waitUntil(predicates: [.exists(false), .type(.window)])
            assert(tuple1.result == .completed)
            
            let tuple3 = item1.waitUntil(predicates: [.exists(true), .exists(false)], logic: .or, timeout: 1, handler: nil)
            assert(tuple3.result == .completed || tuple3.result == .timedOut)
        }
    }
}

extension NSArray {
    
    fileprivate func testPredicateFilter(predicate: EasyPredicate, block: ([EasyPredicateTestItem], EasyPredicate) -> Void) {
        guard let result = filtered(using: predicate.toPredicate) as? [EasyPredicateTestItem] else {
            assert(false, "element type must be EasyPredicateTestItem")
        }
        block(result, predicate)
    }
    
    fileprivate func testPredicateGroupFilter(predicates: [EasyPredicate],
                                              logic: NSCompoundPredicate.LogicalType,
                                              block: ([EasyPredicateTestItem], [EasyPredicate]) -> Void) {
        guard let result = filtered(using: predicates.toPredicate(logic)) as? [EasyPredicateTestItem] else {
            assert(false, "element type must be EasyPredicateTestItem")
        }
        block(result, predicates)
    }
}
