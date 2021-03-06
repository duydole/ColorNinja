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
import SnapKit
import AuthenticationServices

let MAX_USERNAME_LENGTH: Int = 20

class LoginViewController: UIViewController {
  
  private var stackView: UIStackView!
  private var sloganLabel: UILabel!
  private var usernameTextField: UITextField!
  private var loginWithZaloButton: ButtonWithImage!
  private var loginWithFBButton: UIButton!
  private var appleButton: UIButton!
  #if DISABLE_LOGIN_FB
  private var loginAsGuestButton: UIButton!
  #else
  private var loginAsGuestButton: ButtonWithImage!
  #endif
  
  // MARK: Life Cycle
  
  override func loadView() {
    super.loadView()
    setupViews()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: Setup Views
  
  private func setupViews() {
    setupViewController()
    setupLoginMethodView()
  }
  
  private func setupViewController() {
    let gradientView = GradientView()
    gradientView.topColor = ColorRGB(110, 24, 19)
    gradientView.bottomColor = ColorRGB(30, 30, 30)
    gradientView.startPointX = 0
    gradientView.startPointY = 0
    gradientView.endPointX = 1
    gradientView.endPointY = 1
    view.addSubview(gradientView)
    gradientView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  private func setupLoginMethodView() {
    
    sloganLabel = UILabel()
    sloganLabel.font = UIFont(name: Font.squirk, size: 34)
    sloganLabel.text = "Color Ninja"
    sloganLabel.textColor = .white
    view.addSubview(sloganLabel)
    sloganLabel.snp.makeConstraints { (make) in
      make.top.equalToSuperview().offset(UIScreen.main.bounds.height / 5)
      make.centerX.equalToSuperview()
    }
    
    #if ENABLE_LOGIN_FB_APPLE /// khi nào enable feature login wtih fb, apple thì thêm cờ này vào  BuildSettings là được
    var stackViewHeight = 48 * 2 + 16
    if #available(iOS 13.0, *) {
      stackViewHeight = 44 * 3 + 16 * 2
    }
    #else
    let stackViewHeight = 44
    #endif
    
    stackView = UIStackView()
    stackView.axis = .vertical
    stackView.distribution = .fillEqually
    stackView.spacing = 16.0
    self.view.addSubview(stackView)
    
    #if ENABLE_LOGIN_FB_APPLE
    stackView.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.bottom.equalToSuperview().inset(54 + safeAreaBottom())
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(stackViewHeight)
    }
    #else
    stackView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.equalToSuperview().multipliedBy(0.8)
      make.height.equalTo(stackViewHeight)
    }
    #endif
    
    loginWithFBButton = UIButton()
    loginWithFBButton.addTarget(self, action: #selector(didTapLoginWithFacebookButton), for: .touchUpInside)
    let fbText = "Login with Facebook"
    let fbTextRange = NSMakeRange(0, fbText.count)
    let attributedFbText = NSMutableAttributedString(string: fbText)
    attributedFbText.addAttribute(.foregroundColor, value: UIColor.white, range: fbTextRange)
    attributedFbText.addAttribute(.font, value: UIFont.systemFont(ofSize: 12, weight: .bold) , range: fbTextRange)
    loginWithFBButton.setAttributedTitle(attributedFbText, for: .normal)
    loginWithFBButton.backgroundColor = ColorRGB(62, 88, 144)
    loginWithFBButton.layer.cornerRadius = 8
    loginWithFBButton.clipsToBounds = true
    
    let imageView = UIImageView()
    imageView.image = UIImage(named: "fblogo")
    imageView.isUserInteractionEnabled = false
    loginWithFBButton.addSubview(imageView)
    
    imageView.snp.makeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }
    #if ENABLE_LOGIN_FB_APPLE /// khi nào muốn enable thì thêm cờ này vào config
    stackView.addArrangedSubview(loginWithFBButton)
    #endif
    
    if #available(iOS 13.0, *) {
      appleButton = UIButton()
      appleButton.addTarget(self, action: #selector(didTapAppleButton(_:)), for: .touchUpInside)
      appleButton.setTitle("Sign in with Apple", for: .normal)
      appleButton.backgroundColor = UIColor.white
      appleButton.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .bold)
      appleButton.setTitleColor(UIColor.black, for: .normal)
      appleButton.layer.cornerRadius = 8
      appleButton.contentHorizontalAlignment = .center
      appleButton.clipsToBounds = true
      
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.image = UIImage(named: "ic_apple")
      imageView.isUserInteractionEnabled = false
      appleButton.addSubview(imageView)
      
      imageView.snp.makeConstraints { (make) in
        make.centerY.equalToSuperview()
        make.leading.equalToSuperview().inset(12)
      }
      
