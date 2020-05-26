//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import ZaloSDK
import GoogleMobileAds


class HomeViewController2: BaseHomeViewController {
    
    private var singlePlayerButton: UIButton!
    private var multiPlayerButton: UIButton!
    private var bestScoreLabel: UILabel!
    private var adBannerView: GADBannerView!
    private var bottomBar: UIView!
    
    // BottomBar
    private var rateUsButton: UIButton!
    private var muteButton: UIButton!
    private var rankingButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
        bestScoreLabel.text = "Your best score is \(OwnerInfo.shared.bestScore)"
    }
    
    // MARK: Setup views
    
    override func setupViews() {
        super.setupViews()
        
        settingMidContainer()
        setupBannerAd()
        setupBottomBar()
    }
    
    private func settingMidContainer() {
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
        bestScoreLabel.text = "Your best score is \(OwnerInfo.shared.bestScore)"
        bestScoreLabel.textAlignment = NSTextAlignment.center
        bestScoreLabel.font = UIFont(name: Font.squirk, size: scaledValue(30))
        bestScoreLabel.textColor = .white
        midContainer.addSubview(bestScoreLabel)
        bestScoreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(multiPlayerButton.snp.bottom).offset(scaledValue(20))
            make.centerX.equalToSuperview()
        }
    }
        
    private func setupBannerAd() {
        adBannerView = GADBannerView()
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBannerView.load(GADRequest())
        view.addSubview(adBannerView)
        
        let padding: CGFloat = 10
        let adHeight: CGFloat = 70
        let bottomPadding = safeAreaBottom() > 0 ? safeAreaBottom() : padding
        adBannerView.snp.makeConstraints { (make) in
            make.trailing.equalTo(scaledValue(-padding))
            make.bottom.equalTo(scaledValue(-bottomPadding))
            make.leading.equalTo(scaledValue(padding))
            make.height.equalTo(scaledValue(adHeight))
        }
    }
    
    // MARK: Setup BottomBar
    
    private func setupBottomBar() {
        
        let buttonSpacing: CGFloat = scaledValue(30)
        let spacingWithAd: CGFloat = scaledValue(20)
        let bottomBarHeight: CGFloat = scaledValue(50)
        
        // Container
        bottomBar = UIView()
        view.addSubview(bottomBar)
        bottomBar.snp.makeConstraints { (make) in
            make.width.centerX.equalTo(adBannerView)
            make.height.equalTo(bottomBarHeight)
            make.bottom.equalTo(adBannerView.snp.top).offset(-spacingWithAd)
        }
        
        
        // RateUs
        rateUsButton = UIButton()
        rateUsButton.setImage(UIImage(named:"staricon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rateUsButton.imageView?.tintColor = .white
        rateUsButton.addTarget(self, action: #selector(didTapRateUsButton), for: .touchUpInside)
        bottomBar.addSubview(rateUsButton)
        rateUsButton.snp.makeConstraints { (make) in
            make.height.equalToSuperview()
            make.width.equalTo(rateUsButton.snp.height)
            make.center.equalToSuperview()
        }
        
        // MuteButton
        muteButton = UIButton()
        muteButton.setImage(UIImage(named:"muteicon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        muteButton.imageView?.tintColor = .white
        muteButton.addTarget(self, action: #selector(didTapMuteButton), for: .touchUpInside)
        bottomBar.addSubview(muteButton)
        muteButton.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(rateUsButton)
            make.trailing.equalTo(rateUsButton.snp.leading).offset(scaledValue(-buttonSpacing))
        }
        
        // RankingButton
        rankingButton = UIButton()
        rankingButton.setImage(UIImage(named:"rankingicon")?.withRenderingMode(.alwaysTemplate), for: .normal)
        rankingButton.imageView?.tintColor = .white
        rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
        bottomBar.addSubview(rankingButton)
        rankingButton.snp.makeConstraints { (make) in
            make.centerY.width.height.equalTo(rateUsButton)
            make.leading.equalTo(rateUsButton.snp.trailing).offset(scaledValue(buttonSpacing))
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
    
    @objc private func didTapRateUsButton() {
        
    }
    
    @objc private func didTapMuteButton() {
        
    }
    
    @objc private func didTapRankingButton() {
        let rankingVC = RankingViewController()
        rankingVC.modalPresentationStyle = .fullScreen
        present(rankingVC, animated: true, completion: nil)
    }
}
