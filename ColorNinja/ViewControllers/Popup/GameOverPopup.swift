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
        return 30
    }
    
    // MARK: - Event Handlers
    
    @objc private func didTapGoHomeButton() {
        self.dismiss(animated: false) {
            self.gameOverDelegate?.didTapGoHomeButton()
        }
    }

    @objc private func didTapReplayButton() {
        #if !DEBUG
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            assert(true, "Ads is not ready")
        }
        #endif
    }
    
    // MARK: - Setup Views
    
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
        container.layer.cornerRadius = 30
        container.makeShadow()
        self.contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.top.leading.equalTo(20)
            make.trailing.equalTo(-20)
            make.height.equalTo(100)
        }
        
        // Label GameOver
        let gameOverLabel = UILabel()
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.textColor = .white
        gameOverLabel.font = UIFont.systemFont(ofSize: 45, weight: .bold)
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
        //container.backgroundColor = .red
        contentView.addSubview(container)
        container.snp.makeConstraints { (make) in
            make.trailing.bottom.equalTo(-20)
            make.leading.equalTo(20)
            make.height.equalTo(50)
        }
        
        // GoHome
        goHomeButton = ButtonWithImage()
        goHomeButton.titleLabel.text = "Home"
        goHomeButton.imageView.image = UIImage(named: "homeicon")
        goHomeButton.layer.cornerRadius = 25
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
        replayButton.titleLabel.text = "Replay"
        replayButton.imageView.image = UIImage(named: "replayicon")
        replayButton.backgroundColor = .orange
        replayButton.layer.cornerRadius = 25
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
}


// MARK: - Delegate FullScreen

extension GameOverPopup : GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismissPopUp()
        self.gameOverDelegate?.didTapReplayButton()
    }
}
