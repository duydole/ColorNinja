//
//  GameOverPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds


let rewardForEachAds: Int = 5 /// numb of seconds user gained each ads.
let fullScreenAdUnitId = "ca-app-pub-2457313692920235/3301114557"
let rewardAdsUnitId = "ca-app-pub-2457313692920235/5356432254"

protocol GameOverPopupDelegate {
  func didTapReplayButton() -> Void
  func didTapGoHomeButton() -> Void
  func didEarnedRewardToContinuePlay(reward: Int) -> Void
}

class GameOverPopup: PopupViewController {
  
  static let kCornerRadius: CGFloat = 10
  static let kContentPadding: CGFloat = 10
  
  // MARK: Public
  public var delegate: GameOverPopupDelegate?
  public var resultModel: ResultGameModel = ResultGameModel(user: User(), score: 0)
  public var allowWatchAdsToGainReward = true
  
  // MARK: Private Views
  private var earnedReward: Int = 0
  
  private var goHomeButton: ButtonWithImage!
  private var replayButton: ButtonWithImage!
  private var watchAdsButton: ButtonWithImage!
  
  private var looseLevelLabel: UILabel!
  private var rankedLabel: UILabel!
  private var bestLevelLabel: UILabel!
  private var gameOverContainer: UIView!
  
  // MARK: Ads
  private var rewardedAd: GADRewardedAd?
  private var interstitial: GADInterstitial!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupViews()
  }
  
  override var contentSize: CGSize {
    return CGSize(width: scaledValue(330), height: scaledValue(370))
  }
  
  override var cornerRadius: CGFloat {
    return GameOverPopup.kCornerRadius
  }
  
  // MARK: Event Handlers
  
  @objc private func didTapGoHomeButton() {
    self.dismiss(animated: false) {
      self.delegate?.didTapGoHomeButton()
    }
  }
  
  @objc private func didTapReplayButton() {
    if OwnerInfo.shared.countRoundDidPlay % 3 == 0 && NetworkManager.shared.hasConnection {
      showFullScreenAd()
    } else {
      _dismissAndSendReplayEventToDelegate()
    }
  }
  
  @objc private func didTapWatchAdsButton() {
    showRewardAd()
  }
  
  // MARK: Setup Views
  
  private func setupViews() {
    setupAds()
    
    setupGameOverViews()
    setupGameResult()
    setupButtons()
    
    setupResultsView()
  }
  
  private func setupGameOverViews() {
    
    // Container
    gameOverContainer = UIView()
    gameOverContainer.backgroundColor = .orange
    gameOverContainer.layer.cornerRadius = GameOverPopup.kCornerRadius
    gameOverContainer.makeShadow()
    contentView.addSubview(gameOverContainer)
    gameOverContainer.snp.makeConstraints { (make) in
      make.top.leading.equalTo(GameOverPopup.kContentPadding)
      make.trailing.equalTo(-GameOverPopup.kContentPadding)
      make.height.equalToSuperview().multipliedBy(0.2)
    }
    
    // Label GameOver
    let gameOverLabel = UILabel()
    gameOverLabel.text = "GAME OVER"
    gameOverLabel.adjustsFontSizeToFitWidth = true
    gameOverLabel.textColor = .white
    gameOverLabel.font = UIFont(name: Font.squirk, size: scaledValue(50))
    gameOverLabel.makeShadow()
    gameOverContainer.addSubview(gameOverLabel)
    gameOverLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  private func setupGameResult() {
    
  }
  
  private func setupButtons() {
    
    // Container
    let container = UIView()
    contentView.addSubview(container)
    container.snp.makeConstraints { (make) in
      make.trailing.bottom.equalTo(-GameOverPopup.kContentPadding)
      make.leading.equalTo(GameOverPopup.kContentPadding)
      make.height.equalToSuperview().multipliedBy(0.12)
    }
    
    let buttonWidthRatio = 0.32
    
    // GoHome
    goHomeButton = ViewCreator.createButtonInGameOverPopup(image: UIImage(named: "homeicon"), title: "HOME")
    goHomeButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapGoHomeButton))
    container.addSubview(goHomeButton)
    goHomeButton.snp.makeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(buttonWidthRatio)
      make.left.top.bottom.equalToSuperview()
    }
    
    // PlayAgain
    replayButton = ViewCreator.createButtonInGameOverPopup(image: UIImage(named: "replayicon"), title: "REPLAY")
    replayButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapReplayButton))
    container.addSubview(replayButton)
    replayButton.snp.makeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(buttonWidthRatio)
      make.centerX.centerY.equalToSuperview()
      make.height.equalTo(goHomeButton)
    }
    
    // Watch Ads
    watchAdsButton = ViewCreator.createButtonInGameOverPopup(image: UIImage(named: "adsicon"), title: "+\(rewardForEachAds)s")
    watchAdsButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapWatchAdsButton))
    container.addSubview(watchAdsButton)
    watchAdsButton.snp.makeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(buttonWidthRatio)
      make.top.right.bottom.equalToSuperview()
    }
  }
  
  private func setupAds() {
    
    // FullScreen
    loadFullScreenAds()
    
    //RewardAds:
    loadRewardAds()
  }
  
  private func loadFullScreenAds() {
    interstitial = GADInterstitial(adUnitID: fullScreenAdUnitId)
    interstitial.delegate = self
    let request = GADRequest()
    interstitial.load(request)
  }
  
  private func loadRewardAds() {
    rewardedAd = GADRewardedAd(adUnitID: rewardAdsUnitId)
    rewardedAd?.load(GADRequest()) { error in
      if let _ = error {
        print("duydl: ERROR: Load reward ads failed")
      } else {
        print("duydl: SUCCESS: Load reward ads successfully")
      }
    }
  }
  
  private func setupResultsView() {
    
    // LooseLevel
    looseLevelLabel = UILabel()
    looseLevelLabel.text = "Score: \(resultModel.score)"
    looseLevelLabel.font = UIFont(name: Font.dincondenseBold, size: scaledValue(50))
    contentView.addSubview(looseLevelLabel)
    looseLevelLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(gameOverContainer.snp.bottom).offset(scaledValue(30))
    }
    
    // Rank
    rankedLabel = UILabel()
    let rankString = resultModel.user.rank < 0 ? "-" : "\(resultModel.user.rank)"
    rankedLabel.text = "Rank: \(rankString)"
    rankedLabel.font = UIFont(name: Font.dincondenseBold, size: scaledValue(45))
    contentView.addSubview(rankedLabel)
    rankedLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(looseLevelLabel.snp.bottom).offset(scaledValue(20))
    }
    
    // BestScore
    bestLevelLabel = UILabel()
    bestLevelLabel.text = "Best Score: \(resultModel.user.bestScore)"
    bestLevelLabel.font = UIFont(name: Font.dincondenseBold, size: scaledValue(40))
    contentView.addSubview(bestLevelLabel)
    bestLevelLabel.snp.makeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.top.equalTo(rankedLabel.snp.bottom).offset(scaledValue(25))
    }
  }
  
  // MARK: Other
  
  private func showFullScreenAd() {
    if interstitial.isReady {
      if GameSettingManager.shared.allowMainSound {
        GameMusicPlayer.shared.muteBackgroundGameMusic()
      }
      interstitial.present(fromRootViewController: self)
    } else {
      assert(true, "Ads is not ready")
    }
  }
  
  private func showRewardAd() {
    if !allowWatchAdsToGainReward {
      /// Not allow to watch ads
      return
    }
    
    if rewardedAd?.isReady == true {
      if GameSettingManager.shared.allowMainSound {
        GameMusicPlayer.shared.muteBackgroundGameMusic()
      }
      rewardedAd?.present(fromRootViewController: self, delegate:self)
    }
  }
  
  private func _dismissAndSendReplayEventToDelegate() {
    self.dismissPopUp()
    self.delegate?.didTapReplayButton()
  }
  
  private func _dismissAndSendRewardEventToDelegate() {
    dismissPopUp()
    delegate?.didEarnedRewardToContinuePlay(reward: earnedReward)
  }
}


