//
//  FistViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import UITestHelper

class FistViewController: UITableViewController {

    @IBOutlet weak var pushItem: UIBarButtonItem!
    
    @IBOutlet weak var buttonLabel: UILabel!
    @IBOutlet weak var button: UIButton!

    @IBOutlet weak var segmentLabel: UILabel!
    @IBOutlet weak var segment: UISegmentedControl!

    @IBOutlet weak var sliderLabel: UILabel!
    @IBOutlet weak var slider: UISlider!

    @IBOutlet weak var switchLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!

    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var stepper: UIStepper!

    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var progress: UIProgressView!

    @IBOutlet weak var activityLabel: UILabel!
    @IBOutlet weak var activity: UIActivity!

    @IBOutlet weak var pageControlLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!

    @IBOutlet weak var imageViewLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var picker: UIPickerView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pushItem >>> AccessibilityDemoID.BarItem.Push

        buttonLabel >>> AccessibilityDemoID.Interface.buttonLabel
        button >>> AccessibilityDemoID.Interface.button
        
        segmentLabel >>> AccessibilityDemoID.Interface.segmentLabel
        segment >>> AccessibilityDemoID.Interface.segment
        
        sliderLabel >>> AccessibilityDemoID.Interface.sliderLabel
        slider >>> AccessibilityDemoID.Interface.slider
        
        switchLabel >>> AccessibilityDemoID.Interface.switchLabel
        `switch` >>> AccessibilityDemoID.Interface.switch

        stepperLabel >>> AccessibilityDemoID.Interface.stepperLabel
        stepper >>> AccessibilityDemoID.Interface.stepper
        
        progressLabel >>> AccessibilityDemoID.Show.progressLabel
        progress >>> AccessibilityDemoID.Show.progress
        
        activityLabel >>> AccessibilityDemoID.Show.activityLabel
//        activity.accessibiliiden >>> AccessibilityDemoID.Show.activity
        
        pageControlLabel  >>> AccessibilityDemoID.Show.pageControlLabel
        pageControl >>> AccessibilityDemoID.Show.pageControl
        
        datePicker >>> AccessibilityDemoID.Big.datePicker
        picker >>> AccessibilityDemoID.Big.pickerView
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
