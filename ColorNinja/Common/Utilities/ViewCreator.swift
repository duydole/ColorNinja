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
        label.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
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
}
