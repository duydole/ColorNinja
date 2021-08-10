//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/19/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import SafariServices
import FBSDKLoginKit
import FirebaseAuth
import Firebase
import GoogleSignIn
import JGProgressHUD

let MAX_USERNAME_LENGTH: Int = 20

///
/// FEATURE
///
/// - Login with Facebook
/// - Login with Google
/// - Login with RegistedAccount
/// - Create new account

class LoginViewController: UIViewController {
    
    struct Constants {
        static let cornerRadius: CGFloat = 8.0
        static let minPasswordLength: Int = 8
    }
    
    // MARK: Private Properties
    
    private var headerView: UIView!
    private var backgroundImageView: UIImageView!
    private var logoImageView: UIImageView!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var loginButton: UIButton!
    private var termsButton: UIButton!
    private var privacyButton: UIButton!
    private var createAccountButton: UIButton!
    private var facebookLoginButton: FBLoginButton!
    private var googleLoginButton: GIDSignInButton!
    
    private var spinner: JGProgressHUD!

    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        layoutSubViews()
    }
    
    // MARK: Setup Views + Layout
    
    private func setupViews() {
        
        /// View
        view.backgroundColor = .systemBackground
        
        /// HeaderView
        headerView = UIView()
        headerView.clipsToBounds = true
        view.addSubview(headerView)
        
        /// BgImageView
        backgroundImageView = UIImageView(image: UIImage(named: "bggradient"))
        headerView.addSubview(backgroundImageView)
        
        /// LogoImageView
        logoImageView = UIImageView(image:UIImage(named: "logo")?.withRenderingMode(.alwaysTemplate))
        logoImageView.tintColor = .white
        logoImageView.contentMode = .scaleAspectFit
        headerView.addSubview(logoImageView)
        
        /// UsernameEmailField
        emailField = UITextField()
        emailField.placeholder = "Username or Email"
        emailField.returnKeyType = .next
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.layer.masksToBounds = true
        emailField.layer.cornerRadius = Constants.cornerRadius
        emailField.backgroundColor = .secondarySystemBackground
        emailField.layer.borderWidth = 0.6
        emailField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailField.delegate = self
        view.addSubview(emailField)
        
        /// PasswordField
        passwordField = UITextField()
        passwordField.isSecureTextEntry = true
        passwordField.placeholder = "Password"
        passwordField.returnKeyType = .continue
        passwordField.leftViewMode = .always
        passwordField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        passwordField.autocapitalizationType = .none
        passwordField.autocorrectionType = .no
        passwordField.layer.masksToBounds = true
        passwordField.layer.cornerRadius = Constants.cornerRadius
        passwordField.backgroundColor = .secondarySystemBackground
        passwordField.layer.borderWidth = 0.6
        passwordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordField.delegate = self
        view.addSubview(passwordField)
        
        /// Create Account Button
        createAccountButton = UIButton()
        createAccountButton.setTitleColor(.label, for: .normal)
        createAccountButton.setTitle("New User? Create an Account", for: .normal)
        createAccountButton.addTarget(self, action: #selector(didTapCreateAccountButton), for: .touchUpInside)
        view.addSubview(createAccountButton)
        
        /// Login Button
        loginButton = UIButton()
        loginButton.setTitle("Log In", for: .normal)
        loginButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = Constants.cornerRadius
        loginButton.backgroundColor = .systemBlue
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        view.addSubview(loginButton)
        
        /// LoginWithFacebook
        facebookLoginButton = FBLoginButton()
        facebookLoginButton.delegate = self
        facebookLoginButton.permissions = ["email","public_profile"]
        view.addSubview(facebookLoginButton)

        /// LoginWithGoogle
        googleLoginButton = GIDSignInButton()
        googleLoginButton.style = .wide
        googleLoginButton.addTarget(self, action: #selector(didTapLoginWithGoogleButton), for: .touchUpInside)
        view.addSubview(googleLoginButton)

        /// Terms Button
        termsButton = UIButton()
        termsButton.setTitle("Terms of Service", for: .normal)
        termsButton.setTitleColor(.secondaryLabel, for: .normal)
        termsButton.addTarget(self, action: #selector(didTapTermsButton), for: .touchUpInside)
        view.addSubview(termsButton)
        
        /// Privacy Button
        privacyButton = UIButton()
        privacyButton.setTitle("Privacy Policy", for: .normal)
        privacyButton.setTitleColor(.secondaryLabel, for: .normal)
        privacyButton.addTarget(self, action: #selector(didTapPrivacyButton), for: .touchUpInside)
        view.addSubview(privacyButton)
        
        /// Indicator
        /// @note: We do not add spinner to view
        spinner = JGProgressHUD(style: .dark)
    }
    
    private func layoutSubViews() {
        
        /// HeaderView
        headerView.frame = CGRect(
            x: 0,
            y: 0,
            width: view.width,
            height: view.height/3)
        
        /// BackgroundImageView
        backgroundImageView.frame = headerView.bounds
        
        /// Logo
        logoImageView.frame = CGRect(
            x: headerView.width/4.0,
            y: view.safeAreaInsets.top,
            width: headerView.width/2.0,
            height: headerView.height - view.safeAreaInsets.top)
        
        /// UsernameEmailField
        let paddingLeft: CGFloat = 25.0
        let fieldHeight: CGFloat = 52.0
        let spacing: CGFloat = 10.0
        
        emailField.frame = CGRect(
            x: paddingLeft,
            y: headerView.bottom + 40,
            width: view.width - 2*paddingLeft,
            height: fieldHeight)
        
        /// PasswordField
        passwordField.frame = CGRect(
            x: paddingLeft,
            y: emailField.bottom + spacing,
            width: view.width - 2*paddingLeft,
            height: fieldHeight)
        
        /// LoginButton
        loginButton.frame = CGRect(
            x: paddingLeft,
            y: passwordField.bottom + spacing,
            width: view.width - paddingLeft*2,
            height: fieldHeight)
        
        /// LoginWtihFacebook
        facebookLoginButton.frame = CGRect(x: paddingLeft,
                                     y: loginButton.bottom + spacing,
                                     width: view.width - paddingLeft*2,
                                     height: fieldHeight)
        
        /// GoogleLoginButton
        googleLoginButton.frame = CGRect(x: paddingLeft,
                                         y: facebookLoginButton.bottom + spacing,
                                         width: view.width - paddingLeft*2,
                                         height: fieldHeight)
        
        /// CreateAccount Button
        createAccountButton.frame = CGRect(
            x: paddingLeft,
            y: googleLoginButton.bottom + spacing,
            width: view.width - paddingLeft*2,
            height: fieldHeight)
        
        /// PrivacyButton
        let privacyHeight: CGFloat = 50.0
        privacyButton.frame = CGRect(
            x: paddingLeft,
            y: view.height - view.safeAreaInsets.bottom - privacyHeight,
            width: view.width - paddingLeft*2,
            height: privacyHeight)
        
        /// TermsButton
        termsButton.frame = CGRect(
            x: paddingLeft,
            y: privacyButton.top - privacyHeight,
            width: view.width - paddingLeft*2,
            height: privacyHeight)
    }
    
    // MARK: Actions
    
    @objc private func didTapLoginButton() {
        
        /// Hide keyboard
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
        
        /// Check valid email/password
        guard let email = emailField.text, email.isEmpty == false, email.contains(".") == true, email.contains("@"),
              let password = passwordField.text, password.isEmpty == false, password.count >= Constants.minPasswordLength else {
            
            ErrorPresenter.shared.showError(on: self, title: "Login Error", message: "Invalid username or password")
            return
        }
    
        /// StartLoading
        spinner.show(in: view)
        
        /// Login
        AuthManager.shared.logInUserWith(email: email, password: password) { [weak self] success, error in
            DispatchQueue.main.async {
                
                /// StopLoading
                self?.spinner.dismiss()
                
                if success {
                    
                    /// Dismiss to show HomeViewController
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    
                    /// Show error when login failed
                    ErrorPresenter.shared.showError(on: self, title: "Login Error", message: "\(String(describing: error))")
                }
            }
        }
    }
    
    @objc private func didTapTermsButton() {
        guard let url = URL(string: "https://www.instagram.com/about/legal/terms/before-january-19-2013/") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    @objc private func didTapPrivacyButton() {
        guard let url = URL(string: "https://help.instagram.com/519522125107875") else {
            return
        }
        let vc = SFSafariViewController(url: url)
        present(vc,animated: true)
    }
    
    @objc private func didTapCreateAccountButton() {
        let vc = RegistrationViewController()
        vc.title = "Create Account"
        vc.delegate = self
        
        present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    @objc private func didTapLoginWithGoogleButton() {
        /// Start loading
        spinner.show(in: view)

        /// Start Login
        GoogleSignInManager.shared.signInWithPresenting(viewController: self) { [weak self] user, error in
            DispatchQueue.main.async {
                
                /// Login with Google failed
                guard error == nil else {
                    self?.spinner.dismiss()
                    self?.showError(error: error)
                    return
                }
                
                /// Check token
                guard let authentication = user?.authentication,
                      let idToken = authentication.idToken else {
                    self?.spinner.dismiss()
                    self?.showError(error: nil)
                    return
                }
                
                /// Insert to Database newuser with info of Google
                let avatarUrl = user?.profile?.imageURL(withDimension: 200)
                let email = user?.profile?.email
                let firstName = user?.profile?.familyName
                let lastName = user?.profile?.givenName
                if let email = email {
                    
                    /// Insert newUser to Database
                    let newUser = UserModel(firstName: firstName ?? "", lastName: lastName ?? "", email: email, avatarURL: avatarUrl)
                    DatabaseManager.shared.insertNewUserIfNotExisted(user: newUser) { success, error in
                        guard error == nil else {
                            return
                        }
                        
                        if let url = avatarUrl {
                            /// Download Image and then Upload to Storage
                            StorageManager.shared.downloadImageFromUrlAndUpload(url: url.absoluteString, savedFileName: newUser.avatarFileName, completion: nil)
                        }
                    }
                    
                    /// Update UserDefaults
                    UserDefaultManager.shared.updateWhenRegisteredNewUser(newUser)
                }
                
                /// Create credential and SignIn
                let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: authentication.accessToken)
                Auth.auth().signIn(with: credential) { [weak self] authResult, error in
                    self?.spinner.dismiss()
                    
                    /// Login with Credential failed
                    guard authResult != nil, error == nil else {
                        self?.showError(error: error)
                        return
                    }
                    
                    /// Login Success
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
    
    
    private func showError(error: Error?) {
        ErrorPresenter.shared.showError(on: self, message: "\(String(describing: error))")
    }
}

// MARK: UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        
        if textField == passwordField {
            didTapLoginButton()
        }
        
        return true
    }
}

// MARK: RegistrationViewController Delegate

extension LoginViewController: RegistrationViewControllerDelegate {
    
    func didRegisterNewUserSuccess(email: String, password: String) {
        emailField.text = email
        passwordField.text = password
        didTapLoginButton()
    }
}

// MARK: LoginWithFacebook Delegate

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        
        /// Start loading
        spinner.show(in: view)
        
        guard let token = result?.token?.tokenString else {
            /// Login with facebook failed
            spinner.dismiss()
            ErrorPresenter.shared.showError(on: self, message: "\(String(describing: error))")
             return
        }
        
        let requestFields = ["fields":"email, first_name, last_name, picture.type(large)"]
        FBLoginKitManager.shared.requestDataWith(token: token, fields: requestFields) { [weak self] result, error in
            
            guard let result = result, error == nil else {
                /// Request failed
                self?.spinner.dismiss()
                ErrorPresenter.shared.showError(on: self, message: "\(String(describing: error))")
                return
            }
            
            guard let firstName = result["first_name"] as? String,
                  let lastName = result["last_name"] as? String,
                  let _ = result["id"] as? String,
                  let email = result["email"] as? String,
                  let picture = result["picture"] as? [String:Any],
                  let data = picture["data"] as? [String:Any],
                  let avatarUrl = data["url"] as? String else {
                ErrorPresenter.shared.showError(on: self, message: "Parse Failed")
                self?.spinner.dismiss()
                return
            }
            
            /// Insert to Database newuser with info of facebook
            let newUser = UserModel(firstName: firstName, lastName: lastName, email: email, avatarURL: URL(string: avatarUrl))
            DatabaseManager.shared.insertNewUserIfNotExisted(user: newUser) { success, error in
                guard error == nil else {
                    return
                }
                
                /// Download Image and then Upload to Storage
                StorageManager.shared.downloadImageFromUrlAndUpload(url: avatarUrl, savedFileName: newUser.avatarFileName, completion: nil)
            }
            
            /// Update UserDefaults
            UserDefaultManager.shared.updateWhenRegisteredNewUser(newUser)
            
            /// Start login with facebook token
            /// <Login> = <FacebookToken> + <FirebaseLoginFacebook>
            let credential = FacebookAuthProvider.credential(withAccessToken: token)
            AuthManager.shared.loginWithToken(credential: credential) { [weak self] success, error in
                self?.spinner.dismiss()
                
                if success {
                    self?.dismiss(animated: true, completion: nil)
                } else {
                    ErrorPresenter.shared.showError(on: self, message: "\(String(describing: error))")
                }
            }
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        // Do nothing
    }
}
