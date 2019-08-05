//
//  FistViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit
import Einstein

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
        
        pushItem <<< AccessibilityDemoID.BarItem.Push

        buttonLabel <<< AccessibilityDemoID.Interface.buttonLabel
        button <<< AccessibilityDemoID.Interface.button
        
        segmentLabel <<< AccessibilityDemoID.Interface.segmentLabel
        segment <<< AccessibilityDemoID.Interface.segment
        
        sliderLabel <<< AccessibilityDemoID.Interface.sliderLabel
        slider <<< AccessibilityDemoID.Interface.slider
        
        switchLabel <<< AccessibilityDemoID.Interface.switchLabel
        `switch` <<< AccessibilityDemoID.Interface.switch

        stepperLabel <<< AccessibilityDemoID.Interface.stepperLabel
        stepper <<< AccessibilityDemoID.Interface.stepper
        
        progressLabel <<< AccessibilityDemoID.Show.progressLabel
        progress <<< AccessibilityDemoID.Show.progress
        
        activityLabel <<< AccessibilityDemoID.Show.activityLabel
//        activity.accessibiliiden <<< AccessibilityDemoID.Show.activity
        
        pageControlLabel  <<< AccessibilityDemoID.Show.pageControlLabel
        pageControl <<< AccessibilityDemoID.Show.pageControl
        
        datePicker <<< AccessibilityDemoID.Big.datePicker
        
        picker <<< AccessibilityDemoID.Big.pickerView
        picker.delegate = self
        picker.dataSource = self
    }

    @IBAction func buttonAction(_ sender: UIButton) {
        buttonLabel.text = "clicked"
    }

    @IBAction func segmentAction(_ sender: UISegmentedControl) {
        segmentLabel.text = "\(sender.selectedSegmentIndex)"
    }

    @IBAction func sliderAction(_ sender: UISlider) {
        sliderLabel.text = "\(sender.value)"
    }

    @IBAction func switchAction(_ sender: UISwitch) {
        switchLabel.text = sender.isOn ? "on ": "off"
    }

    @IBAction func stepperAction(_ sender: UIStepper) {
        stepperLabel.text = "\(sender.value)"
    }
    
}


extension FistViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(component) - \(row)"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
}
