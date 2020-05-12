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
    var muteBgSoundButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override var contentSize: CGSize {
        return Constants.GameSettingPopup.contentSize
    }
    
    override var cornerRadius: CGFloat {
        return Constants.GameSettingPopup.cornerRadius
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        self.setupNavigationBar()
        self.setupSubContentView()
        self.setupButtons()
    }
    
    private func setupNavigationBar() {
        
        // NavigationBar
        navigationBar = UIView()
        navigationBar.backgroundColor = ColorRGB(229, 141, 35)
        contentView.addSubview(navigationBar)
        contentView.clipsToBounds = true
        navigationBar.snp.makeConstraints { (make) in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(Constants.GameSettingPopup.navigationBarHeight)
        }
        
        // Title
        let title = UILabel()
        title.text = "SETTING"
        title.textColor = .white
        title.font = UIFont.systemFont(ofSize: 30, weight: .bold)
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
            make.width.height.equalTo(20)
            make.trailing.equalToSuperview().offset(-20)
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

        let padding = 10
        contentView.addSubview(subContentView)
        subContentView.snp.makeConstraints { (make) in
            make.bottom.trailing.equalTo(-padding)
            make.leading.equalTo(padding)
            make.top.equalTo(self.navigationBar.snp.bottom).offset(padding)
        }
    }
    
    private func setupButtons() {
        muteBgSoundButton = UIButton()
        muteBgSoundButton.setTitle("MUTE", for: .normal)
        muteBgSoundButton.setTitleColor(.black, for: .normal)
        subContentView.addSubview(muteBgSoundButton)
        muteBgSoundButton.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        muteBgSoundButton.addTarget(self, action: #selector(didTapMuteBackgroundSoundButton), for: .touchUpInside)
    }
    
    @objc private func didTapExitButton() {
        self.dismissPopUp()
    }
    
    @objc private func didTapMuteBackgroundSoundButton() {
        GameMusicPlayer.shared.muteBackgroundGameMusic()
    }
}

