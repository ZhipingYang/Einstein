//
//  FistViewController.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/25.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import UIKit

class FistViewController: UITableViewController {

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

        // Do any additional setup after loading the view.
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
