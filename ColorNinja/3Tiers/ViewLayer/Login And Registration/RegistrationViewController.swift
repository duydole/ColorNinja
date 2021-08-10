//
//  RegistrationViewController.swift
//  ZDInstagram
//
//  Created by Duy Đỗ on 19/07/2021.
//

import UIKit
import JGProgressHUD

protocol RegistrationViewControllerDelegate: AnyObject {
    func didRegisterNewUserSuccess(email: String, password: String)
}

class RegistrationViewController: UIViewController {

    struct Constants {
        static let cornerRadius: CGFloat = 8.0
    }
    
    private var avatarImageView: UIImageView!
    private var firstNameField: UITextField!
    private var lastNameField: UITextField!
    private var emailField: UITextField!
    private var passwordField: UITextField!
    private var registerButton: UIButton!
    private var spinner: JGProgressHUD!
    
    public weak var delegate: RegistrationViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    // MARK: SetupViews
    
    private func setupViews() {
        
        // View
        view.backgroundColor = .systemBackground
        
        // Avatar
        let avatar = UIImage(systemName: "person.circle")
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapChangeAvatar))
        avatarImageView = UIImageView(image: avatar)
        avatarImageView.contentMode = .scaleAspectFit
        avatarImageView.backgroundColor = .secondarySystemBackground
        avatarImageView.tintColor = .gray
        avatarImageView.layer.masksToBounds = true
        avatarImageView.addGestureRecognizer(tapGesture)
        avatarImageView.isUserInteractionEnabled = true
        avatarImageView.layer.borderWidth = 2.0
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
        view.addSubview(avatarImageView)
        
        firstNameField = UITextField()
        firstNameField.placeholder = "First Name"
        firstNameField.returnKeyType = .continue
        firstNameField.leftViewMode = .always
        firstNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        firstNameField.autocapitalizationType = .none
        firstNameField.autocorrectionType = .no
        firstNameField.layer.masksToBounds = true
        firstNameField.layer.cornerRadius = Constants.cornerRadius
        firstNameField.backgroundColor = .secondarySystemBackground
        firstNameField.layer.borderWidth = 1.0
        firstNameField.layer.borderColor = UIColor.secondaryLabel.cgColor
        firstNameField.delegate = self
        view.addSubview(firstNameField)

        lastNameField = UITextField()
        lastNameField.placeholder = "Last Name"
        lastNameField.returnKeyType = .continue
        lastNameField.leftViewMode = .always
        lastNameField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        lastNameField.autocapitalizationType = .none
        lastNameField.autocorrectionType = .no
        lastNameField.layer.masksToBounds = true
        lastNameField.layer.cornerRadius = Constants.cornerRadius
        lastNameField.backgroundColor = .secondarySystemBackground
        lastNameField.layer.borderWidth = 1.0
        lastNameField.layer.borderColor = UIColor.secondaryLabel.cgColor
        lastNameField.delegate = self
        view.addSubview(lastNameField)

        emailField = UITextField()
        emailField.placeholder = "Email Address"
        emailField.returnKeyType = .continue
        emailField.leftViewMode = .always
        emailField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 0))
        emailField.autocapitalizationType = .none
        emailField.autocorrectionType = .no
        emailField.layer.masksToBounds = true
        emailField.layer.cornerRadius = Constants.cornerRadius
        emailField.backgroundColor = .secondarySystemBackground
        emailField.layer.borderWidth = 1.0
        emailField.layer.borderColor = UIColor.secondaryLabel.cgColor
        emailField.delegate = self
        view.addSubview(emailField)

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
        passwordField.layer.borderWidth = 1.0
        passwordField.layer.borderColor = UIColor.secondaryLabel.cgColor
        passwordField.delegate = self
        view.addSubview(passwordField)

        registerButton = UIButton()
        registerButton.setTitle("Sign Up", for: .normal)
        registerButton.layer.masksToBounds = true
        registerButton.layer.cornerRadius = Constants.cornerRadius
        registerButton.backgroundColor = .systemGreen
        registerButton.setTitleColor(.white, for: .normal)
        registerButton.addTarget(self, action: #selector(didTapRegisterButton), for: .touchUpInside)
        view.addSubview(registerButton)
        
        // Indicator
        spinner = JGProgressHUD(style: .dark)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        /// Avatar
        let avatarPaddingTop: CGFloat = 20
        let avatarWidth: CGFloat = 150
        avatarImageView.frame = CGRect(x: (view.width - avatarWidth)/2,
                                       y: view.safeAreaInsets.top + avatarPaddingTop,
                                       width: avatarWidth,
                                       height: avatarWidth)
        avatarImageView.layer.cornerRadius = avatarWidth/2
        
        /// FirstName
        let paddingTop: CGFloat = 20
        let paddingLeft: CGFloat = 20
        let labelHeight: CGFloat = 52
        firstNameField.frame = CGRect(x: paddingLeft,
                                      y: avatarImageView.bottom + paddingTop,
                                      width: view.width - 2*paddingLeft,
                                      height: labelHeight)
        
        /// LastName
        let spacing: CGFloat = 10
        lastNameField.frame = CGRect(x: paddingLeft,
                                     y: firstNameField.bottom + spacing,
                                     width: view.width - 2*paddingLeft,
                                     height: labelHeight)
        
        /// Email
        emailField.frame = CGRect(x: paddingLeft,
                                  y: lastNameField.bottom + spacing,
                                  width: view.width - 2*paddingLeft,
                                  height: labelHeight)
        
        /// Password
        passwordField.frame = CGRect(x: paddingLeft,
                                     y: emailField.bottom + spacing,
                                     width: view.width - 2*paddingLeft,
                                     height: labelHeight)
        
        /// RegisterButton
        registerButton.frame = CGRect(x: paddingLeft,
                                      y: passwordField.bottom + spacing,
                                      width: view.width - 2*paddingLeft,
                                      height: labelHeight)
    }
    
    // MARK: Actions
    
    @objc private func didTapRegisterButton() {
        
        /// Hide keyboard
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()

        /// Check username/email/password
        guard let firstName = firstNameField.text, firstName.isEmpty == false,
              let lastName = lastNameField.text, lastName.isEmpty == false,
              let email = emailField.text, email.isEmpty == false,
              let password = passwordField.text, password.isEmpty == false, password.count >= 8 else {
            
            ErrorPresenter.shared.showError(on: self, title: "Register Error", message: "Invalid FirstName, LastName, Email or Password")
            return
        }
        
        /// Start loadingIndicator
        spinner.show(in: view)
        
        /// Process Register account
        let newUser = UserModel(firstName: firstName, lastName: lastName, email: email, avatarURL: nil, maxScore: 0)
        AuthManager.shared.registerNewUser(user: newUser, password: password) { [weak self] registered, error in
            DispatchQueue.main.async {
                
                /// Stop Loading
                self?.spinner.dismiss()

                if registered {
                    
                    /// Check to upload avatar
                    self?.uploadSelectedAvatar(filename: newUser.avatarFileName, of: newUser)
                    
                    /// Update UserDefaults
                    UserDefaultManager.shared.updateWhenRegisteredNewUser(newUser)
                    
                    /// Dismiss
                    self?.dismiss(animated: false, completion: nil)
                    self?.delegate?.didRegisterNewUserSuccess(email: email, password: password)
                }
                else {
                    ErrorPresenter.shared.showError(on: self, title: "Register Error", message: "\(String(describing: error))")
                }
            }
        }
    }
    
    private func uploadSelectedAvatar(filename: String, of user: UserModel) {
        guard let image = self.avatarImageView.image,
              let data = image.pngData() else {
            return
        }
        
        /// Upload avatar
        StorageManager.shared.uploadUserAvatar(with: data, fileName: filename) { result in
            switch result {
            case .failure(let error):
                ErrorPresenter.shared.showError(on: self, title: "Upload Avatar Error", message: "\(error)")
            case .success(let urlStr):
                /// Save to UserDefaults
                UserDefaultManager.shared.setString(str: urlStr, forKey: "avatar_url")
                var user = user
                user.avatarURL = URL(string: urlStr)
                DatabaseManager.shared.insertNewUser(user: user, completion: nil)
            }
        }
    }
    
    // MARK: Actions
    
    @objc private func didTapChangeAvatar() {
        presentPhotoActionSheet()
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            lastNameField.becomeFirstResponder()
        }
        else if textField == lastNameField {
            emailField.becomeFirstResponder()
        }
        else if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            didTapRegisterButton()
        }
        
        return true
    }
}

extension RegistrationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)

        let selectedImg = info[UIImagePickerController.InfoKey.editedImage]
        guard let selectedImg = selectedImg as? UIImage else {
            return
        }
        
        avatarImageView.image = selectedImg
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    // MARK: Helper
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile Picture",
                                            message: "How would you like to select a picture?",
                                            preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoPicker()
        }))

        present(actionSheet, animated: true, completion: nil)
    }
    
    func presentPhotoPicker() {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
    
    func presentCamera() {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        
        present(vc, animated: true, completion: nil)
    }
}
