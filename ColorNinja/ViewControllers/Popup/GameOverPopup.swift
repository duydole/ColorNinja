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

protocol GameOverPopupDelegate {
    func didTapReplayButton() -> Void
    func didTapGoHomeButton() -> Void
}

class GameOverPopup: PopupViewController {
    
    static let kCornerRadius: CGFloat = 10
    static let kContentPadding: CGFloat = 10
    
    // MARK: Public
    public var delegate: GameOverPopupDelegate?
    public var resultModel: ResultGameModel = ResultGameModel(user: User(), score: 0)

    // MARK: Private
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
        if OwnerInfo.shared.countRoundDidPlay % 3 == 0 {
            showFullScreenAd()
        } else {
            _dismissAndSendReplayEventToDelegate()
        }
    }
    
    @objc private func didTapWatchAdsButton() {
        if rewardedAd?.isReady == true {
           rewardedAd?.present(fromRootViewController: self, delegate:self)
        }
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
        watchAdsButton = ViewCreator.createButtonInGameOverPopup(image: UIImage(named: "adsicon"), title: "+2S")
        watchAdsButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapWatchAdsButton))
        container.addSubview(watchAdsButton)
        watchAdsButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(buttonWidthRatio)
            make.top.right.bottom.equalToSuperview()
        }
    }
    
    private func setupAds() {
        
        // FullScreen
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
        
        //RewardAds:
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        rewardedAd?.load(GADRequest()) { error in
          if let _ = error {
            assertionFailure()
          } else {
            // Ad successfully loaded.
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
        rankedLabel.text = "Rank: \(resultModel.user.rank)"
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
            interstitial.present(fromRootViewController: self)
        } else {
            assert(true, "Ads is not ready")
        }
    }
    
    private func _dismissAndSendReplayEventToDelegate() {
        self.dismissPopUp()
        self.delegate?.didTapReplayButton()
    }
}


// MARK: FullScreenAds delegate

extension GameOverPopup: GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        _dismissAndSendReplayEventToDelegate()
    }
}

// MARK: RewardAds delegate
extension GameOverPopup: GADRewardedAdDelegate {
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        
    }
}
