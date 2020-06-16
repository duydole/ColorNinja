//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/19/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import FBSDKLoginKit

let MAX_USERNAME_LENGTH: Int = 20

class LoginViewController: UIViewController {
  
  private var usernameTextField: UITextField!
  private var loginWithZaloButton: ButtonWithImage!
  #if DISABLE_LOGIN_FB
  private var loginAsGuestButton: UIButton!
  #else
  private var loginWithFBButton: ButtonWithImage!
  private var loginAsGuestButton: ButtonWithImage!
  #endif
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupViews()
  }
  
  // MARK: Setup Views
  
  private func setupViews() {
    setupViewController()
    setupButtons()
  }
  
  private func setupViewController() {
    view.backgroundColor = .white
    let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tap)
  }
  
  private func setupButtons() {
    
    let padding: CGFloat = scaledValue(10)
    let numberOfButtonInContainer: CGFloat = 2
    #if DISABLE_LOGIN_FB
    let containerHeight: CGFloat = scaledValue(120)
    #else
    let containerHeight: CGFloat = scaledValue(300)
    #endif
    let buttonHeight = (containerHeight - (numberOfButtonInContainer - 1)*padding)/numberOfButtonInContainer
    
    // Container
    let container = UIView()
    view.addSubview(container)
    container.snp.makeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(0.7)
      make.height.equalTo(containerHeight)
      make.center.equalToSuperview()
    }
    
    // Username
    usernameTextField = ViewCreator.createSimpleTextField(placeholderText: "Your username")
    usernameTextField.delegate = self
    container.addSubview(usernameTextField)
    usernameTextField.snp.makeConstraints { (make) in
      make.width.top.centerX.equalToSuperview()
      make.height.equalTo(buttonHeight)
    }
    
    // login as guest
    #if DISABLE_LOGIN_FB
    loginAsGuestButton = UIButton()
    loginAsGuestButton.setTitle("LET'S GO", for: .normal)
    loginAsGuestButton.titleLabel?.textColor = .white
    loginAsGuestButton.layer.cornerRadius = 5.0
    loginAsGuestButton.addTarget(self, action: #selector(didTapLoginAsGuestButton), for: .touchUpInside)
    #else
    loginAsGuestButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "defaultAvatar")!, title: "Play game as guest", backgroundColor: Color.Facebook.loginButton)
    loginAsGuestButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginAsGuestButton))
    #endif
    loginAsGuestButton.backgroundColor = ColorRGB(255, 18, 18)
    container.addSubview(loginAsGuestButton)
    loginAsGuestButton.snp.makeConstraints { (make) in
      make.centerX.width.equalToSuperview()
      make.height.equalTo(buttonHeight)
      make.top.equalTo(usernameTextField.snp.bottom).offset(padding)
    }
    
    // OR Label
    #if !DISABLE_LOGIN_FB
    let orLabel = UILabel()
    orLabel.text = "OR"
    orLabel.font = UIFont.systemFont(ofSize: 25, weight: .heavy)
    container.addSubview(orLabel)
    orLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.height.equalTo(buttonHeight)
      make.top.equalTo(loginAsGuestButton.snp.bottom).offset(padding)
    }
    #endif
    
    //        // Login with Zalo
    //        loginWithZaloButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "zalologo")!, title: "Login with Zalo", backgroundColor: Color.Zalo.blue2)
    //        loginWithZaloButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithZaloButton))
    //        container.addSubview(loginWithZaloButton)
    //        loginWithZaloButton.snp.makeConstraints { (make) in
    //            make.width.height.centerX.equalTo(loginAsGuestButton)
    //            make.top.equalTo(orLabel.snp.bottom).offset(padding)
    //        }
    
    #if !DISABLE_LOGIN_FB
    // login with facebook
    loginWithFBButton = ViewCreator.createButtonImageInLoginVC(image: UIImage(named: "fblogo")!, title: "Login with Facebook", backgroundColor: Color.Facebook.loginButton)
    loginWithFBButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapLoginWithFacebookButton))
    container.addSubview(loginWithFBButton)
    loginWithFBButton.snp.makeConstraints { (make) in
      make.width.height.centerX.equalTo(loginAsGuestButton)
      make.top.equalTo(orLabel.snp.bottom).offset(padding)
    }
    #endif
  }
  
  // MARK: Handle Events
  
  @objc private func didTapLoginWithZaloButton() {
    
  }
  
  @objc private func didTapLoginWithFacebookButton() {
    
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["public_profile"], from: self) { (loginResult, error) in
      
      if let _ = error {
        return
      }
      
      guard let loginResult = loginResult else {
        return
      }
      
      if loginResult.isCancelled {
        return
      }
      
      
      // Update UserInfo
      self.updateUserInfoFromFacebookProfile()
      
      // Insert DB:
      DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared) { (success, error) in
        if error != nil {
          assertionFailure()
          return
        }
      }
      
      self.openHomeViewController()
    }
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
      showAlertWithMessage(message: "Please input valid username. Thanks.")
      return
    }
    
    // Save username
    OwnerInfo.shared.updateUserName(newusername: username)
    OwnerInfo.shared.updateLoginType(newLoginType: .Guest)
    
    // Insert DB:
    DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared) { (success, error) in
      if error != nil {
        assertionFailure()
        
        /// Đeo bao
        self.openHomeViewController()
        return
      }
    }
    
    // Open homeVC
    openHomeViewController()
  }
  
  @objc private func dismissKeyboard() {
    usernameTextField.resignFirstResponder()
  }
  
  private func openHomeViewController() {
    let homeVC = HomeViewController()
    self.navigationController?.pushViewController(homeVC, animated: true)
  }
  
  private func updateUserInfoFromFacebookProfile() {
    if let _ = AccessToken.current {
      Profile.loadCurrentProfile { (profile, error) in
        if let profile = Profile.current {
          
          var username = ""
          if let f = profile.lastName {
            username += f
          }
          
          if let l = profile.firstName {
            username += " \(l)"
          }
          
          OwnerInfo.shared.updateUserName(newusername: username)
          OwnerInfo.shared.updateLoginType(newLoginType: .Facebook)
          OwnerInfo.shared.updateUserId(newUserId: profile.userID)
          DataBaseService.shared.updateAvatarForUser(userid: OwnerInfo.shared.userId, newAvatarUrl: OwnerInfo.shared.avatarUrl ?? "", completion: nil)
          //completion?()
        }
      }
    }
    else {
      //completion?()
    }
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

extension LoginViewController: UITextFieldDelegate {
  
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
    guard let text = textField.text else {
      return false
    }
    
    let oldLength = text.count
    let replacementLength = string.count
    let rangeLength = range.length;
    let newLength = oldLength - rangeLength + replacementLength
    let returnkey = string.range(of: "\n")?.lowerBound != nil
    
    return newLength <= MAX_USERNAME_LENGTH || returnkey;
  }
}
