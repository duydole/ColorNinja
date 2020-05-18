//
//  InputUserNamePopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/17/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

import UIKit

class InputUserNamePopup: PopupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override var contentSize: CGSize {
        return Constants.InputUserNamePopup.contentSize
    }
    
    override var cornerRadius: CGFloat {
        return Constants.InputUserNamePopup.cornerRadius
    }
}
