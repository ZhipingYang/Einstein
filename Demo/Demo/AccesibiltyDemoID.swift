//
//  AccesibiltyDemoID.swift
//  Demo
//
//  Created by Daniel Yang on 2019/7/29.
//  Copyright © 2019 Daniel Yang. All rights reserved.
//

import Foundation
import Einstein

struct AccessibilityDemoID {
    
    enum TabItem: String, PrettyRawRepresentable {
        case first, second
    }
    enum BarItem: String, PrettyRawRepresentable {
        case Push, present
    }

    enum Interface: String, PrettyRawRepresentable {
        case buttonLabel, button
        case segmentLabel, segment
        case sliderLabel, slider
        case switchLabel, `switch`
        case stepperLabel, stepper
    }
    enum Show: String, PrettyRawRepresentable {
        case progressLabel, progress
        case activityLabel, activity
        case pageControlLabel, pageControl
        case imageViewLabel, imageView
    }
    enum Big: String, PrettyRawRepresentable {
        case datePicker, pickerView
    }
    enum Input: String, PrettyRawRepresentable {
        case textfieldLabel, textfield
        case textViewLabel, textView
    }
    enum Web: String, PrettyRawRepresentable {
        case uiWebView, wkWebView
    }

}
