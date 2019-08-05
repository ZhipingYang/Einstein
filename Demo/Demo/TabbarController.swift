//
//  ViewController.swift
//  UITestDemo
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Einstein

class TabbarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers?.forEach { $0.tabBarItem.isAccessibilityElement = true }
        
//        viewControllers?.first?.tabBarItem <<< AccessibilityDemoID.TabItem.first
//        viewControllers?.last?.tabBarItem <<< AccessibilityDemoID.TabItem.second
        
        viewControllers?.first?.tabBarItem.accessibilityLabel = AccessibilityDemoID.TabItem.first.prettyRawValue
        viewControllers?.last?.tabBarItem.accessibilityLabel = AccessibilityDemoID.TabItem.second.prettyRawValue
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

