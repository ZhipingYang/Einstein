//
//  ViewController.swift
//  UITestDemo
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import UITestHelper

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        toolbarItems?.first >>> AccessibilityDemoID.TabItem.first
        toolbarItems?.last >>> AccessibilityDemoID.TabItem.second
    }
}

