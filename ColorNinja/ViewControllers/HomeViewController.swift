//
//  ViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import SnapKit

class HomeViewController: UIViewController {
    
    let iconImageView : UIImageView = UIImageView()
    let appNameLabel : UILabel = UILabel()
    let startButton : ZButton = ZButton()
    let rankingButton : ZButton = ZButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.setupBackgroundImage()
        self.addAppIconView()
        self.addAppNameLabel()
        self.addStartButton()
        self.addRankingButton()
    }
    
    private func setupBackgroundImage() {
        //let bgImageView : UIImageView = UIImageView(frame: self.view.bounds)
        //bgImageView.image = UIImage(named: "bg")
        //self.view.addSubview(bgImageView)
        self.view.backgroundColor = Constants.HomeScreen.backgroundColor
    }
    
    private func addAppIconView() {
        iconImageView.image = UIImage(named: Constants.HomeScreen.ninjaImageName)
        self.view.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { (make) in
            make.top.equalTo(Constants.HomeScreen.paddingTopOfIcon)
            make.width.height.equalTo(self.iconWidth)
            make.centerX.equalTo(self.view)
        }
    }
    
    private func addAppNameLabel() {
        self.view.addSubview(appNameLabel)
        appNameLabel.snp.makeConstraints { (make) in
            make.height.equalTo(Constants.HomeScreen.appNameLabelHeight)
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(iconImageView).offset(Constants.HomeScreen.appNameLabelHeight + self.standardPadding)
        }
        
        appNameLabel.text = Constants.HomeScreen.appName
        appNameLabel.textAlignment = NSTextAlignment.center
        appNameLabel.font = appNameLabel.font.withSize(Constants.HomeScreen.appNameFontSize)
        appNameLabel.textColor = Constants.HomeScreen.appNameColor
    }
    
    private func addStartButton() {
        startButton.setTitle("START", for: .normal)
        self.view.addSubview(startButton)
        startButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.bottom.equalTo(appNameLabel).offset(100)
        }
        
        startButton.addTarget(self, action: #selector(didTapStartButton), for: .touchUpInside)
    }

    private func addRankingButton() {
        rankingButton.setTitle("RANK", for: .normal)
        self.view.addSubview(rankingButton)
        rankingButton.snp.makeConstraints { (make) in
            make.bottom.equalTo(startButton).offset(70)
            make.centerX.equalTo(self.view)
        }
        self.rankingButton.addTarget(self, action: #selector(didTapRankingButton), for: .touchUpInside)
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
    
    @objc private func didTapRankingButton() {
        let viewController = RankingViewController()
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true) {
            //
        }
    }
    
    // MARK: Getter
    
    private var standardPadding : CGFloat {
        get {
            return Constants.HomeScreen.standardPadding
        }
    }
    
    private var iconWidth : CGFloat {
        get {
            return Constants.HomeScreen.iconWidth
        }
    }
}

