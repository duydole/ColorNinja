//
//  BoardDataSource.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class BoardDataSource : NSObject, UICollectionViewDataSource {
    
    // MARK: - Public properties
    
    var levelModel: LevelModel = LevelStore.shared.allLevels[0]
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levelModel.numberOfItems
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.GameScreen.BoardCollectionView.cellId, for: indexPath) as! ColorCollectionViewCell
        cell.viewModel = ColorCellModel(width: levelModel.cellWidth)
        if indexPath.item == levelModel.correctIndex {
            cell.backgroundColor = levelModel.correctColor
        } else {
            cell.backgroundColor = levelModel.mainColor
        }
        return cell
    }
}
