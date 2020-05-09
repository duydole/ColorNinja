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
    
    // MARK: - Public Propperty
    
    var viewModel : ColorCellModel?
    
    // MARK: - Initialize
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupCell()
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        let cellWidth = viewModel!.width
        self.layer.cornerRadius = cellWidth/2
    }
    
    // MARK: - Private Methods
    
    private func setupCell() {
        
    }
}
