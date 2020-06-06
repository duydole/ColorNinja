//
//  GameSettingManager.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class GameSettingManager {
  
  static let shared = GameSettingManager()
  
  public var allowEffectSound: Bool!
  public var allowMainSound: Bool!
  
  private init() {
    allowEffectSound = true
    allowMainSound = true
  }
}
