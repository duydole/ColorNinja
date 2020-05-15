//
//  Utils.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/14/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import SVProgressHUD

fileprivate let baseWidth = 375.0

public func valueScaled(_ value: CGFloat) -> CGFloat {
    let designedWidthSize: CGFloat = CGFloat(baseWidth)
    let multiplier = UIScreen.main.bounds.width / designedWidthSize
    let scaled = value * multiplier
    
    return scaled.rounded()
}

public func fontSizeScaled(_ value: CGFloat) -> CGFloat {
    let scaled = valueScaled(value)
    return scaled.rounded(.up)
}

public func showMiniLoading(onView view: UIView) {
    SVProgressHUD.setForegroundColor(.systemBlue)
    SVProgressHUD.setContainerView(view)
    SVProgressHUD.show()
}
