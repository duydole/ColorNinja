//
//  PlayingGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class PlayingGameViewController : UIViewController {
    
    let settingButton : UIButton = UIButton()
    let exitButton : UIButton = UIButton()
    let levelCountLabel : UILabel = UILabel()
    let appImage : UIImageView = UIImageView()
    let remainTimeLabel : UILabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GameScreen.backgroundColor
        self.setupViews()
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.setupSettingButton()
        self.setupExitButton()
        self.setupLevelViews()
        self.setupAppImageView()
        self.setupTimerView()
        self.setupCollectionViews()
    }
    
    private func setupSettingButton() {
        
    }
    
    private func setupExitButton() {
            
    }
    
    private func setupLevelViews() {
        
    }
    
    private func setupAppImageView() {
        
    }
    
    private func setupTimerView() {
        
    }
    
    private func setupCollectionViews() {
        
    }
}
