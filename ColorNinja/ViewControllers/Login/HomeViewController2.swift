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

class HomeViewController2: BaseHomeViewController {
    
    private var singlePlayerButton: UIButton!
    private var multiPlayerButton: UIButton!
    private var bestScoreLabel: UILabel!
    private var stackView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        bestScoreLabel.text = "Your best score is \(OwnerInfo.shared.getMaxScore())"
    }
    
    // MARK: Setup views
    
    override func setupViews() {
        super.setupViews()
        
        add1PlayerButton()
        add2PlayerButton()
        addBestScoreLabel()
    }
        
    private func add1PlayerButton() {
        singlePlayerButton = UIButton()
        singlePlayerButton.setTitle("1 Player", for: .normal)
        singlePlayerButton.backgroundColor = .black
        singlePlayerButton.titleLabel!.font = UIFont(name: Font.squirk, size: scaledValue(30))
        singlePlayerButton.layer.cornerRadius = 13
        singlePlayerButton.makeShadow()
        midContainer.addSubview(singlePlayerButton)
        singlePlayerButton.snp.makeConstraints { (make) in
            make.top.equalTo(scaledValue(50))
            make.centerX.equalToSuperview()
            make.width.equalTo(scaledValue(227))
            make.height.equalTo(scaledValue(52))
        }
        
        singlePlayerButton.addTarget(self, action: #selector(didTapSinglePlayerButton), for: .touchUpInside)
    }

    private func add2PlayerButton() {
        multiPlayerButton = UIButton()
        multiPlayerButton.setTitle("2 Player", for: .normal)
        multiPlayerButton.backgroundColor = .black
        multiPlayerButton.titleLabel!.font = UIFont(name: Font.squirk, size: scaledValue(30))
        multiPlayerButton.layer.cornerRadius = 13
        multiPlayerButton.makeShadow()
        midContainer.addSubview(multiPlayerButton)
        multiPlayerButton.snp.makeConstraints { (make) in
            make.width.height.centerX.equalTo(singlePlayerButton)
            make.top.equalTo(singlePlayerButton.snp.bottom).offset(scaledValue(20))
        }
        
        multiPlayerButton.addTarget(self, action: #selector(didTapMultiPlayerButton), for: .touchUpInside)
    }
    
    private func addBestScoreLabel() {
        bestScoreLabel = UILabel()
        bestScoreLabel.text = "Your best score is \(OwnerInfo.shared.getMaxScore())"
        bestScoreLabel.textAlignment = NSTextAlignment.center
        bestScoreLabel.font = UIFont(name: Font.squirk, size: scaledValue(30))
        bestScoreLabel.textColor = .white
        midContainer.addSubview(bestScoreLabel)
        bestScoreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(multiPlayerButton.snp.bottom).offset(scaledValue(20))
            make.centerX.equalToSuperview()
        }
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
        let vc = CreateRoomViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
}
