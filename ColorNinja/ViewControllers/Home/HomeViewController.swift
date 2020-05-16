//
//  ViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import SnapKit
import GoogleMobileAds

class HomeViewController: BaseViewController {
    
    let avatarView: UIImageView = UIImageView()
    let nameLabel: UILabel = UILabel()
    let startButton: ZButton = ZButton()
    let start2PButton: ZButton = ZButton()
    let rankingButton: ZButton = ZButton()
    var adBannerView: GADBannerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        self.loadData()
    }
    
    // MARK: Setup views
    
    override func setupViews() {
        super.setupViews()
        
        self.setupBackgroundImage()
        self.addAvatarView()
        self.addNameLabel()
        self.addStartButton()
        self.addStart2PlayersButton()
        self.addRankingButton()
        #if !DEBUG
        self.setupBannerAd()
        #endif
    }
    
    private func setupBackgroundImage() {
        //let bgImageView : UIImageView = UIImageView(frame: self.view.bounds)
        //bgImageView.image = UIImage(named: "bg")
        //self.view.addSubview(bgImageView)
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
    }
    
    private func addAvatarView() {
        avatarView.layer.cornerRadius = Constants.HomeScreen.avatarWidth/2
        avatarView.clipsToBounds = true
        avatarView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)

        self.view.addSubview(avatarView)
        avatarView.snp.makeConstraints { (make) in
            make.top.equalTo(Constants.HomeScreen.paddingTopOfIcon)
            make.width.height.equalTo(Constants.HomeScreen.avatarWidth)
            make.centerX.equalTo(self.view)
        }
    }
    
    private func addNameLabel() {
        self.view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.HomeScreen.appNameLabelHeight)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(avatarView).offset(Constants.HomeScreen.appNameLabelHeight + Constants.HomeScreen.standardPadding)
        }
    
        nameLabel.textAlignment = NSTextAlignment.center
        nameLabel.font = nameLabel.font.withSize(30)
        nameLabel.textColor = Constants.HomeScreen.appNameColor
        nameLabel.text = Constants.HomeScreen.appName
    }
    
    private func addStartButton() {
        startButton.setTitle("START", for: .normal)
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(nameLabel).offset(150)
            make.width.equalTo(Constants.HomeScreen.buttonWidth)
        }
        
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }
    
    private func addStart2PlayersButton() {
        start2PButton.setTitle("2P", for: .normal)
        self.view.addSubview(start2PButton)
        start2PButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.top.equalTo(startButton.snp.bottom).offset(30)
            make.width.equalTo(Constants.HomeScreen.buttonWidth)
        }
        
        start2PButton.addTarget(self, action: #selector(didTapStart2PlayerButton), for: .touchUpInside)
    }

    private func addRankingButton() {
        rankingButton.setTitle("RANK", for: .normal)
        self.view.addSubview(rankingButton)
        rankingButton.snp.makeConstraints { (make) in
            make.top.equalTo(start2PButton.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.width.equalTo(Constants.HomeScreen.buttonWidth)
        }
        self.rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
    }
    
    private func setupBannerAd() {
        adBannerView = GADBannerView()
        adBannerView.rootViewController = self
        adBannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        adBannerView.load(GADRequest())
        self.view.addSubview(adBannerView)
        adBannerView.snp.makeConstraints { (make) in
            make.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.bottom.equalTo(-50)
            make.height.equalTo(100)
        }
    }
        
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
        
    // MARK: Action handler
    
    @objc private func didTapStartButton() {
        let gameVC = PlayingGameViewController()
        gameVC.modalPresentationStyle = .fullScreen
        self.present(gameVC, animated: false, completion: nil)
    }

    @objc private func didTapStart2PlayerButton() {
        let multiPlayerVC = MultiPlayerViewController()
        multiPlayerVC.modalPresentationStyle = .fullScreen
        self.present(multiPlayerVC, animated: false, completion: nil)
    }
    
    @objc private func didTapRankingButton() {
        let viewController = RankingViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true) {
            //
        }
    }
        
    private func logout() {
        let alert = UIAlertController(title: "Thông báo", message: "Bạn có muốn đăng xuất tài khoản Zalo?", preferredStyle: UIAlertController.Style.actionSheet)
        
        let logoutAction = UIAlertAction(title: "Đăng xuất", style: .default) { (_) in
            ZaloService.sharedInstance.logoutZalo()
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Huỷ", style: .default) { (_) in
            //
        }
        
        alert.addAction(logoutAction)
        alert.addAction(cancelAction)
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: Setup data
    
    private func loadData() {
        ZaloService.sharedInstance.loadZaloProfileIfNeed { [weak self] (name, avatarUrl) in
            DispatchQueue.main.async() {
                self?.nameLabel.text = name
            }
            self?.avatarView.downloaded(from: avatarUrl)
        }
    }
}

