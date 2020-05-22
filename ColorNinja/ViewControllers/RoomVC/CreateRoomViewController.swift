//
//  CreateRoomViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/21/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class CreateRoomViewController: BaseViewController {
    
    private var randomButton: ButtonWithImage!
    private var newRoomButton: ButtonWithImage!
    private var joinRoomButton: ButtonWithImage!

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Setup views
    
    override func setupViews() {
        super.setupViews()
        setupButtons()
    }
    
    private func setupButtons() {
        let container = UIView()
        view.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.width.equalTo(220)
            make.height.equalTo(260)
            make.center.equalToSuperview()
        }
        
        let buttonHeight: CGFloat = 60
        let spacing: CGFloat = 40
        let buttonPadding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Random
        randomButton = ButtonWithImage()
        randomButton.buttonPadding = buttonPadding
        randomButton.backgroundColor = .white
        randomButton.layer.cornerRadius = 12
        randomButton.titleLabel.text = "RANDOM"
        randomButton.titleLabel.textAlignment = .center
        randomButton.titleLabel.font = UIFont(name: Font.squirk, size: 30)
        randomButton.imageView.image = UIImage(named: "randomicon")
        randomButton.titleLabel.textColor = .black
        randomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapRandomButton))
        randomButton.makeShadow()
        container.addSubview(randomButton)
        randomButton.snp.makeConstraints { (make) in
            make.width.top.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.centerX.equalToSuperview()
        }
        
        // New Room
        newRoomButton = ButtonWithImage()
        newRoomButton.buttonPadding = buttonPadding
        newRoomButton.backgroundColor = .white
        newRoomButton.layer.cornerRadius = 12
        newRoomButton.titleLabel.text = "NEW ROOM"
        newRoomButton.titleLabel.textAlignment = .center
        newRoomButton.titleLabel.font = UIFont(name: Font.squirk, size: 30)
        newRoomButton.imageView.image = UIImage(named: "newroomicon")
        newRoomButton.titleLabel.textColor = .black
        newRoomButton.makeShadow()
        newRoomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapCreateRoomButton))
        container.addSubview(newRoomButton)
        newRoomButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(randomButton)
            make.top.equalTo(randomButton.snp.bottom).offset(spacing)
        }
        
        // Join Room
        joinRoomButton = ButtonWithImage()
        joinRoomButton.buttonPadding = buttonPadding
        joinRoomButton.backgroundColor = .white
        joinRoomButton.layer.cornerRadius = 12
        joinRoomButton.titleLabel.text = "JOIN ROOM"
        joinRoomButton.titleLabel.textAlignment = .center
        joinRoomButton.titleLabel.font = UIFont(name: Font.squirk, size: 30)
        joinRoomButton.imageView.image = UIImage(named: "joinroomicon")
        joinRoomButton.titleLabel.textColor = .black
        joinRoomButton.makeShadow()
        joinRoomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapJoinRoomButton))
        container.addSubview(joinRoomButton)
        joinRoomButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(newRoomButton)
            make.top.equalTo(newRoomButton.snp.bottom).offset(spacing)
        }
    }
    
    // MARK: Handle events
    
    @objc func didTapRandomButton() {
        let vc = MultiPlayerViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @objc func didTapCreateRoomButton() {
        let vc = RoomGameViewController()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    @objc func didTapJoinRoomButton() {
        let popup = JoinRoomPopup()
        popup.tapDarkLayerToDismiss = true
        popup.dismissInterval = 0.2
        popup.delegate = self
        popup.modalPresentationStyle = .overCurrentContext
        self.present(popup, animated: false, completion: nil)
    }
}

extension CreateRoomViewController: JoinRoomPopupDelegate {
    func didDismissWithRoomId(roomId: Int) {
        let homeVC = RoomGameViewController()
        homeVC.roomId = roomId
        homeVC.modalPresentationStyle = .fullScreen
        present(homeVC, animated: false, completion: nil)
    }
}
