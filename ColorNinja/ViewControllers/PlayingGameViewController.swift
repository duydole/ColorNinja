//
//  PlayingGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

class PlayingGameViewController : UIViewController {
    
    let settingButton : UIButton = UIButton()
    let exitButton : UIButton = UIButton()
    let levelCountLabel : UILabel = UILabel()
    let appImage : UIImageView = UIImageView()
    let remainTimeLabel : UILabel = UILabel()
    let labelsContainer : UIView = UIView()
    let readyLabel : UILabel = UILabel()
    let readyListString : [String] = ["READY","3","2","1","Go!"]
    
    var currentLevel : Int = 1
    var remainingTime : String = "00:00"
    weak var boardContainer : UIView!
    weak var boardCollectionView : BoardCollectionView!
    let boardDataSource: BoardDataSource = BoardDataSource()
    var shrinkCell : Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = Constants.GameScreen.backgroundColor
        self.setupViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animation ReadyView
        self.animationReadyView(index: 0) { (done) in
            
            // Show CollectionView with currentLevel
            self.boardCollectionView.alpha = 1.0
            self.shrinkCell = false
            self.boardCollectionView.reloadItems(at: self.boardCollectionView.indexPathsForVisibleItems)
        }
    }
    
    // MARK: Handle Animations
    
    private func animationReadyView(index: Int, completion: ((Bool) -> ())? ) {
        
        if index > self.readyListString.count - 1 {
            completion!(true)
            return
        }
        
        self.readyLabel.text = readyListString[index]
        UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
            self.readyLabel.alpha = 1.0
            self.readyLabel.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        }) { (success) in
            Thread.sleep(forTimeInterval: 0.65)
            self.readyLabel.transform = CGAffineTransform(scaleX: 1/0.4, y: 1/0.4)
            self.readyLabel.alpha = 0.0
            self.animationReadyView(index: index + 1, completion: completion)
        }
    }
    
    // MARK: Setup views
    
    private func setupViews() {
        self.setupSettingButton()
        self.setupExitButton()
        self.setupLabelsContainer()
        self.setupLevelViews()
        self.setupAppImageView()
        self.setupTimerView()
        self.setupCollectionViews()
        
        // ReadyView
        self.setupReadyView()
        
        // CollectionView
        self.setupBoardCollectionView()
    }
    
    private func setupSettingButton() {
        self.view.addSubview(settingButton)
        settingButton.setImage(UIImage(named: Constants.GameScreen.settingImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        settingButton.addTarget(self, action: #selector(didTapSettingButton), for: .touchUpInside)
        settingButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        settingButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.settingButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.leading.equalTo(Constants.GameScreen.leftInset)
        }
    }
    
    private func setupExitButton() {
        self.view.addSubview(exitButton)
        exitButton.setImage(UIImage(named: Constants.GameScreen.exitImageName)?.withRenderingMode(.alwaysTemplate), for: .normal)
        exitButton.addTarget(self, action: #selector(didTapExitButton), for: .touchUpInside)
        exitButton.imageView?.tintColor = Constants.GameScreen.buttonTintColor
        exitButton.snp.makeConstraints { (make) in
            make.width.height.equalTo(Constants.GameScreen.exitButtonWidth)
            make.top.equalTo(Constants.GameScreen.topInset)
            make.trailing.equalTo(-Constants.GameScreen.rightInset)
        }
    }
    
    private func setupLabelsContainer() {
        self.view.addSubview(labelsContainer)
        labelsContainer.snp.makeConstraints { (make) in
            make.top.equalTo(settingButton.snp.bottom).offset(Constants.GameScreen.LabelsContainer.margins.top)
            make.leading.equalTo(Constants.GameScreen.LabelsContainer.margins.left)
            make.trailing.equalTo(-Constants.GameScreen.LabelsContainer.margins.right)
            make.height.equalTo(Constants.GameScreen.LabelsContainer.height)
        }
    }
    
    private func setupLevelViews() {
        
        // Level
        let levelLabel = UILabel()
        levelLabel.text = "LEVEL"
        levelLabel.textAlignment = .center
        levelLabel.textColor = Constants.GameScreen.LabelsContainer.textColor
        levelLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        labelsContainer.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelsContainer)
            make.leading.equalTo(labelsContainer)
        }
        
        // Level Count
        labelsContainer.addSubview(levelCountLabel)
        levelCountLabel.text = "\(currentLevel)"
        levelCountLabel.textAlignment = .center
        levelCountLabel.textColor = .white
        levelCountLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        levelCountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(levelLabel.snp.bottom)
            make.leading.equalTo(labelsContainer)
            make.centerX.equalTo(levelLabel.snp.centerX)
        }
    }
    
    private func setupAppImageView() {
        
    }
    
    private func setupTimerView() {
        
        // Time
        let timeLabel = UILabel()
        timeLabel.text = "TIME"
        timeLabel.textAlignment = .center
        timeLabel.textColor = Constants.GameScreen.LabelsContainer.textColor
        timeLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        labelsContainer.addSubview(timeLabel)
        timeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(labelsContainer)
            make.trailing.equalTo(labelsContainer)
        }
        
        // Remain Time
        labelsContainer.addSubview(remainTimeLabel)
        remainTimeLabel.text = remainingTime
        remainTimeLabel.textAlignment = .center
        remainTimeLabel.textColor = .white
        remainTimeLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        remainTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom)
            make.trailing.equalTo(labelsContainer)
            make.centerX.equalTo(timeLabel.snp.centerX)
        }
    }
    
    private func setupCollectionViews() {
        
    }
    
    private func setupReadyView() {
        self.view.addSubview(readyLabel)
        readyLabel.textAlignment = .center
        readyLabel.textColor = Constants.GameScreen.ReadyView.textColor
        readyLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.ReadyView.fontSize, weight: .heavy)
        readyLabel.alpha = 0.0
        readyLabel.snp.makeConstraints { (make) in
            make.center.equalTo(self.view)
        }
    }
    
    private func setupBoardCollectionView() {
        
        // Container
        let boardContainer = UIView()
        self.view.addSubview(boardContainer)
        boardContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.labelsContainer.snp.bottom)
        }
        self.boardContainer = boardContainer
        
        // Board
        let flowLayout = BoardCollectionViewFlowLayout()
        let boardCollectionView = BoardCollectionView(frame: .zero, collectionViewLayout: flowLayout)
        boardContainer.addSubview(boardCollectionView)
        boardCollectionView.alpha = 0.0
        boardCollectionView.backgroundColor = .clear
        boardCollectionView.dataSource = boardDataSource
        boardCollectionView.delegate = self
        boardCollectionView.register(ColorCollectionViewCell.self, forCellWithReuseIdentifier: Constants.GameScreen.BoardCollectionView.cellId)
        let boardWidth = Constants.GameScreen.BoardCollectionView.boardWidth
        boardCollectionView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.height.equalTo(boardWidth)
        }
        self.boardCollectionView = boardCollectionView
    }
    
    // MARK: Event handler
    
    @objc private func didTapSettingButton() {
        
    }
    
    @objc private func didTapExitButton() {
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: Delegate

extension PlayingGameViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = Constants.GameScreen.BoardCollectionView.boardWidth/2 - 5
        return shrinkCell ? .zero : CGSize(width: itemWidth, height: itemWidth)
    }
    
    
}
