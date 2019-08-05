//
//  SecondViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/30.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Einstein

class SecondViewController: UITableViewController {

    @IBOutlet weak var presnetItem: UIBarButtonItem!
    
    @IBOutlet weak var textfield: UITextField!
    @IBOutlet weak var textfieldLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var textViewLabel: UILabel!
    @IBOutlet weak var uiwebView: UILabel!
    @IBOutlet weak var wkwebView: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        presnetItem <<< AccessibilityDemoID.BarItem.present
        
        textfield <<< AccessibilityDemoID.Input.textfield
        textfieldLabel <<< AccessibilityDemoID.Input.textfieldLabel
        
        textView <<< AccessibilityDemoID.Input.textView
        textViewLabel <<< AccessibilityDemoID.Input.textViewLabel
        
        uiwebView <<< AccessibilityDemoID.Web.uiWebView
        wkwebView <<< AccessibilityDemoID.Web.wkWebView
    }
}
