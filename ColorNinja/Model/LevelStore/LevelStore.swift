//
//  LevelManager.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class LevelStore {
    
    // MARK: - Shared
    
    static let shared = LevelStore()
    
    // MARK: - Public Property
    
    let maxLevelCount: Int = Constants.GameSetting.maxLevelCount
    
    var allLevels: [LevelModel] = []

    // MARK: - Private
    
    private init() {
        self.setupLevels()
    }
    
    private func setupLevels() {
        for i in 0...self.maxLevelCount {
            allLevels.append(LevelModel(levelIndex: i))
        }
    }
}
