//
//  ColorCollectionViewCell.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/9/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class ColorCollectionViewCell: UICollectionViewCell {
    
    var viewModel : ColorCellModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupCell()
    }
    
    private func setupCell() {
        
    }
    
    // MARK: Layout
    
    override func layoutSubviews() {
        let cellWidth = viewModel!.width
        self.layer.cornerRadius = cellWidth/2
    }
}
