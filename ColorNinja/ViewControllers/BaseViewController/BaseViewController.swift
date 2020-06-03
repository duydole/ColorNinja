//
//  BaseViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

fileprivate let buttonWidth = scaledValue(35)

class BaseViewController : UIViewController {
  
  var exitButton : UIButton!
  var settingButton : UIButton!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = Constants.GameScreen.backgroundColor
  }
  
  override func loadView() {
    super.loadView()
    self.setupViews()
  }
  
  func setupViews() {
    self.setupExitButton()
    self.setupSettingButton()
  }
  
  private func setupExitButton() {
    exitButton = UIButton()
    self.view.addSubview(exitButton)
    exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
    exitButton.imageView?.tintColor = .white
    exitButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(buttonWidth)
      make.top.equalTo(Constants.GameScreen.topInset)
      make.trailing.equalTo(-Constants.GameScreen.rightInset)
    }
  }
  
  private func setupSettingButton() {
    settingButton = UIButton()
    self.view.addSubview(settingButton)
    settingButton.setImage(UIImage(named: Constants.GameScreen.settingImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
    settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
    settingButton.imageView?.tintColor = .white
    settingButton.snp.makeConstraints { (make) in
      make.width.height.equalTo(buttonWidth)
      make.top.equalTo(Constants.GameScreen.topInset)
      make.leading.equalTo(Constants.GameScreen.leftInset)
    }
  }
  
  @objc private func didTapExitButton() {
    self.dismiss(animated: true, completion: nil)
  }
  
  @objc func didTapSettingButton() {
    let gameSettingPopup = GameSettingPopup()
    gameSettingPopup.modalPresentationStyle = .overCurrentContext
    self.present(gameSettingPopup, animated: false, completion: nil)
  }
}
