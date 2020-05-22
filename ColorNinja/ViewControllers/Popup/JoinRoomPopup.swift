//
//  JoinRoomPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/21/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class JoinRoomPopup: PopupViewController {
    
    private var goButton: UIButton!
    private var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override var contentSize: CGSize {
        return CGSize(width: 200, height: 200)
    }
    
    override var cornerRadius: CGFloat {
        return 20
    }
    
    private func setupViews() {
        
        // TextField
        textField = UITextField()
        textField.borderStyle = .roundedRect;
        textField.placeholder = "Enter RoomId";
        textField.autocorrectionType = .no
        textField.keyboardType = .default
        textField.returnKeyType = .done
        textField.clearButtonMode = .whileEditing
        textField.contentVerticalAlignment = .center
        textField.textAlignment = .center
        contentView.addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(60)
        }
        
        // GoButton
        goButton = UIButton()
        goButton.setTitle("GO", for: .normal)
        goButton.backgroundColor = .black
        goButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        goButton.layer.cornerRadius = 13
        goButton.makeShadow()
        contentView.addSubview(goButton)
        goButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.width.height.centerX.equalTo(textField)
        }
        goButton.addTarget(self, action: #selector(didTapGoButton), for: .touchUpInside)

    }
    
    @objc private func didTapGoButton() {
        if let username = textField.text {
            if username != "" {
                
                // Open homeVC
                let homeVC = RoomGameViewController()
                homeVC.roomId = textField.text!.toInt()
                homeVC.modalPresentationStyle = .fullScreen
                self.present(homeVC, animated: false, completion: nil)
            } else {
                let alert = UIAlertController(title: "Warning", message: "Please input Room Id! Thanks!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
}
