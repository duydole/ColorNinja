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
        keyInfo1.textColor = Constants.GameScreen.LabelsContainer.textColor
        keyInfo1.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        let keyInfo2 = UILabel()
        keyInfo2.text = "MY BEST RECORD"
        keyInfo2.textColor = Constants.GameScreen.LabelsContainer.textColor
        keyInfo2.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        let valueInfo1 = UILabel()
        valueInfo1.text = "100"
        valueInfo1.textColor = .white
        valueInfo1.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueInfo1.textAlignment = .right
        
        let valueInfo2 = UILabel()
        valueInfo2.text = "21"
        valueInfo2.textColor = .white
        valueInfo2.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        valueInfo2.textAlignment = .right
        
        self.infoView.addSubview(keyInfo1)
        self.infoView.addSubview(keyInfo2)
        self.infoView.addSubview(valueInfo1)
        self.infoView.addSubview(valueInfo2)
        
        
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
        
        valueInfo1.snp.makeConstraints { (make) in
            make.left.equalTo(keyInfo1.snp.right)
            make.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalTo(self.infoView.snp.centerY)
        }
        
        valueInfo2.snp.makeConstraints { (make) in
            make.left.equalTo(keyInfo2.snp.right)
            make.right.equalToSuperview()
            make.top.equalTo(valueInfo1.snp.bottom)
            make.bottom.equalToSuperview()
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
            make.width.height.equalTo(Constants.GameScreen.exitButtonWidth * 0.75)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.right.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    private func prepareData() {
        
        DataBaseService.shared.loadLeaderBoardUsers { (users,error)  in
            
            if let error = error {
                print("duydl: Error \(error)")
                return
            }
            
            if let users = users {
                if users.count == 0 {
                    return
                }
                
                for i in 0...users.count - 1 {
                    self.rankingData.append(RankingCellModel(ranking: i, name: users[i].name ?? "Default", avatarURL: "", record: users[i].bestscore))
                }
                DispatchQueue.main.async {
                  self.rankingView.setRankingData(rankingData: self.rankingData)
                }
            }
        }
    }
    
    // MARK: Hanlde event
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }

}
