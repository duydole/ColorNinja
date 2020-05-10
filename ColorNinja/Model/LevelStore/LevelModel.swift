//
//  LevelEntity.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class LevelModel {
    
    // MARK: - Public Properties
    
    let levelIndex: Int
    
    var numberOfItems: Int {
        get {
            return numberOfRows * numberOfRows
        }
    }
    
    let numberOfRows: Int
    
    var cellWidth: CGFloat = 0
    
    // MARK: - Public Methods
    
    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        self.numberOfRows = LevelModel.numberOfRowsInLevel(index: levelIndex)
    }
    
    // MARK: - Static Methods
    
    static func numberOfRowsInLevel(index: Int) -> Int {
        var numberOfRows = 0
        if index < 5 {
            numberOfRows = 2
        } else if index < 10 {
            numberOfRows = 3
        } else if index < 15 {
            numberOfRows = 4
        } else if index < 20 {
            numberOfRows = 4
        } else if index < 25 {
            numberOfRows = 5
        } else {
            numberOfRows = 6
        }
        return numberOfRows
    }
}
