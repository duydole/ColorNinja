//
//  ButtonWithImage.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class ButtonWithImage: UIView {
    
    // MARK: - Public property
    
    var image: UIImage?
    
    var titleText: String?
    
    func addTargetForTouchUpInsideEvent(target: Any, selector: Selector) {
        let gesture:UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: selector)
        gesture.numberOfTapsRequired = 1
        isUserInteractionEnabled = true
        addGestureRecognizer(gesture)
    }
    
    // MARK: - Private property
    
    private var imageView: UIImageView!
    
    private var titleLabel: UILabel!
    
    // MARK: - Overrides
    
    override func layoutSubviews() {
        
        let buttonHeight: CGFloat = self.frame.size.height
        let padding: CGFloat = 10
        let imageViewWidth: CGFloat = buttonHeight - padding*2
        
        // image
        imageView = UIImageView()
        if let image = self.image {
            imageView.image = image
        }
        self.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.width.equalTo(imageViewWidth)
            make.leading.top.equalTo(padding)
            make.bottom.equalTo(-padding)
        }
        
        // title
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .white
        titleLabel.font = UIFont.systemFont(ofSize: 25)
        if let text = self.titleText {
            titleLabel.text = text
        }
        self.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(padding)
            make.leading.equalTo(imageView.snp.trailing).offset(padding)
            make.trailing.bottom.equalTo(-padding)
        }
    }
}
