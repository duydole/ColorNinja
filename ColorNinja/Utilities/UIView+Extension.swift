//
//  View+Extension.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var top : CGFloat  {
        get {
            return self.frame.origin.y
        }
    }
    
    var bottom : CGFloat {
        get {
            return self.frame.origin.y + self.frame.size.height
        }
    }
    
}
