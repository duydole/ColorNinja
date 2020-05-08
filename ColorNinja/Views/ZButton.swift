//
//  ZButton.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ZButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupButton()
    }
    
    func setupButton() {
        self.backgroundColor = UIColor.red
        self.titleLabel!.font = self.titleLabel!.font.withSize(Constants.HomeScreen.buttonFontSize)
        let buttonSize : CGSize = self.sizeThatFits(Constants.Screen.size)
        self.layer.cornerRadius = buttonSize.height/2
        
        self.snp.makeConstraints { (make) in
            make.width.equalTo(Constants.HomeScreen.buttonWidth)
        }
    }
}
