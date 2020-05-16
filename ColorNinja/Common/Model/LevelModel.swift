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
    
    let levelIndex : Int
    
    var numberOfItems : Int {
        get {
            return numberOfRows * numberOfRows
        }
    }
    
    let numberOfRows : Int
    
    lazy var cellWidth : CGFloat = {
        let N: CGFloat = CGFloat(self.numberOfRows)
        let spacing: CGFloat = Constants.GameScreen.BoardCollectionView.spacingBetweenCells
        let boardWidth: CGFloat = Constants.GameScreen.BoardCollectionView.boardWidth
        let itemWidth = (boardWidth - (N - 1) * spacing) / N
        return itemWidth
    }()
    
    var mainColor : UIColor!
    
    var correctColor : UIColor!
    
    var correctIndex : Int
    
    // MARK: - Public Methods
    
    init(levelIndex: Int) {
        self.levelIndex = levelIndex
        numberOfRows = LevelModel.numberOfRowsInLevel(index: levelIndex)
        correctIndex = Int.random(in: 0...numberOfRows*numberOfRows-1)
    }
    
    func setRandomColor() {
        let pairOfColor : (UIColor, UIColor) = ColorStore.shared.getPairOfColorRandom(levelOfDifficult: self.levelIndex)
        mainColor = pairOfColor.0
        correctColor = pairOfColor.1
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
