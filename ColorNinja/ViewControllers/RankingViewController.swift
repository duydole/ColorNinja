//
//  RankingViewController.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController {
    
    // MARK: Property
    private var rankingView: RankingTableView!
    private var exitButton: UIButton!
    private var titleLabel: UILabel!
    private var avatarView: UIImageView!
    private var infoView: UIView!
    
    private var rankingData: [RankingCellModel] = []

    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupView()
        self.prepareData()
    }

    
    // MARK: Setup views
    private func setupView() {
        self.view.backgroundColor = Constants.GameScreen.backgroundColor
        
        self.setupTableView()
        self.setupExitButton()
        
        self.setTitleLabel()
        self.setupAvatarView()
        self.setupInfoView()

    }
    
    private func setTitleLabel() {
        self.titleLabel = UILabel()
        self.view.addSubview(self.titleLabel)
        self.titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.height.equalTo(50)
            make.width.equalTo(200)
            make.top.equalTo(Size.statusBarHeight + 50)
        }
        self.titleLabel.textAlignment = .center
        self.titleLabel.text = "LEADERBOARD"
        self.titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        self.titleLabel.textColor = .white
    }
    
    private func setupAvatarView() {
        self.avatarView = UIImageView()
        self.view.addSubview(self.avatarView)
        
        self.avatarView.image = UIImage(named: "avatar")
        self.avatarView.layer.cornerRadius = 40
        self.avatarView.clipsToBounds = true
        
        
        self.avatarView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.width.height.equalTo(80)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(50)
        }
    }
    
    private func setupInfoView() {
        self.infoView = UIView()
        self.view.addSubview(self.infoView)
        self.infoView.snp.makeConstraints { (make) in
            make.left.equalTo(self.avatarView.snp.right).offset(15)
            make.height.equalTo(self.avatarView.snp.height)
            make.centerY.equalTo(self.avatarView.snp.centerY)
            make.right.equalToSuperview().offset(-20)
        }
        
        let keyInfo1 = UILabel()
        keyInfo1.text = "MY RANK"
        let keyInfo2 = UILabel()
        keyInfo2.text = "MY BEST RECORD"
        
        self.infoView.addSubview(keyInfo1)
        self.infoView.addSubview(keyInfo2)
        
        keyInfo1.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.infoView.snp.centerY)
            make.width.equalTo(150)
        }
        
        keyInfo2.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(keyInfo1.snp.bottom)
            make.bottom.equalToSuperview()
            make.width.equalTo(150)
        }
    }
    
    private func setupTableView() {
        self.rankingView = RankingTableView()
        self.view.addSubview(self.rankingView)
        
        self.rankingView.backgroundColor = Constants.GameScreen.forcegroundColor
        self.rankingView.layer.cornerRadius = 16
        self.rankingView.clipsToBounds = true
        
        self.rankingView.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().offset(-80)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(400)
        }
    }
    
    private func setupExitButton() {
        self.exitButton = UIButton()
        self.view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        exitButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        exitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.exitButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.right.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    private func prepareData() {
        let testData1 = RankingCellModel(ranking: 1, name: "Kim Thi", avatarURL: "avatar", record: 50)
        let testData2 = RankingCellModel(ranking: 2, name: "Do Huu Phuc", avatarURL: "steve_profile", record: 45)
        let testData3 = RankingCellModel(ranking: 3, name: "Con Cho Le Duy", avatarURL: "zuck_profile", record: 40)
        let testData4 = RankingCellModel(ranking: 4, name: "Nguyen Van A", avatarURL: "hillary_profile", record: 35)
        let testData5 = RankingCellModel(ranking: 5, name: "Nguyen Van B", avatarURL: "avatar", record: 30)
        let testData6 = RankingCellModel(ranking: 6, name: "TEST", avatarURL: "avatar", record: 20)
        
        self.rankingData = [testData1, testData2, testData3, testData4, testData5, testData6]
        
        self.rankingView.setRankingData(rankingData: self.rankingData)
    }
    
    // MARK: Hanlde event
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
