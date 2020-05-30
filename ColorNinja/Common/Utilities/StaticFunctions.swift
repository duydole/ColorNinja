//
//  StaticFunctions.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

func ColorRGB(_ red: CGFloat, _ green: CGFloat,_ blue: CGFloat ) -> UIColor {
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
}

func printAllFamilyFonts() {
    for family in UIFont.familyNames.sorted() {
        let names = UIFont.fontNames(forFamilyName: family)
        print("Family: \(family) Font Names: \(names)")
    }
}

func getRealNameWithoutPlus(name: String) -> String {
    return name.replacingOccurrences(of: "+", with: " ", options: .literal, range: nil)
}
