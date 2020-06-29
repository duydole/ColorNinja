//
//  ColorStore.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class ColorStore {
  
  static let shared = ColorStore()
  
  // MARK: Public Property
  
  public private(set) var allColors: [UIColor]!
  
  // MARK: Public Methods
  
  func getPairOfColorRandom(levelOfDifficult: Int) -> (UIColor, UIColor) {
    let randomColor = self.allColors[Int.random(in: 0...allColors.count - 1)]
    let samesameColor = self.generateRandomSameSameColor(rootColor: randomColor, level: levelOfDifficult)
    return (randomColor, samesameColor)
  }
  
  func generateRandomSameSameColor(rootColor: UIColor, level: Int) -> UIColor {
    let colorWillChange = Int.random(in: 0...2)
    return generateRandomSameSameColor(rootColot: rootColor, level: level, RGBIndexWillBeChanged: colorWillChange)
  }
  
  func generateRandomSameSameColor(rootColot: UIColor, level: Int, RGBIndexWillBeChanged: Int) -> UIColor {
    
    // Get RGB value
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    rootColot.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    red = red*255
    green = green*255
    blue = blue*255
    
    // Random độ thay đổi
    var degreeOfChange : CGFloat = 0
    if level < 5 {
      degreeOfChange = 50
    } else if level < 10 {
      degreeOfChange = 40
    } else if level < 15 {
      degreeOfChange = 35
    } else if level < 20 {
      degreeOfChange = 30
    } else if level < 20 {
      degreeOfChange = 25
    } else {
      degreeOfChange = 20
    }
    
    // Random đổi R, G hay B
    if RGBIndexWillBeChanged == 0 {
      red = red + degreeOfChange > 255 ? 255 : red + degreeOfChange
      green = green + degreeOfChange > 255 ? 255 : green + degreeOfChange
    } else if RGBIndexWillBeChanged == 1 {
      green = green + degreeOfChange > 255 ? 255 : green + degreeOfChange
      blue = blue + degreeOfChange > 255 ? 255 : blue + degreeOfChange
    } else if RGBIndexWillBeChanged == 2 {
      blue = blue + degreeOfChange > 255 ? 255 : blue + degreeOfChange
      red = red + degreeOfChange > 255 ? 255 : red + degreeOfChange
    }
    
    return ColorRGB(red, green, blue)
  }
  
  // MARK: Private
  
  private init() {
    self.setupColors()
  }
  
  private func setupColors() {
    
    allColors = [
      ColorRGB(8, 170, 145),
      ColorRGB(238, 93, 39),
      ColorRGB(223, 27, 83),
      ColorRGB(118, 41, 140),
      ColorRGB(84, 79, 136),
      ColorRGB(144, 11, 62),
      ColorRGB(119, 1, 56),
      ColorRGB(255, 87, 51),
      //ColorRGB(255, 195, 3),  // Màu vàng khó thấy mẹ nè
      ColorRGB(67, 41, 103),
      ColorRGB(120, 45, 101),
      ColorRGB(235, 219, 152),
      ColorRGB(249, 66, 82),
      ColorRGB(32, 68, 91),
      ColorRGB(123, 56, 65),
      ColorRGB(248, 231, 169),
      ColorRGB(197, 225, 111),
      ColorRGB(196, 55, 129),
      ColorRGB(70, 93, 110),
      ColorRGB(240, 192, 168)
    ]
    
    if AppConfig.shared.listColors.count > 15 {
      allColors = AppConfig.shared.listColors
    }
  }
}

