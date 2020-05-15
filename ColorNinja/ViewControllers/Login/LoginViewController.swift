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
    
    let iconImageView: UIImageView = UIImageView()
    let appNameLabel: UILabel = UILabel()
    let startGuestButton: UIButton = UIButton()
    let loginButton: UIButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
        
        self.addAppIconView()
        self.addAppNameLabel()
        self.addStartGuestButton()
        self.addLoginButton()
        
    }
    
    private func addAppIconView() {
        iconImageView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(Constants.HomeScreen.paddingTopOfIcon)
            make.width.height.equalTo(Constants.HomeScreen.iconWidth)
            make.centerX.equalTo(self.view)
        }
    }
    
    private func addAppNameLabel() {
        self.view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.HomeScreen.appNameLabelHeight)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(iconImageView).offset(Constants.HomeScreen.appNameLabelHeight + Constants.HomeScreen.standardPadding)
        }
        
        appNameLabel.text = Constants.HomeScreen.appName
        appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.font = appNameLabel.font.withSize(Constants.HomeScreen.appNameFontSize)
        appNameLabel.textColor = Constants.HomeScreen.appNameColor
    }
    
    private func addStartGuestButton() {
        startGuestButton.setTitle("Guest", for: .normal)
        startGuestButton.backgroundColor = .orange
        startGuestButton.titleLabel!.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        startGuestButton.layer.cornerRadius = 30
        self.view.addSubview(startGuestButton)
        startGuestButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(appNameLabel.snp.bottom).offset(100)
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
        
        startGuestButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    private func addLoginButton() {
        loginButton.setTitle("Login via Zalo", for: .normal)
        loginButton.backgroundColor = .orange
        loginButton.titleLabel!.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        loginButton.layer.cornerRadius = 30
        self.view.addSubview(loginButton)
        loginButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(startGuestButton.snp.bottom).offset(30)
            make.width.equalTo(280)
            make.height.equalTo(60)
        }
        self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: Action handler
    
    @objc private func didTapStartButton() {
        let homeVC = HomeViewController()
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: true, completion: nil)
    }
    
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
//        ZaloSDKApiWrapper.sharedInstance.loadZaloUserProfile()
    }
    
    @objc private func didTapgetfriend() {
        
        //            ZaloSDKApiWrapper.sharedInstance.loadZaloFriend(0, count: 500)
        let feed = ZOFeed(link: "https://www.google.com.vn/", appName: "ColorNinja", message: "message", others: nil)
        ZaloSDKApiWrapper.sharedInstance.shareFeedZalo(feed, andParentVC: self)
    }
    
}


