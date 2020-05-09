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
    
    static let shared = LevelStore()
    let maxLevelCount: Int = 100
    var allLevels: [LevelModel] = []

    // MARK: Private
    
    private init() {
        self.setupLevels()
    }
    
    private func setupLevels() {
        for i in 0...self.maxLevelCount {
            allLevels.append(LevelModel(levelIndex: i))
        }
    }
}
