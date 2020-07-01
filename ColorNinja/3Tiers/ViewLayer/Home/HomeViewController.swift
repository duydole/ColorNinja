//
//  LoginViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
#if ENABLE_ZALO_SDK
import ZaloSDK
#endif
import GoogleMobileAds
import StoreKit
import Localize_Swift

#if DEBUG_ADS
fileprivate let bannerAdUnitId = "ca-app-pub-3940256099942544/2934735716"
#else
fileprivate let bannerAdUnitId = "ca-app-pub-9846859688916273/5767994203"
#endif

let colorNinjaAppId = "1516759930"

class HomeViewController: BaseHomeViewController {
  
  //Private
  private var singlePlayerButton: ButtonWithImage!
  private var matchRandomButton: ButtonWithImage!
  private var newRoomButton: ButtonWithImage!
  private var joinRoomButton: ButtonWithImage!
  
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
    getAppConfigFromServer()
    
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
    addButtons()
    addBestScoreLabel()
  }
  
  private func addButtons() {
    #if DEBUG
    //midContainer.backgroundColor = .blue
    #endif
    
    let spacing = scaledValue(10)
    let paddingTopOfMidContainer = scaledValue(30)
    
    singlePlayerButton = ViewCreator.createButtonInHome(title: "1 Player", imamgeName: "singleicon")
    midContainer.addSubview(singlePlayerButton)
    singlePlayerButton.snp.makeConstraints { (make) in
      make.top.equalTo(paddingTopOfMidContainer)
      make.centerX.equalToSuperview()
      make.width.equalTo(scaledValue(227))
      make.height.equalTo(scaledValue(52))
    }
    
    singlePlayerButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapSinglePlayerButton))
    
    
    /// MultiPlayer Button
    matchRandomButton = ViewCreator.createButtonInHome(title: "VS STRANGER", imamgeName: "twopeopleicon")
    midContainer.addSubview(matchRandomButton)
    matchRandomButton.snp.makeConstraints { (make) in
      make.width.height.centerX.equalTo(singlePlayerButton)
      make.top.equalTo(singlePlayerButton.snp.bottom).offset(spacing)
    }
    
    matchRandomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapMatchRandomButton))
    
    
    /// NewRoom Button
    newRoomButton = ViewCreator.createButtonInHome(title: "NEW ROOM", imamgeName: "newroomicon")
    midContainer.addSubview(newRoomButton)
    newRoomButton.snp.makeConstraints { (make) in
      make.width.height.centerX.equalTo(singlePlayerButton)
      make.top.equalTo(matchRandomButton.snp.bottom).offset(spacing)
    }
    
    newRoomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapNewRoomButton))

    /// NewRoom Button
    joinRoomButton = ViewCreator.createButtonInHome(title: "JOIN ROOM", imamgeName: "joinroomicon")
    midContainer.addSubview(joinRoomButton)
    joinRoomButton.snp.makeConstraints { (make) in
      make.width.height.centerX.equalTo(singlePlayerButton)
      make.top.equalTo(newRoomButton.snp.bottom).offset(spacing)
    }
    
    joinRoomButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapJoinRoomButton))
  }
  
  private func addBestScoreLabel() {
    bestScoreLabel = UILabel()
    bestScoreLabel.text = "Your best score is \(OwnerInfo.shared.bestScore)"
    bestScoreLabel.textAlignment = NSTextAlignment.center
    bestScoreLabel.font = UIFont(name: Font.squirk, size: scaledValue(30))
    bestScoreLabel.textColor = .white
    midContainer.addSubview(bestScoreLabel)
    bestScoreLabel.snp.makeConstraints { (make) in
      make.top.equalTo(joinRoomButton.snp.bottom).offset(scaledValue(20))
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
  
  private func getAppConfigFromServer() {
    
    print("duydl: [AppConfig] - Start load AppConfig from server")
    DataBaseService.shared.loadAppConfig { (config) in
      if let config = config {
        /// Loaded configJson from server
        print("duydl: [AppConfig] - Load success AppConfig from server")
        
        self.parseAndSaveAppConfigFromServerW(configJson: config) { (done) in
          
          /// Parse + Save all config done
        }
      } else {
        print("duydl: [AppConfig] - Load failed AppConfig from server")
        
        self.handleWhenCannotLoadAppConfigFromServer()
      }
    }
  }
  
  private func handleWhenCannotLoadAppConfigFromServer() {
    let _ = ColorStore.shared
  }
  
  private func parseAndSaveAppConfigFromServerW(configJson: JSON,completion: (Bool) -> ()) {
    if let data = configJson["data"] as! JSON? {
      
      // ListColor
      if let listColros = data["listColors"] as! Array<JSON>? {
        for color in listColros {
          AppConfig.shared.listColors.append(ColorRGB(color["red"] as! CGFloat, color["green"] as! CGFloat, color["blue"] as! CGFloat))
        }
      }
      
      print("duydl: Load and save \(AppConfig.shared.listColors.count) colors from server successfully!")
      
      let _ = ColorStore.shared
    }
  }
  
  private func showEventPopup() {
    let eventPopup = EventPopup()
    eventPopup.modalPresentationStyle = .overCurrentContext
    eventPopup.allowTapDarkLayerToDismiss = true
    self.present(eventPopup, animated: false, completion: nil)
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
  
  // MARK: Action handler
  
  #if ENABLE_ZALO_SDK
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
  
  @objc private func didTapMatchRandomButton() {
    let vc = MultiPlayerViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: nil)
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
  
  @objc func didTapNewRoomButton() {
    let vc = RoomGameViewController()
    vc.modalPresentationStyle = .fullScreen
    present(vc, animated: false, completion: nil)
  }
  
  @objc func didTapJoinRoomButton() {
    let popup = JoinRoomPopup()
    popup.allowTapDarkLayerToDismiss = true
    popup.dismissInterval = 0.2
    popup.delegate = self
    popup.modalPresentationStyle = .overCurrentContext
    self.present(popup, animated: false, completion: nil)
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


extension HomeViewController: JoinRoomPopupDelegate {
  func didDismissWithRoomId(roomId: Int) {
    let homeVC = RoomGameViewController()
    homeVC.roomId = roomId
    homeVC.modalPresentationStyle = .fullScreen
    present(homeVC, animated: false, completion: nil)
  }
}
