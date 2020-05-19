//
//  CreateRoomViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class CreateRoomViewController: BaseHomeViewController {
    
    var exitButton : UIButton!
    var textField: UITextField!
    var goButton: UIButton!
    var createRoomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        
        self.setupExitButton()
        self.setupTextField()
        self.setupGoButton()
    }
    
    private func setupExitButton() {
        exitButton = UIButton()
        self.view.addSubview(exitButton)
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
        //textField.font = [UIFont systemFontOfSize:15];
        textField.placeholder = "Enter username";
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        //textField.delegate = self;
        
        view.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.width.equalTo(200)
            make.height.equalTo(55)
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(60)
        }
    }
    
    private func setupGoButton() {
        goButton = UIButton()
        goButton.setTitle("GO", for: .normal)
        goButton.backgroundColor = .black
        goButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        goButton.layer.cornerRadius = 13
        goButton.makeShadow()
        view.addSubview(goButton)
        goButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.equalTo(100)
            make.height.equalTo(52)
        }
        goButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)
        
        
        createRoomButton = UIButton()
        createRoomButton.setTitle("NEW ROOM", for: .normal)
        createRoomButton.backgroundColor = .black
        createRoomButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        createRoomButton.layer.cornerRadius = 13
        createRoomButton.makeShadow()
        view.addSubview(createRoomButton)
        createRoomButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(goButton.snp.bottom).offset(20)
            make.width.equalTo(150)
            make.height.equalTo(52)
        }
        createRoomButton.addTarget(self, action: #selector(didTapCreateRoom), for: .touchUpInside)
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
    
    @objc private func didTapCreateRoom() {
        if let username = textField.text {
            if username != "" {
            let multiPlayerVC = RoomGameViewController()
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
        }    }
}
