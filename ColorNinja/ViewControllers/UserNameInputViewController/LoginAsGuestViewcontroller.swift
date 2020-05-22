//
//  CreateRoomViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class LoginAsGuestViewcontroller: UIViewController {
    
    private var exitButton : UIButton!
    private var textField: UITextField!
    private var goButton: UIButton!
    private var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        setupViews()
    }
    
    private func setupViews() {
        setupExitButton()
        setupContainer()
        setupTextField()
        setupGoButton()
    }
    
    private func setupContainer() {
        container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.height.equalTo(120)
            make.center.equalToSuperview()
        }
    }
    
    private func setupExitButton() {
        exitButton = UIButton()
        view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        exitButton.imageView?.tintColor = .white
        exitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(30)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.trailing.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    private func setupTextField() {
        textField = UITextField()
        textField.borderStyle = .roundedRect;
        textField.placeholder = "Enter username";
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        
        container.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.width.centerX.top.equalToSuperview()
            make.height.equalTo(60)
        }
    }
    
    private func setupGoButton() {
        goButton = UIButton()
        goButton.setTitle("GO", for: .normal)
        goButton.backgroundColor = .black
        goButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        goButton.layer.cornerRadius = 13
        goButton.makeShadow()
        container.addSubview(goButton)
        goButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.height.centerX.equalTo(textField)
        }
        goButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
    }
    
    // MARK: Handle events
    
    @objc private func didTapExitButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func didTapGoButton() {
        
        guard let username = textField.text else {
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
    
    private func isValidUsername(userName: String) -> Bool {
        return true
    }
    
    private func showAlertWithMessage(message: String) {
        let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
}
