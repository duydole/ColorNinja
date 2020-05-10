//
//  GameOverPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class GameOverPopup: PopupViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override var contentSize: CGSize {
        return Constants.GameOverPopup.contentSize
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        
    }
}
