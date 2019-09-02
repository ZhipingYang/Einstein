//
//  MacDemoUITests.swift
//  MacDemoUITests
//
//  Created by Daniel Yang on 2019/8/7.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import XCTest
import Einstein

class MacDemoUITests: XCTestCase {

    override func setUp() {
        super.setUp()
        continueAfterFailure = true
        group(text: "Delete app before app launch") { _ in
//            Springboard.deleteAppIfNeed("MacDemo")
        }
        app.launch()
    }
    
    override func tearDown() {
        group(text: "Delete App") { _ in
            XCUIApplication().terminate()
//            Springboard.deleteAppIfNeed("Demo")
        }
        super.tearDown()
    }

    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

}
