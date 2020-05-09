//
//  Constants.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    struct Screen {
        static let width = UIScreen.main.bounds.size.width
        static let height = UIScreen.main.bounds.size.height
        static let size = UIScreen.main.bounds.size
    }
    
    struct HomeScreen {
        static let paddingTopOfIcon : CGFloat = Size.statusBarHeight + 20
        static let ninjaImageName = "ninjaicon"
        static let appName = "Color Ninja"
        static let appNameColor = UIColor.red.withAlphaComponent(0.5)
        static let iconWidth : CGFloat = 200
        static let standardPadding : CGFloat = 10
        static let appNameLabelHeight : CGFloat = 50
        static let appNameFontSize : CGFloat = 50
        static let buttonFontSize : CGFloat = 40
        static let buttonWidth : CGFloat = 200
    }
    
    struct GameScreen {
        
    }
}
