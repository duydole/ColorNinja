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
        self.view.addSubview(settingButton)
        settingButton.setImage(UIImage(named: Constants.GameScreen.settingImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        settingButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        settingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.settingButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.leading.equalTo(Constants.GameScreen.leftInset)
        }
    }
    
    private func setupExitButton() {
        self.view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        exitButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        exitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.exitButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.trailing.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    private func setupLevelViews() {
        
    }
    
    private func setupAppImageView() {
        
    }
    
    private func setupTimerView() {
        
    }
    
    private func setupCollectionViews() {
        
    }
    
    // MARK: Event handler
    
    @objc private func didTapSettingButton() {
        
    }
    
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}
