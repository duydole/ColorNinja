//
//  GameOverPopup.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class GameOverPopup: PopupViewController {
    
    var goHomeButton: UIButton!
    var replayButton: UIButton!
    
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

    }

    @objc private func didTapReplayButton() {
        
    }
    
    // MARK: - Setup Views
    
    private func setupViews() {
        self.setupGameOverViews()
        self.setupGameResult()
        self.setupButtons()
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
        goHomeButton.setTitle("Home", for: .normal)
        goHomeButton.setImage(UIImage(named: "homeicon"), for: .normal)
        goHomeButton.layer.cornerRadius = 25
        goHomeButton.backgroundColor = .orange
        goHomeButton.makeShadow()
        goHomeButton.addTarget(self, action: #selector(didTapGoHomeButton), for: .touchUpInside)
        container.addSubview(goHomeButton)
        goHomeButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.47)
            make.leading.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        // PlayAgain
        replayButton = ButtonWithImage()
        replayButton.setTitle("Replay", for: .normal)
        replayButton.setImage(UIImage(named: "replayicon"), for: .normal)
        replayButton.backgroundColor = .orange
        replayButton.layer.cornerRadius = 25
        replayButton.makeShadow()
        replayButton.addTarget(self, action: #selector(didTapReplayButton), for: .touchUpInside)
        container.addSubview(replayButton)
        replayButton.snp.makeConstraints { (make) in
            make.width.equalToSuperview().multipliedBy(0.47)
            make.top.equalToSuperview()
            make.trailing.bottom.equalToSuperview()
        }
    }
}
