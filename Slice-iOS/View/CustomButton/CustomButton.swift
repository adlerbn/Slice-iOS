//
//  CustomButton.swift
//  Slice-iOS
//
//  Created by Yahya Bn on 6/23/21.
//

import UIKit

class CustomButton: UIButton {
    var enableAlpha: CGFloat = 1.0
    var disableAlpha: CGFloat = 0.3
    
    func enableButton() {
        self.alpha = enableAlpha
        self.isEnabled = true
    }
    
    func disableButton() {
        self.alpha = disableAlpha
        self.isEnabled = false
    }
}
