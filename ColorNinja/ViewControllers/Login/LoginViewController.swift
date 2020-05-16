//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import ZaloSDK
import RxSwift

class LoginViewController: UIViewController {
    
    var iconImageView: UIImageView!
    var appNameLabel: UILabel!
    var singlePlayerButton: UIButton!
    var multiPlayerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        
        self.addAppNameLabel()
        self.addAppIconView()
        self.add1PlayerButton()
        self.add2PlayerButton()
    }
    
    private func addAppNameLabel() {
        appNameLabel = UILabel()
        appNameLabel.text = Constants.HomeScreen.appName
        appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.font = UIFont(name: Font.squirk, size: 60)
        appNameLabel.textColor = Constants.HomeScreen.appNameColor
        appNameLabel.makeShadow()
        self.view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(150)
        }
}
    
    private func addAppIconView() {
        iconImageView = UIImageView()
        iconImageView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(appNameLabel.snp.bottom).offset(20)
            make.width.height.equalTo(Constants.HomeScreen.iconWidth)
            make.centerX.equalTo(self.view)
        }
    }
    
    private func add1PlayerButton() {
        singlePlayerButton = UIButton()
        singlePlayerButton.setTitle("1 Player", for: .normal)
        singlePlayerButton.backgroundColor = .black
        singlePlayerButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        singlePlayerButton.layer.cornerRadius = 13
        singlePlayerButton.makeShadow()
        self.view.addSubview(singlePlayerButton)
        singlePlayerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(iconImageView.snp.bottom).offset(100)
            make.width.equalTo(227)
            make.height.equalTo(52)
        }
        
        singlePlayerButton.addTarget(self, action: #selector(didTapSinglePlayerButton), for: .touchUpInside)
    }

    private func add2PlayerButton() {
        multiPlayerButton = UIButton()
        multiPlayerButton.setTitle("2 Player", for: .normal)
        multiPlayerButton.backgroundColor = .black
        multiPlayerButton.titleLabel!.font = UIFont(name: Font.squirk, size: 30)
        multiPlayerButton.layer.cornerRadius = 13
        multiPlayerButton.makeShadow()
        self.view.addSubview(multiPlayerButton)
        multiPlayerButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(singlePlayerButton.snp.bottom).offset(20)
            make.width.equalTo(singlePlayerButton.snp.width)
            make.height.equalTo(52)
        }
        
        multiPlayerButton.addTarget(self, action: #selector(didTapMultiPlayerButton), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Action handler
    
    @objc private func didTapLoginButton() {
        ZaloSDKApiWrapper.sharedInstance.login(withZalo: self, type: ZAZAloSDKAuthenTypeViaZaloAppAndWebView) {  [weak self] (success) in
            if success {
                let homeVC = HomeViewController()
                homeVC.modalPresentationStyle = .fullScreen
                self?.present(homeVC, animated: true, completion: nil)
            } else {
                print("Login failed")
            }
        }
    }
    
    @objc private func didTapProfile() {
        //ZaloSDKApiWrapper.sharedInstance.loadZaloUserProfile()
    }
    
    @objc private func didTapgetfriend() {
        //ZaloSDKApiWrapper.sharedInstance.loadZaloFriend(0, count: 500)
        let feed = ZOFeed(link: "https://www.google.com.vn/", appName: "ColorNinja", message: "message", others: nil)
        ZaloSDKApiWrapper.sharedInstance.shareFeedZalo(feed, andParentVC: self)
    }
    
    @objc private func didTapSinglePlayerButton() {
        let gameVC = SinglePlayerViewController()
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: false, completion: nil)
    }
   
    @objc private func didTapMultiPlayerButton() {
        let multiPlayerVC = MultiPlayerViewController()
        multiPlayerVC.modalPresentationStyle = .fullScreen
        self.present(multiPlayerVC, animated: false, completion: nil)
    }
}
