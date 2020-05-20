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
    
    var exitButton : UIButton!
    var textField: UITextField!
    var goButton: UIButton!
    var container: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        setupViews()
    }
    
    func setupViews() {
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
            make.height.equalTo(200)
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
            make.width.equalToSuperview()
            make.height.equalTo(55)
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
            make.height.equalTo(52)
            make.width.equalToSuperview()
        }
        goButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
    }
    
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func didTapGoButton() {
        if let username = textField.text {
            if username != "" {
            let multiPlayerVC = MultiPlayerViewController()
            multiPlayerVC.player1.name = username
            multiPlayerVC.modalPresentationStyle = .fullScreen
            self.present(multiPlayerVC, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Please input your username! Thanks!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    switch action.style {
                    case .default:
                        print("default")
                        
                    case .cancel:
                        print("cancel")
                        
                    case .destructive:
                        print("destructive")
                        
                    default:
                        print("duydl: Default style")
                        
                    }}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}
