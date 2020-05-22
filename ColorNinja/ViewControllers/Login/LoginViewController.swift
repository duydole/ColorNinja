//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/19/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    
    private var loginWithZaloButton: ButtonWithImage!
    private var loginWithFBButton: ButtonWithImage!
    private var loginAsGuestButton: ButtonWithImage!
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .white
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        setupButtons()
    }
    
    private func setupButtons() {
        
        // Container
        let container = UIView()
        let containerHeight: CGFloat = 220
        let padding: CGFloat = 20
        let buttonHeight = (containerHeight - 2*padding)/3
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(containerHeight)
            make.center.equalToSuperview()
        }
        
        // Login with Zalo
        loginWithZaloButton = ButtonWithImage()
        loginWithZaloButton.buttonPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        loginWithZaloButton.spacing = 10
        loginWithZaloButton.titleLabel.text = "Login with Zalo"
        loginWithZaloButton.titleLabel.textColor = .white
        loginWithZaloButton.imageView.image = UIImage(named: "zalologo")
        loginWithZaloButton.imageView.layer.cornerRadius = 8
        loginWithZaloButton.imageView.layer.masksToBounds = true
        loginWithZaloButton.layer.cornerRadius = 12
        loginWithZaloButton.backgroundColor = Color.Zalo.blue2
        loginWithZaloButton.makeShadow()
        loginWithZaloButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithZaloButton))
        container.addSubview(loginWithZaloButton)
        loginWithZaloButton.snp.makeConstraints { (make) in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
        
        // login with facebook
        loginWithFBButton = ButtonWithImage()
        loginWithFBButton.buttonPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        loginWithFBButton.spacing = 10
        loginWithFBButton.titleLabel.text = "Login with Facebook"
        loginWithFBButton.titleLabel.textColor = .white
        loginWithFBButton.imageView.image = UIImage(named: "fblogo")
        loginWithFBButton.imageView.layer.cornerRadius = 8
        loginWithFBButton.imageView.layer.masksToBounds = true
        loginWithFBButton.layer.cornerRadius = 12
        loginWithFBButton.backgroundColor = Color.Facebook.loginButton
        loginWithFBButton.makeShadow()
        loginWithFBButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithFacebookButton))
        container.addSubview(loginWithFBButton)
        loginWithFBButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(loginWithZaloButton)
            make.top.equalTo(loginWithZaloButton.snp.bottom).offset(20)
        }
        
        // login as guest
        loginAsGuestButton = ButtonWithImage()
        loginAsGuestButton.buttonPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        loginAsGuestButton.spacing = 10
        loginAsGuestButton.titleLabel.text = "Play game as guest"
        loginAsGuestButton.titleLabel.textColor = .white
        loginAsGuestButton.imageView.image = UIImage(named: "usericon")
        loginAsGuestButton.imageView.layer.cornerRadius = 8
        loginAsGuestButton.imageView.layer.masksToBounds = true
        loginAsGuestButton.layer.cornerRadius = 12
        loginAsGuestButton.backgroundColor = ColorRGB(255, 18, 18)
        loginAsGuestButton.makeShadow()
        loginAsGuestButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginAsGuestButton))
        container.addSubview(loginAsGuestButton)
        loginAsGuestButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(loginWithFBButton)
            make.top.equalTo(loginWithFBButton.snp.bottom).offset(20)
        }
    }
    
    // MARK: - Handle Events
    
    @objc private func didTapLoginWithZaloButton() {
        
    }
    
    @objc private func didTapLoginWithFacebookButton() {
        
    }
    
    @objc private func didTapLoginAsGuestButton() {
        let createRoomVC = LoginAsGuestViewcontroller()
        createRoomVC.modalPresentationStyle = .fullScreen
        self.present(createRoomVC, animated: false, completion: nil)
    }
}
