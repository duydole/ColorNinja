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

    let loginButton: ZButton = ZButton()
    let rankingButton2: ZButton = ZButton()
    let profileButton: ZButton = ZButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.addRankingButton()
        self.addRankingButton2()
        self.addProfileButton()
    }
    

        private func addRankingButton() {
            loginButton.setTitle("Login", for: .normal)
            self.view.addSubview(loginButton)
            loginButton.snp.makeConstraints { (make) in
                make.top.equalTo(100)
                make.centerX.equalToSuperview()
                make.height.equalTo(100);
                make.width.equalTo(200)
            }
            self.loginButton.addTarget(self, action: #selector(didTapLoginButton), for: .touchUpInside)
        }
    
    private func addRankingButton2() {
        rankingButton2.setTitle("share", for: .normal)
        self.view.addSubview(rankingButton2)
        rankingButton2.snp.makeConstraints { (make) in
            make.top.equalTo(300)
            make.centerX.equalToSuperview()
            make.height.equalTo(100);
            make.width.equalTo(200)
        }
        self.rankingButton2.addTarget(self, action: #selector(didTapgetfriend), for: .touchUpInside)
    }
    
    private func addProfileButton() {
        profileButton.setTitle("profile", for: .normal)
        self.view.addSubview(profileButton)
        profileButton.snp.makeConstraints { (make) in
            make.top.equalTo(500)
            make.centerX.equalToSuperview()
            make.height.equalTo(100);
            make.width.equalTo(200)
        }
        self.profileButton.addTarget(self, action: #selector(didTapProfile), for: .touchUpInside)
    }
    
        @objc private func didTapLoginButton() {
            ZaloSDKApiWrapper.sharedInstance.login(withZalo: self, type: ZAZAloSDKAuthenTypeViaZaloAppAndWebView)
        }
    
        @objc private func didTapgetfriend() {
            
//            ZaloSDKApiWrapper.sharedInstance.loadZaloFriend(0, count: 500)
            
            let feed = ZOFeed(link: "https://www.google.com.vn/", appName: "ColorNinja", message: "message", others: nil)
            ZaloSDKApiWrapper.sharedInstance.shareFeedZalo(feed, andParentVC: self)
        }
    
        @objc private func didTapProfile() {
    //        let viewController = RankingViewController()
    //        viewController.modalPresentationStyle = .fullScreen
    //        self.present(viewController, animated: true) {
    //            //
    //        }
            
            ZaloSDKApiWrapper.sharedInstance.loadZaloUserProfile()
        }

}
