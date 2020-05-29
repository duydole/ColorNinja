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
    
    public var delegate: GameOverPopupDelegate?
    public var resultModel: ResultGameModel = ResultGameModel(user: User(), score: 0)
    
    private var goHomeButton: ButtonWithImage!
    private var replayButton: ButtonWithImage!
    private var looseLevelLabel: UILabel!
    private var rankedLabel: UILabel!
    private var bestLevelLabel: UILabel!
    private var gameOverContainer: UIView!
    
    private var interstitial: GADInterstitial!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    override var contentSize: CGSize {
        return CGSize(width: scaledValue(320), height: scaledValue(370))
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
        #if !DEBUG
        showFullScreenAd()
        #endif
        self.dismiss(animated: false) {
            self.delegate?.didTapReplayButton()
        }
    }
    
    // MARK: Setup Views
    
    private func setupViews() {
        setupGameOverViews()
        setupGameResult()
        setupButtons()
        setupFullScreenAds()
        
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
        
        // GoHome
        goHomeButton = ButtonWithImage()
        goHomeButton.buttonPadding = GameOverPopup.kbuttonPadding
        goHomeButton.spacing = GameOverPopup.kImageButtonSpacing
        goHomeButton.titleLabel.text = "HOME"
        goHomeButton.titleLabel.adjustsFontSizeToFitWidth = true
        goHomeButton.titleLabel.textAlignment = .center
        goHomeButton.titleLabel.textColor = .white
        goHomeButton.titleLabel.makeShadow()
        goHomeButton.titleLabel.font = UIFont(name: Font.squirk, size: scaledValue(30))
        goHomeButton.imageView.image = UIImage(named: "homeicon")?.withRenderingMode(.alwaysTemplate)
        goHomeButton.imageView.tintColor = .white
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
        replayButton.titleLabel.text = "REPLAY"
        replayButton.titleLabel.adjustsFontSizeToFitWidth = true
        replayButton.titleLabel.textAlignment = .center
        replayButton.titleLabel.textColor = .white
        replayButton.titleLabel.makeShadow()
        replayButton.titleLabel.font = UIFont(name: Font.squirk, size: scaledValue(30))
        replayButton.imageView.image = UIImage(named: "replayicon")?.withRenderingMode(.alwaysTemplate)
        replayButton.imageView.tintColor = .white
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
    
    private func setupResultsView() {
        
        // LooseLevel
        looseLevelLabel = UILabel()
        looseLevelLabel.text = "Level: \(resultModel.score)"
        looseLevelLabel.font = UIFont(name: Font.squirk, size: scaledValue(45))
        contentView.addSubview(looseLevelLabel)
        looseLevelLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(gameOverContainer.snp.bottom).offset(scaledValue(20))
        }
        
        // Rank
        rankedLabel = UILabel()
        rankedLabel.text = "Rank: \(resultModel.user.rank)"
        rankedLabel.font = UIFont(name: Font.squirk, size: scaledValue(40))
        contentView.addSubview(rankedLabel)
        rankedLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(looseLevelLabel.snp.bottom).offset(scaledValue(20))
        }
        
        // BestScore
        bestLevelLabel = UILabel()
        bestLevelLabel.text = "Your Best Score: \(resultModel.user.bestScore)"
        bestLevelLabel.font = UIFont(name: Font.squirk, size: scaledValue(35))
        contentView.addSubview(bestLevelLabel)
        bestLevelLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(rankedLabel.snp.bottom).offset(scaledValue(30))
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
}


// MARK: - Delegate FullScreen

extension GameOverPopup : GADInterstitialDelegate {
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        self.dismissPopUp()
        self.delegate?.didTapReplayButton()
    }
}
