//
//  AppConfig.swift
//  ColorNinja
//
//  Created by Do Le Duy on 6/28/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class AppConfig {
  
  static let shared = AppConfig()
  
  /// Show eventPoup 1 time /session
  public var didShowEventPopup = false
  
  public var listColors: Array<UIColor> = []
    
}
