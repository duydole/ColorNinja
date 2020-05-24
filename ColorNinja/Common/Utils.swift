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

public func fontSizeScaled(_ value: CGFloat) -> CGFloat {
    let scaled = scaledValue(value)
    return scaled.rounded(.up)
}

public func showMiniLoading(onView view: UIView) {
    SVProgressHUD.setForegroundColor(.systemBlue)
    SVProgressHUD.setContainerView(view)
    SVProgressHUD.show()
}

public func hideLoading() {
    SVProgressHUD.dismiss()
}

public func scaledValue(_ value: CGFloat,_ baseWidth: CGFloat = 414) -> CGFloat {
    let multiplier = UIScreen.main.bounds.width / baseWidth
    let scaled = value * multiplier
    
    return scaled.rounded()
}

public func sizeScalediPhone5(_ value: CGFloat) -> CGFloat {
    let scaled = scaledValue(value, 320)
    return scaled.rounded()
}

public func valueScaledHeight(_ value: CGFloat,_ baseHeight: CGFloat = 414) -> CGFloat {
    let multiplier = UIScreen.main.bounds.height / baseHeight
    let scaled = value * multiplier
    
    return scaled.rounded()
}

public func fontSizeScaled(_ value: CGFloat, _ baseWidth: CGFloat = 414) -> CGFloat {
    let scaled = scaledValue(value, baseWidth)
    return scaled.rounded(.up)
}

public func fontSizeScalediPhone5(_ value: CGFloat) -> CGFloat {
    let scaled = scaledValue(value, 320)
    return scaled.rounded(.up)
}

public func isCurrentDeviceInstalled(app appDeepLink: String = "zalo://app") -> Bool {
    guard let appUrl = URL(string: appDeepLink) else {
        return false
    }
    return UIApplication.shared.canOpenURL(appUrl as URL)
}

public func saveArrayIntToUserDefault(_ array:[Int], key: String) {
    let defaults = UserDefaults.standard
    defaults.set(array, forKey: key)
}

public func getArrayIntFromUserDefault(key: String) -> [Int]{
    let defaults = UserDefaults.standard
    return defaults.array(forKey: key)  as? [Int] ?? [Int]()
}

public func safeAreaBottom() -> CGFloat {
    var bottomPadding: CGFloat = 0.0
    if #available(iOS 11.0, *) {
        let window = UIApplication.shared.keyWindow
        bottomPadding = window?.safeAreaInsets.bottom ?? 0.0
    }
    return bottomPadding
}

public func heightStatusBar() -> CGFloat {
    let frame = UIApplication.shared.statusBarFrame
    let topPadding = frame.origin.y + frame.size.height
    return topPadding
}
