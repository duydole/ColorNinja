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

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ColorCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.GameScreen.BoardCollectionView.cellId, for: indexPath) as! ColorCollectionViewCell
        cell.backgroundColor = UIColor.yellow
        return cell
    }
    
    
}
