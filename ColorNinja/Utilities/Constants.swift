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
        static let backgroundColor = NiceColor.backgroundColor1
    }
    
    struct GameScreen {
        static let backgroundColor = NiceColor.backgroundColor1
        static let topInset : CGFloat = Size.statusBarHeight + 20
        static let leftInset : CGFloat = 20
        static let rightInset : CGFloat = 20
        static let settingButtonWidth : CGFloat = 40
        static let settingImageName = "setting1"
        static let exitImageName = "close"
        static let exitButtonWidth = GameScreen.settingButtonWidth
        static let buttonTintColor = LytoColor.settingButtonColor
        
        struct LabelsContainer {
            static let fontSize : CGFloat = 25
            static let textColor : UIColor = LytoColor.labelColorInGame
            static let height : CGFloat = 80
            static let padding : UIEdgeInsets = UIEdgeInsets(top: 10,
                                                            left: 10,
                                                            bottom: 10,
                                                            right: 10)
            static let margins : UIEdgeInsets = UIEdgeInsets(top: 50,
                                                             left: 50,
                                                             bottom: 50,
                                                             right: 50)
        }
        
        struct ReadyView {
            static let textColor : UIColor = .yellow
            static let fontSize : CGFloat = 180
        }
        
        struct BoardCollectionView {
            static let cellId : String = "colorCollectionViewCellIdentifier"
            static var boardWidth = Constants.Screen.width - 2*Constants.GameScreen.leftInset - 50
            static let spacingBetweenCells : CGFloat = 5
        }
    }
}

struct ViewControllerStore {
    weak static var gameController : PlayingGameViewController?
}

/**
 * Link: https://www.pinterest.com/pin/95842298307867764/
 */
struct BluePalletes {
    static let level0 = ColorRGB(225,245,254)
    static let level1 = ColorRGB(179,229,252)
    static let level2 = ColorRGB(129,212,250)
}

struct LytoColor {
    static let gameBGColor = ColorRGB(42, 34, 53)
    static let settingButtonColor = ColorRGB(112, 102, 135)
    static let labelColorInGame = ColorRGB(170, 68, 119)
}

struct NiceColor {
    static let backgroundColor1 = ColorRGB(29, 53, 87)
}
