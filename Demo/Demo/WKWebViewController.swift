//
//  WKWebViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/31.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import WebKit
import Einstein

class WKWebViewController: UIViewController {
    
    lazy var webview = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webview)
        webview <<< AccessibilityDemoID.Web.wkWebView
        
        NSLayoutConstraint.activate([
            webview.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webview.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webview.topAnchor.constraint(equalTo: view.topAnchor),
            webview.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let url = URL(string: "https://www.baidu.com") else { return }
        webview.load(URLRequest(url: url))
    }
}