// MARK: FullScreenAds delegate

extension GameOverPopup: GADInterstitialDelegate {
  
  func interstitialDidDismissScreen(_ ad: GADInterstitial) {
    if GameSettingManager.shared.allowMainSound {
      GameMusicPlayer.shared.unmuteBackgroundGameMusic()
    }
    _dismissAndSendReplayEventToDelegate()
  }
}

// MARK: RewardAds delegate
extension GameOverPopup: GADRewardedAdDelegate {
  /// Tells the delegate that the user earned a reward.
  func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
    print("Reward received with currency: \(reward.type), amount \(reward.amount).")
    earnedReward = rewardForEachAds
  }
  
  /// Tells the delegate that the rewarded ad was presented.
  func rewardedAdDidPresent(_ rewardedAd: GADRewardedAd) {
    print("Rewarded ad presented.")
  }
  
  /// Tells the delegate that the rewarded ad was dismissed.
  func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
    
    if GameSettingManager.shared.allowMainSound {
      GameMusicPlayer.shared.unmuteBackgroundGameMusic()
    }
    
    if earnedReward > 0 {
      /// Send reward to delegate
      _dismissAndSendRewardEventToDelegate()
    } else {
      /// No reward
      loadRewardAds()
    }
  }
  
  /// Tells the delegate that the rewarded ad failed to present.
  func rewardedAd(_ rewardedAd: GADRewardedAd, didFailToPresentWithError error: Error) {
    print("Rewarded ad failed to present.")
  }
}
