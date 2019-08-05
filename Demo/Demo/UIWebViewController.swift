//
//  UIWebViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/31.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Einstein

class UIWebViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView <<< AccessibilityDemoID.Web.uiWebView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = URL(string: "https://www.baidu.com") else { return }
        webView.loadRequest(URLRequest(url: url))
    }
}
