//
//  BoardCollectionViewFlowLayout.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class BoardCollectionViewFlowLayout: UICollectionViewFlowLayout {
    
    /* initialSize of cell is Zero */
    override func initialLayoutAttributesForAppearingItem(at itemIndexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = super.initialLayoutAttributesForAppearingItem(at: itemIndexPath)?.copy() as? UICollectionViewLayoutAttributes
        attributes?.transform = CGAffineTransform(scaleX: 0.0, y: 0.0)
        return attributes
    }
}