      #if ENABLE_LOGIN_FB_APPLE
      self.stackView.addArrangedSubview(self.appleButton)
      #endif
    }
    
    loginAsGuestButton = UIButton()
    let text = "Play as a guest"
    let textRange = NSMakeRange(0, text.count)
    let attributedText = NSMutableAttributedString(string: text)
    attributedText.addAttribute(.foregroundColor, value: ColorRGB(0, 0, 0), range: textRange)
    attributedText.addAttribute(.font, value: UIFont.systemFont(ofSize: 14, weight: .bold), range: textRange)
    loginAsGuestButton.setAttributedTitle(attributedText, for: .normal)
    loginAsGuestButton.addTarget(self, action: #selector(didTapLoginAsGuestButton), for: .touchUpInside)
    loginAsGuestButton.layer.cornerRadius = 8
    loginAsGuestButton.backgroundColor = .white
    
    stackView.addArrangedSubview(loginAsGuestButton)
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
  }
  
  private func showLoginErrorPopup() {
    let alertVC = UIAlertController(title: "Oops!", message: "Something went wrong. Please log back in and try again.", preferredStyle: .alert)
    alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
    present(alertVC, animated: true)
  }
  
  private func registerOwnerInfoAndMoveToHome() {
    DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared) { (success, error) in
      DispatchQueue.main.async {[weak self] in
        if let error = error {
          /// Nếu register user bị lỗi
          if  error.errorType == .DBErrorTypeUserExisted {
            
            /// Case login lại vào account đã register
            print("duydl: Go to HOME, acc này đã login rồi logout. Giờ vô lại nè.")
            self?.openHomeViewController()
          } else {
            
            /// Đeo bao
            self?.showLoginErrorPopup()
          }
        } else {
          self?.openHomeViewController()
        }
      }
    }
  }

  private func openHomeViewController() {
    guard let window = UIApplication.shared.keyWindow else{
      return
    }
    let homeVC = HomeViewController()
    window.rootViewController = homeVC
    
    homeVC.view.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
    UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: {
      homeVC.view.transform = .identity
    }, completion: nil)
  }
  
  private func updateUserInfoFromFacebookProfile(completion: ((Bool)->())?) {
    if let _ = AccessToken.current {
      Profile.loadCurrentProfile { (profile, error) in
        if let profile = profile {
          if let name = profile.name {
            OwnerInfo.shared.updateUserName(newusername: name)
          }
          
          OwnerInfo.shared.updateLoginType(newLoginType: .Facebook)
          DataBaseService.shared.updateAvatarForUser(userid: OwnerInfo.shared.userId, newAvatarUrl: OwnerInfo.shared.avatarUrl ?? "") { (success, error) in
            completion?(success)
          }
        }
      }
    }
  }

  // MARK: Handle Events
  
  @objc private func didTapLoginWithZaloButton() {
    
  }
  
  @objc private func didTapLoginWithFacebookButton() {
    
    let loginManager = LoginManager()
    loginManager.logIn(permissions: ["public_profile"], from: self) {[weak self] (loginResult, error) in
      guard let self = self else {
        return
      }
      guard error == nil, let loginResult = loginResult else {
        self.showLoginErrorPopup()
        return
      }
      
      if !loginResult.isCancelled {
        
        // Update UserInfo
        self.updateUserInfoFromFacebookProfile { (success) in
          // Insert DB:
          self.registerOwnerInfoAndMoveToHome()
        }
      }
    }
  }
  
  @objc private func didTapLoginAsGuestButton() {
    
    let userNameView = UserNameView(buttonTitle: "LET'S GO", placeHolderText: "Your username")
    userNameView.onButtonDidPress = {[weak self] text in
      guard let self = self else {return}
      if let text = text, !text.isEmpty, self.isValidUsername(userName: text) {
        // Save username
        OwnerInfo.shared.updateUserName(newusername: text)
        OwnerInfo.shared.updateLoginType(newLoginType: .Guest)
        
        self.registerOwnerInfoAndMoveToHome()
      } else {
        self.showAlertWithMessage(message: "Please input your username. Thanks.")
      }
    }
    userNameView.present(from: view)
  }
    
  @objc private func didTapAppleButton(_ sender: Any) {
    if #available(iOS 13.0, *) {
      let appleIDProvider = ASAuthorizationAppleIDProvider()
      let request = appleIDProvider.createRequest()
      request.requestedScopes = [.fullName, .email]
      
      let authorizationController = ASAuthorizationController(authorizationRequests: [request])
      authorizationController.delegate = self
      authorizationController.presentationContextProvider = self
      authorizationController.performRequests()
    }
  }
  
  @objc private func dismissKeyboard() {
    usernameTextField.resignFirstResponder()
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

// MARK: UITextFieldDelegate

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

// MARK: ASAuthorizationControllerDelegate

extension LoginViewController: ASAuthorizationControllerDelegate {
  /// - Tag: did_complete_authorization
  @available(iOS 13.0, *)
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
    
    var loginSuccess = false
    var username: String = ""
    
    switch authorization.credential {
    
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      if let givenName = appleIDCredential.fullName?.givenName {
        username = givenName
        AppleUserInfoStore.setUserDisplayName(for: givenName, name: appleIDCredential.user)
      } else {
        let stringIndex = appleIDCredential.user.index(appleIDCredential.user.startIndex, offsetBy: min(6, appleIDCredential.user.count))
        username = AppleUserInfoStore.getUserDisplayName(for: appleIDCredential.user) ?? String(appleIDCredential.user.prefix(upTo: stringIndex))
      }
      loginSuccess = true
      
    case let passwordCredential as ASPasswordCredential:
      // Sign in using an existing iCloud Keychain credential.
      let stringIndex = passwordCredential.user.index(passwordCredential.user.startIndex, offsetBy: min(6, passwordCredential.user.count))
      username = AppleUserInfoStore.getUserDisplayName(for: passwordCredential.user) ?? String(passwordCredential.user.prefix(upTo: stringIndex))
      
      loginSuccess = true
      
    default:
      break
    }
    
    if loginSuccess {
      OwnerInfo.shared.updateUserName(newusername: username)
      OwnerInfo.shared.updateLoginType(newLoginType: .AppleId)
      DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared) {[weak self] (success, error) in
        /// không cần check userexisted, vô luôn cho lẹ.
        self?.openHomeViewController()
      }
    } else {
      self.showLoginErrorPopup()
    }
  }
  
  /// - Tag: did_complete_error
  @available(iOS 13.0, *)
  public func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
    self.showLoginErrorPopup()
  }
}

// MARK: ASAuthorizationControllerPresentationContextProviding

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  /// - Tag: provide_presentation_anchor
  @available(iOS 13.0, *)
  public func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}
