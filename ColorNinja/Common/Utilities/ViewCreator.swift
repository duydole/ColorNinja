//
//  ViewCreator.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class ViewCreator {
    
    // Tạo Label ở trên
    static func createTitleLabelForTopContainer(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = Constants.GameScreen.LabelsContainer.textColor
        label.font = UIFont.systemFont(ofSize: scaledValue(20), weight: .bold)
        return label
    }
    
    // Tạo label ở dưới
    static func createSubTitleLabelForTopContainer(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textAlignment = .center
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        return label
    }
    
    // Tạo button cho màn hình login
    static func createButtonImageInLoginVC(image: UIImage, title: String, backgroundColor: UIColor) -> ButtonWithImage {
        
        // Config
        let spacing: CGFloat = 10
        let padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        let button = ButtonWithImage()
        button.buttonPadding = padding
        button.spacing = spacing
        button.imageView.image = image
        button.titleLabel.text = title
        button.imageView.layer.cornerRadius = 8
        button.imageView.layer.masksToBounds = true
        button.layer.cornerRadius = 12
        button.backgroundColor = backgroundColor
        button.titleLabel.textColor = .white
        button.makeShadow()

        
        return button
    }
    
    
    // Tạo simple textfield
    static func createSimpleTextField(placeholderText: String) -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .roundedRect;
        textField.placeholder = placeholderText
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        
        return textField
    }
}
