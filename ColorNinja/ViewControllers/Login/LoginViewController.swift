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
    
    private var usernameTextField: UITextField!
    private var loginWithZaloButton: ButtonWithImage!
    private var loginWithFBButton: ButtonWithImage!
    private var loginAsGuestButton: ButtonWithImage!
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        view.backgroundColor = .white
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setupButtons()
    }
    
    private func setupButtons() {
        
        // Container
        let container = UIView()
        let containerHeight: CGFloat = 300
        let padding: CGFloat = 10
        let buttonHeight = (containerHeight - 4*padding)/5
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(containerHeight)
            make.center.equalToSuperview()
        }
        
        // Username
        usernameTextField = ViewCreator.createSimpleTextField(placeholderText: "Your username")
        container.addSubview(usernameTextField)
        usernameTextField.snp.makeConstraints { (make) in
            make.width.top.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
        }
        
        // login as guest
        loginAsGuestButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "usericon")!, title: "Play game as guest", backgroundColor: Color.Facebook.loginButton)
        loginAsGuestButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginAsGuestButton))
        loginAsGuestButton.backgroundColor = ColorRGB(255, 18, 18)
        container.addSubview(loginAsGuestButton)
        loginAsGuestButton.snp.makeConstraints { (make) in
            make.centerX.width.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalTo(usernameTextField.snp.bottom).offset(padding)
        }
        
        // OR Label
        let orLabel = UILabel()
        orLabel.text = "OR"
        orLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
        container.addSubview(orLabel)
        orLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.top.equalTo(loginAsGuestButton.snp.bottom).offset(padding)
        }

        // Login with Zalo
        loginWithZaloButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "zalologo")!, title: "Login with Zalo", backgroundColor: Color.Zalo.blue2)
        loginWithZaloButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithZaloButton))
        container.addSubview(loginWithZaloButton)
        loginWithZaloButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(loginAsGuestButton)
            make.top.equalTo(orLabel.snp.bottom).offset(padding)
        }

        // login with facebook
        loginWithFBButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "fblogo")!, title: "Login with Facebook", backgroundColor: Color.Facebook.loginButton)
        loginWithFBButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithFacebookButton))
        container.addSubview(loginWithFBButton)
        loginWithFBButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(loginWithZaloButton)
            make.top.equalTo(loginWithZaloButton.snp.bottom).offset(padding)
        }
    }
    
    // MARK: Handle Events
    
    @objc private func didTapLoginWithZaloButton() {
        
    }
    
    @objc private func didTapLoginWithFacebookButton() {
        
    }
    
    @objc private func didTapLoginAsGuestButton() {
        guard let username = usernameTextField.text else {
            return
        }
        
        if username.isEmpty {
            showAlertWithMessage(message: "Please input your username. Thanks.")
            return
        }
        
        if !isValidUsername(userName: username) {
            showAlertWithMessage(message: "Please input valid usernmae. Thanks.")
            return
        }
        
        // Save username
        OwnerInfo.shared.updateUserName(newusername: username)
        
        // Open homeVC
        let homeVC = HomeViewController2()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: false, completion: nil)
    }
    
    // MARK: Helper
    
    private func isValidUsername(userName: String) -> Bool {
        return true
    }
    
    private func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
