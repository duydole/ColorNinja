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
import StoreKit

let bannerAdUnitId = "ca-app-pub-2457313692920235/9322423961"
let colorNinjaAppId = "1516759930"

class HomeViewController2: BaseHomeViewController {
  
  //Private
  private var singlePlayerButton: UIButton!
  private var multiPlayerButton: UIButton!
  private var bestScoreLabel: UILabel!
  private var bottomBar: UIView!
  private var adBannerView: GADBannerView!
  
  // BottomBar
  private var rateUsButton: UIButton!
  private var muteButton: UIButton!
  private var rankingButton: UIButton!
  
  // MARK: Life cycle
  
  override func viewDidLoad() {
    
    super.viewDidLoad()
    
    setupNavigationController()
    regiserUserInfo()
    
    #if DEBUG
    printAllFamilyFonts()
    #endif
  }
  
  // MARK: Setup views
  
  private func setupNavigationController() {
    /// Disable swipe to back
    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    
    /// Hide naviagtionbar
    navigationController?.navigationBar.isHidden = true
  }
    
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
    singlePlayerButton.layer.cornerRadius = scaledValue(13)
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
    multiPlayerButton.layer.cornerRadius = scaledValue(13)
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
    adBannerView.adUnitID = bannerAdUnitId
    adBannerView.load(GADRequest())
    view.addSubview(adBannerView)
    
    let padding: CGFloat = 10
    let viewWidth = ScreenSize.width - 2*padding
    let bottomPadding = safeAreaBottom() > 0 ? safeAreaBottom() : padding
    
    adBannerView.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(viewWidth)
    adBannerView.snp.makeConstraints { (make) in
      make.bottom.equalTo(-bottomPadding)
      make.centerX.equalToSuperview()
    }
  }
  
  // MARK: Setup BottomBar
  
  private func setupBottomBar() {
    
    let buttonSpacing: CGFloat = scaledValue(30)
    let spacingWithAd: CGFloat = scaledValue(10)
    let bottomBarHeight: CGFloat = scaledValue(45)
    
    // Container
    bottomBar = UIView()
    view.addSubview(bottomBar)
    bottomBar.snp.makeConstraints { (make) in
      make.width.centerX.equalTo(adBannerView)
      make.height.equalTo(bottomBarHeight)
      make.bottom.equalTo(adBannerView.snp.top).offset(-spacingWithAd)
    }
    
    
    //    // RateUs
    //    rateUsButton = UIButton()
    //    rateUsButton.setImage(UIImage(named:"staricon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    //    rateUsButton.imageView?.tintColor = .white
    //    rateUsButton.addTarget(self, action: #selector(didTapRateUsButton), for: .touchUpInside)
    //    bottomBar.addSubview(rateUsButton)
    //    rateUsButton.snp.makeConstraints { (make) in
    //      make.height.equalToSuperview()
    //      make.width.equalTo(rateUsButton.snp.height)
    //      make.center.equalToSuperview()
    //    }
    
    // MuteButton
    muteButton = UIButton()
    muteButton.setImage(speakerImageForCurrentMainSoundState()?.withRenderingMode(.alwaysTemplate), for: .normal)
    muteButton.imageView?.tintColor = .white
    muteButton.addTarget(self, action: #selector(didTapMuteButton), for: .touchUpInside)
    bottomBar.addSubview(muteButton)
    muteButton.snp.makeConstraints { (make) in
      make.height.centerY.equalToSuperview()
      make.width.equalTo(muteButton.snp.height)
      make.centerX.equalToSuperview().offset(-(bottomBarHeight - buttonSpacing/2))
    }
    
    // RankingButton
    rankingButton = UIButton()
    rankingButton.setImage(UIImage(named:"rankingicon")?.withRenderingMode(.alwaysTemplate), for: .normal)
    rankingButton.imageView?.tintColor = .white
    rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
    bottomBar.addSubview(rankingButton)
    rankingButton.snp.makeConstraints { (make) in
      make.centerY.width.height.equalTo(muteButton)
      make.leading.equalTo(muteButton.snp.trailing).offset(scaledValue(buttonSpacing))
    }
  }
  
  override var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }
  
  private func speakerImageForCurrentMainSoundState() -> UIImage? {
    return GameMusicPlayer.shared.isMuteMainSound ? UIImage(named:"speakeroff") : UIImage(named:"speakeron")
  }
  
  // MAKR: Other
  
  private func regiserUserInfo() {
    // Register aganin if need:
    DataBaseService.shared.insertUserToDB(user: OwnerInfo.shared, completion: nil)
  }
  
  // MARK: Action handler
  
  #if !DISABLE_ZALOSDK
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
  #endif
  
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
    rateApp()
  }
  
  @objc private func didTapMuteButton() {
    
    // Update setting
    GameSettingManager.shared.allowMainSound.toggle()
    
    // Update MusicPlayer
    GameMusicPlayer.shared.toggleMainSoundState()
    muteButton.setImage(speakerImageForCurrentMainSoundState()?.withRenderingMode(.alwaysTemplate), for: .normal)
  }
  
  @objc private func didTapRankingButton() {
    let rankingVC = RankingViewController()
    rankingVC.modalPresentationStyle = .fullScreen
    present(rankingVC, animated: true, completion: nil)
  }
  
  func rateApp() {
    if #available(iOS 10.3, *) {
      SKStoreReviewController.requestReview()
      
    } else if let url = URL(string: "itms-apps://itunes.apple.com/app/\(colorNinjaAppId)") {
      if #available(iOS 10, *) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
      } else {
        UIApplication.shared.openURL(url)
      }
    }
  }
}
