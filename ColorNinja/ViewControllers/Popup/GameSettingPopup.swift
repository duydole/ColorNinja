//
//  GameSettingPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class GameSettingPopup: PopupViewController {
    
    var navigationBar: UIView!
    var subContentView: UIView!
    var mainSoundSwitch: UISwitch!
    var effectSoundSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override var contentSize: CGSize {
        return CGSize(width: scaledValue(280), height: scaledValue(220))
    }
    
    override var cornerRadius: CGFloat {
        return scaledValue(20)
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        self.setupNavigationBar()
        self.setupSubContentView()
        self.setupSwitchs()
    }
    
    private func setupNavigationBar() {
        
      let fontSize = scaledValue(30)
      
        // NavigationBar
        navigationBar = UIView()
        navigationBar.backgroundColor = ColorRGB(229, 141, 35)
        contentView.addSubview(navigationBar)
        contentView.clipsToBounds = true
        navigationBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(scaledValue(70))
        }
        
        // Title
        let title = UILabel()
        title.text = "SETTING"
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: fontSize, weight: .bold)
        navigationBar.addSubview(title)
        title.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        // CloseButton
        let closeButton = UIButton()
        closeButton.setImage(UIImage(named: "close")?.withRenderingMode(.alwaysTemplate), for: .normal)
        closeButton.imageView?.tintColor = .white
        closeButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        navigationBar.addSubview(closeButton)
        closeButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(scaledValue(20))
            make.trailing.equalToSuperview().offset(scaledValue(-20))
            make.centerY.equalToSuperview()
        }
    }

    private func setupSubContentView() {
        subContentView = UIView()
        subContentView.backgroundColor = ColorRGB(250, 250, 220)
        subContentView.layer.cornerRadius = cornerRadius
        subContentView.layer.shadowColor = UIColor.black.cgColor
        subContentView.layer.shadowOpacity = 0.5
        subContentView.layer.shadowOffset = .zero

        let padding = scaledValue(10)
        contentView.addSubview(subContentView)
        subContentView.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(-padding)
            make.leading.equalTo(padding)
            make.top.equalTo(self.navigationBar.snp.bottom).offset(padding)
        }
    }
    
    private func setupSwitchs() {
        
        // MainSound Switch
        mainSoundSwitch = UISwitch()
        mainSoundSwitch.isOn = GameSettingManager.shared.allowMainSound
        mainSoundSwitch.addTarget(self, action: #selector(mainSoundSwitchDidChange(_:)), for: .valueChanged)
        subContentView.addSubview(mainSoundSwitch)
        mainSoundSwitch.snp.makeConstraints { (make) in
            make.top.equalTo(scaledValue(15))
            make.trailing.equalTo(scaledValue(-20))
        }
        
        // MainLabel
        let mainLabel = UILabel()
        mainLabel.text = "MAIN SOUND"
      mainLabel.font = UIFont.systemFont(ofSize: scaledValue(18))
        subContentView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(scaledValue(20))
            make.centerY.equalTo(mainSoundSwitch)
        }
        
        // EffectSound Switch
        effectSoundSwitch = UISwitch()
        effectSoundSwitch.isOn = GameSettingManager.shared.allowEffectSound
        effectSoundSwitch.addTarget(self, action: #selector(effectSoundSwitchDidChange(_:)), for: .valueChanged)
        subContentView.addSubview(effectSoundSwitch)
        effectSoundSwitch.snp.makeConstraints { (make) in
          make.bottom.equalToSuperview().offset(scaledValue(-15))
            make.centerX.equalTo(mainSoundSwitch)
        }
        
        // MainLabel
        let effectLabel = UILabel()
        effectLabel.text = "EFFECT SOUND"
      effectLabel.font = UIFont.systemFont(ofSize: scaledValue(18))

        subContentView.addSubview(effectLabel)
        effectLabel.snp.makeConstraints { (make) in
            make.leading.equalTo(scaledValue(20))
            make.centerY.equalTo(effectSoundSwitch)
        }
    }
    
    // MARK: - Handle Events
    
    @objc private func didTapExitButton() {
        self.dismissPopUp()
    }
    
    @objc private func didTapMuteBackgroundSoundButton() {
        GameMusicPlayer.shared.muteBackgroundGameMusic()
    }
    
    @objc func mainSoundSwitchDidChange(_ sender: UISwitch) {
        if sender.isOn {
          GameSettingManager.shared.allowMainSound = true
            GameMusicPlayer.shared.unmuteBackgroundGameMusic()
        } else {
          GameSettingManager.shared.allowMainSound = false
            GameMusicPlayer.shared.muteBackgroundGameMusic()
        }
    }
    
    @objc func effectSoundSwitchDidChange(_ sender: UISwitch) {
        GameSettingManager.shared.allowEffectSound = sender.isOn
    }
}

