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
    static let kbuttonPadding: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    static let kImageButtonSpacing: CGFloat = 10
    static let kButtonCornerRadius: CGFloat = 10
    
    
    var goHomeButton: ButtonWithImage!
    var replayButton: ButtonWithImage!
    var gameOverDelegate: GameOverPopupDelegate?
    
    var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override var contentSize: CGSize {
        return Constants.GameOverPopup.contentSize
    }
    
    override var cornerRadius: CGFloat {
        return GameOverPopup.kCornerRadius
    }
    
    // MARK: Event Handlers
    
    @objc private func didTapGoHomeButton() {
        self.dismiss(animated: false) {
            self.gameOverDelegate?.didTapGoHomeButton()
        }
    }

    @objc private func didTapReplayButton() {
        #if !DEBUG
        showFullScreenAd()
        #endif
        self.dismiss(animated: false) {
            self.gameOverDelegate?.didTapReplayButton()
        }
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        self.setupGameOverViews()
        self.setupGameResult()
        self.setupButtons()
        self.setupFullScreenAds()
    }
    
    private func setupGameOverViews() {
        
        // Container
        let container = UIView()
        container.backgroundColor = .orange
        container.layer.cornerRadius = GameOverPopup.kCornerRadius
        container.makeShadow()
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.leading.equalTo(GameOverPopup.kContentPadding)
            make.trailing.equalTo(-GameOverPopup.kContentPadding)
            make.height.equalToSuperview().multipliedBy(0.2)
        }
        
        // Label GameOver
        let gameOverLabel = UILabel()
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.adjustsFontSizeToFitWidth = true
        gameOverLabel.textColor = .white
        gameOverLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        container.addSubview(gameOverLabel)
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
        
        // GoHome
        goHomeButton = ButtonWithImage()
        goHomeButton.buttonPadding = GameOverPopup.kbuttonPadding
        goHomeButton.spacing = GameOverPopup.kImageButtonSpacing
        goHomeButton.titleLabel.text = "Home"
        goHomeButton.titleLabel.adjustsFontSizeToFitWidth = true
        goHomeButton.titleLabel.textAlignment = .center
        goHomeButton.imageView.image = UIImage(named: "homeicon")
        goHomeButton.layer.cornerRadius = GameOverPopup.kButtonCornerRadius
        goHomeButton.backgroundColor = .orange
        goHomeButton.makeShadow()
        goHomeButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapGoHomeButton))
        container.addSubview(goHomeButton)
        goHomeButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.47)
            make.leading.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // PlayAgain
        replayButton = ButtonWithImage()
        replayButton.buttonPadding = GameOverPopup.kbuttonPadding
        replayButton.spacing = GameOverPopup.kImageButtonSpacing
        replayButton.titleLabel.text = "Replay"
        replayButton.titleLabel.adjustsFontSizeToFitWidth = true
        replayButton.titleLabel.textAlignment = .center
        replayButton.imageView.image = UIImage(named: "replayicon")
        replayButton.backgroundColor = .orange
        replayButton.layer.cornerRadius = GameOverPopup.kButtonCornerRadius
        replayButton.makeShadow()
        replayButton.addTargetForTouchUpInsideEvent(target: self, selector: #selector(didTapReplayButton))
        container.addSubview(replayButton)
        replayButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.47)
            make.top.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
        }
    }
    
    private func setupFullScreenAds() {
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        interstitial.delegate = self
        let request = GADRequest()
        interstitial.load(request)
    }
    
    // MARK: Other
    
    private func showFullScreenAd() {
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            assert(true, "Ads is not ready")
        }
    }
}


// MARK: - Delegate FullScreen

extension GameOverPopup : GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismissPopUp()
        self.gameOverDelegate?.didTapReplayButton()
    }
}
