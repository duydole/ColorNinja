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

let MAX_USERNAME_LENGTH: Int = 20

class LoginViewController: UIViewController {
  
  private var usernameTextField: UITextField!
  private var loginWithZaloButton: ButtonWithImage!
    private var loginWithFBButton: UIButton!
  #if DISABLE_LOGIN_FB
  private var loginAsGuestButton: UIButton!
  #else
  //private var loginWithFBButton: FBLoginButton!
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
    //let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    //view.addGestureRecognizer(tap)
  }
    
    private func setupLoginMethodView() {
        let containerView = UIView()
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
        loginWithFBButton = UIButton()
        loginWithFBButton.addTarget(self, action: #selector(didTapLoginWithFacebookButton), for: .touchUpInside)
        let fbText = "Login with Facebook"
        let fbTextRange = NSMakeRange(0, fbText.count)
        let attributedFbText = NSMutableAttributedString(string: fbText)
        attributedFbText.addAttribute(.foregroundColor, value: UIColor.white, range: fbTextRange)
        attributedFbText.addAttribute(.font, value: UIFont(name: Font.squirk, size: 12) ?? UIFont.systemFont(ofSize: 16), range: fbTextRange)
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
        
        
        containerView.addSubview(loginWithFBButton)
        loginWithFBButton.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(48)
        }
        
        loginAsGuestButton = UIButton()
        let text = "Play as a guest"
        let textRange = NSMakeRange(0, text.count)
        let attributedText = NSMutableAttributedString(string: text)
        attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
        attributedText.addAttribute(.foregroundColor, value: ColorRGB(62, 88, 144), range: textRange)
        attributedText.addAttribute(.font, value: UIFont(name: Font.squirk, size: 12) ?? UIFont.systemFont(ofSize: 16), range: textRange)
        loginAsGuestButton.setAttributedTitle(attributedText, for: .normal)
        loginAsGuestButton.addTarget(self, action: #selector(didTapLoginAsGuestButton), for: .touchUpInside)
        loginAsGuestButton.layer.cornerRadius = 8
        loginAsGuestButton.backgroundColor = .white
        containerView.addSubview(loginAsGuestButton)
        loginAsGuestButton.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(48)
            make.top.equalTo(loginWithFBButton.snp.bottom).offset(16)
        }
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
    
    private func showLoginErrorPopup() {
        let alertVC = UIAlertController(title: "Oops!", message: "Something went wrong. Please log back in and try again.", preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        present(alertVC, animated: true)
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
  }
  
  @objc private func didTapLoginAsGuestButton() {
    
    let userNameView = UserNameView(buttonTitle: "LET'S GO", placeHolderText: "Your username")
    userNameView.onButtonDidPress = {[weak self] text in
        guard let self = self else {return}
        if let text = text, !text.isEmpty, self.isValidUsername(userName: text) {
            // Save username
            OwnerInfo.shared.updateUserName(newusername: text)
            OwnerInfo.shared.updateLoginType(newLoginType: .Guest)
            
            // Insert DB:
            DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared) { (success, error) in
                DispatchQueue.main.async {[weak self] in
                    if success {
                        self?.openHomeViewController()
                    } else {
                        self?.showLoginErrorPopup()
                    }
                }
            }
        } else {
            self.showAlertWithMessage(message: "Please input your username. Thanks.")
        }
    }
    userNameView.present(from: view)
  }
  
  @objc private func dismissKeyboard() {
    usernameTextField.resignFirstResponder()
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
  
  private func updateUserInfoFromFacebookProfile() {
    if let _ = AccessToken.current {
      Profile.loadCurrentProfile { (profile, error) in
        if let profile = profile {
            if let name = profile.name {
                OwnerInfo.shared.updateUserName(newusername: name)
            }
            
            OwnerInfo.shared.updateLoginType(newLoginType: .Facebook)
            OwnerInfo.shared.updateUserId(newUserId: profile.userID)
            DataBaseService.shared.updateAvatarForUser(userid: OwnerInfo.shared.userId, newAvatarUrl: OwnerInfo.shared.avatarUrl ?? "", completion: nil)
        }
      }
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


class UserNameView: UIView {
    var buttonTitle: String? {
        didSet {
            if let buttonTitle = buttonTitle {
                let textRange = NSMakeRange(0, buttonTitle.count)
                let attributedText = NSMutableAttributedString(string: buttonTitle)
                attributedText.addAttribute(NSAttributedString.Key.underlineStyle , value: NSUnderlineStyle.single.rawValue, range: textRange)
                attributedText.addAttribute(.foregroundColor, value: UIColor.white, range: textRange)
                attributedText.addAttribute(.font, value: UIFont(name: Font.squirk, size: 12) ?? UIFont.systemFont(ofSize: 16), range: textRange)
                button.setAttributedTitle(attributedText, for: .normal)
            } else {
                button.setAttributedTitle(nil, for: .normal)
            }
        }
    }

    var placeHolderText: String? {
        didSet {
            textField.placeholder = placeHolderText
        }
    }

    var text: String? {
        didSet {
            textField.text = text
        }
    }

    var onButtonDidPress: ((String?) -> ())?

    private var button: UIButton!
    private var textField: UITextField!
    private var containerView: UIView!
    private var bottomLine: CALayer!
    
    private var containerViewBottomConstraint: Constraint!

    convenience init(buttonTitle: String? = nil,
                     placeHolderText: String? = nil,
                     text: String? = nil,
                     onButtonDidPress: ((String?) -> ())? = nil) {
        self.init()
        self.buttonTitle = buttonTitle
        self.placeHolderText = placeHolderText
        self.text = text
        self.onButtonDidPress = onButtonDidPress
        self.commonInit()
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapOutSide(_:))))
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        bottomLine.frame = CGRect(x: 0, y: bottomLine.superlayer?.bounds.height ?? 0, width: bottomLine.superlayer?.bounds.width ?? 0, height: 0.7)
    }

    func commonInit() {
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)

        containerView = UIView()
        containerView.backgroundColor = .white
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 16
        //containerView.transform = CGAffineTransform(translationX: 0, y: 400)
        addSubview(containerView)

        containerView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
            containerViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        bottomLine = CALayer()
        bottomLine.backgroundColor = UIColor.gray.cgColor
        
        textField = UITextField()
        textField.placeholder = placeHolderText
        textField.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        textField.borderStyle = .none
        textField.textAlignment = .center
        textField.returnKeyType = .done
        textField.layer.addSublayer(bottomLine)
        containerView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(48)
            make.left.right.equalToSuperview().inset(16)
        }
        
        
        button = UIButton()
        button.titleLabel?.font = UIFont(name: Font.squirk, size: 16)
        button.clipsToBounds = true
        button.layer.cornerRadius = 16
        button.backgroundColor = UIColor.black
        button.setTitle(buttonTitle, for: .normal)
        button.addTarget(self, action: #selector(handlePrimaryButton), for: .touchUpInside)
        containerView.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(48)
            make.centerX.equalToSuperview()
            make.width.equalTo(128)
            make.height.equalTo(48)
            make.bottom.equalToSuperview().inset(16)
        }
    }

    @objc private func handlePrimaryButton() {
        onButtonDidPress?(textField.text)
    }
    
    @objc private func handleTapOutSide(_ gesture: UITapGestureRecognizer) {
        if !containerView.frame.contains(gesture.location(in: self)) {
            dismiss()
        }
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue,
            let animationDuration: Double = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
            else { return }
        
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        UIView.animate(withDuration: animationDuration, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: [], animations: { [weak self] in
            guard let self = self else {return}
            self.containerViewBottomConstraint.update(inset: keyboardHeight + 16)
            self.layoutIfNeeded()
        }, completion: nil)
    }

    func present(from parentView: UIView) {
        self.frame = parentView.bounds
        parentView.addSubview(self)
        layoutIfNeeded()
        textField.becomeFirstResponder()
    }

    func dismiss() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
        guard let self = self else {return}
        self.containerView.transform = CGAffineTransform(translationX: 0, y: 400)
        self.alpha = 0
        }) {[weak self] (_) in
            self?.removeFromSuperview()
        }
        textField.resignFirstResponder()
    }
}
