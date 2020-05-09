//
//  PlayingGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class PlayingGameViewController : UIViewController {
    
    let settingButton : UIButton = UIButton()
    let exitButton : UIButton = UIButton()
    let levelCountLabel : UILabel = UILabel()
    let appImage : UIImageView = UIImageView()
    let remainTimeLabel : UILabel = UILabel()
    let labelsContainer : UIView = UIView()
    
    var currentLevel : Int = 1
    var remainingTime : String = "00:00"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GameScreen.backgroundColor
        self.setupViews()
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.setupSettingButton()
        self.setupExitButton()
        self.setupLabelsContainer()
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
    
    private func setupLabelsContainer() {
        self.view.addSubview(labelsContainer)
        labelsContainer.snp.makeConstraints { (make) in
            make.top.equalTo(settingButton.snp.bottom).offset(Constants.GameScreen.LabelsContainer.margins.top)
            make.leading.equalTo(Constants.GameScreen.LabelsContainer.margins.left)
            make.trailing.equalTo(-Constants.GameScreen.LabelsContainer.margins.right)
            make.height.equalTo(Constants.GameScreen.LabelsContainer.height)
        }
    }
    
    private func setupLevelViews() {
        
        // Level
        let levelLabel = UILabel()
        levelLabel.text = "LEVEL"
        levelLabel.textAlignment = .center
        levelLabel.textColor = Constants.GameScreen.LabelsContainer.textColor
        levelLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        labelsContainer.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelsContainer)
            make.leading.equalTo(labelsContainer)
        }
        
        // Level Count
        labelsContainer.addSubview(levelCountLabel)
        levelCountLabel.text = "\(currentLevel)"
        levelCountLabel.textAlignment = .center
        levelCountLabel.textColor = .white
        levelCountLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        levelCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(levelLabel.snp.bottom)
            make.leading.equalTo(labelsContainer)
            make.centerX.equalTo(levelLabel.snp.centerX)
        }
    }
    
    private func setupAppImageView() {
        
    }
    
    private func setupTimerView() {
        
        // Time
        let timeLabel = UILabel()
        timeLabel.text = "TIME"
        timeLabel.textAlignment = .center
        timeLabel.textColor = Constants.GameScreen.LabelsContainer.textColor
        timeLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        labelsContainer.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelsContainer)
            make.trailing.equalTo(labelsContainer)
        }
        
        // Remain Time
        labelsContainer.addSubview(remainTimeLabel)
        remainTimeLabel.text = remainingTime
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.textColor = .white
        remainTimeLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        remainTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom)
            make.trailing.equalTo(labelsContainer)
            make.centerX.equalTo(timeLabel.snp.centerX)
        }
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
