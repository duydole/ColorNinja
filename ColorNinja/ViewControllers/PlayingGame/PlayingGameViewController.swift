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
import AudioToolbox

class PlayingGameViewController : BaseViewController {
    
    var levelCountLabel : UILabel!
    var appImage : UIImageView!
    var remainTimeLabel : UILabel!
    var labelsContainer : UIView!
    var readyLabel : UILabel!
    var readyListString : [String] = ["3","2","1","Go!"]
    
    var remainingTime : TimeInterval = 2.0
    var boardContainer : UIView!
    var boardCollectionView : BoardCollectionView!
    let boardDataSource: BoardDataSource = BoardDataSource()
    var shrinkCell : Bool = true
    var timer : Timer!
    
    var currentLevel : LevelModel = LevelStore.shared.allLevels[0]
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        LevelStore.shared.setColorForAllLevels()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        // Animation ReadyView
        self.animationReadyView(index: 0) { (done) in
            self.currentLevel.cellWidth = self.cellWidthOfLevel(level: self.currentLevel)
            self.showCurrentLevel()
            if self.presentedViewController == nil {
                self.startTimer()
            }
        }
    }
    
    // MARK: - Handle Animations
    
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
            Thread.sleep(forTimeInterval: 0.3)
            self.readyLabel.transform = CGAffineTransform(scaleX: 1/0.4, y: 1/0.4)
            self.readyLabel.alpha = 0.0
            self.animationReadyView(index: index + 1, completion: completion)
        }
    }
    
    private func zoomX2LabelAnimation(label: UILabel, text: String) {
        label.text = text
        UIView.animate(withDuration: 0.2, animations: {
            label.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2) {
                label.transform = CGAffineTransform(scaleX: CGFloat(1.0), y: CGFloat(1.0))
            }
        })
    }
    
    // MARK: - Setup views
    
    override func setupViews() {
        super.setupViews()
        
        self.setupLabelsContainer()
        self.setupLevelViews()
        self.setupAppImageView()
        self.setupTimerView()
        self.setupCollectionViews()
        self.setupReadyView()        
        self.setupBoardCollectionView()
    }
            
    private func setupLabelsContainer() {
        labelsContainer = UIView()
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
        levelCountLabel = UILabel()
        labelsContainer.addSubview(levelCountLabel)
        levelCountLabel.text = "1"
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
        remainTimeLabel = UILabel()
        labelsContainer.addSubview(remainTimeLabel)
        remainTimeLabel.text = self.currentRemainTimeString()
        remainTimeLabel.textColor = .white
        remainTimeLabel.font = UIFont.systemFont(ofSize: Constants.GameScreen.LabelsContainer.fontSize, weight: .bold)
        remainTimeLabel.snp.makeConstraints { (make) in
            make.top.equalTo(timeLabel.snp.bottom)
            make.left.equalTo(timeLabel.snp.left)
        }
    }
    
    private func setupCollectionViews() {
        
    }
    
    private func setupReadyView() {
        readyLabel = UILabel()
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
        boardContainer = UIView()
        self.view.addSubview(boardContainer)
        boardContainer.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(self.labelsContainer.snp.bottom)
        }
        
        // Board
        let flowLayout = BoardCollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0.0
        flowLayout.minimumLineSpacing = Constants.GameScreen.BoardCollectionView.spacingBetweenCells
        boardCollectionView = BoardCollectionView(frame: .zero, collectionViewLayout: flowLayout)
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
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        .lightContent
    }
    
    // MARK: - Handle Timer
    
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            self.remainingTime -= 0.01
            self.remainTimeLabel.text = self.currentRemainTimeString()
            
            // stop timer
            if self.remainingTime < 0.001 {
                self.processGameOver()
            }
        })
    }
    
    private func stopTimer() {
        if timer == nil {
            return
        }
        
        self.timer.invalidate()
        self.timer = nil
    }
    
    private func pauseTimer() {
        self.stopTimer()
    }
    
    private func resumeTimer() {
        self.startTimer()
    }
    
    // MARK: - Game Flow
    
    private func processGameOver() {
        
        // Reset CountDownLabel
        self.remainingTime = 0.00
        self.remainTimeLabel.text = self.currentRemainTimeString()
        
        // StopTimer
        self.stopTimer()
        
        // Show Popup GameOver
        let gameOverPopup = GameOverPopup()
        gameOverPopup.modalPresentationStyle = .overCurrentContext
        gameOverPopup.gameOverDelegate = self
        self.present(gameOverPopup, animated: false, completion: nil)
    }
    
    private func showCurrentLevel() {
        
        // Update level for DataSource
        boardDataSource.levelModel = currentLevel
        
        // ReloadData
        self.boardCollectionView.reloadData()
        self.boardCollectionView.layoutIfNeeded()
        
        // ReloadItems to gain animations:
        self.boardCollectionView.alpha = 1.0
        self.shrinkCell = false
        self.boardCollectionView.reloadItems(at: self.boardCollectionView.indexPathsForVisibleItems)
    }
    
    private func pauseGame() {
        self.pauseTimer()
    }
    
    private func resumeGame() {
        if remainingTime > 0 {
            self.startTimer()
        }
    }
    
    private func replayGame() {
        
        // Reset lại View
        remainingTime = Constants.GameSetting.maxRemainTime
        self.remainTimeLabel.text = self.currentRemainTimeString()
        levelCountLabel.text = "1"
        
        // Reset lại model
        LevelStore.shared.setColorForAllLevels()
        currentLevel = LevelStore.shared.allLevels[0]

        self.showCurrentLevel()
        self.resumeGame()
    }

    // MARK: - Event handler
    
    @objc override func didTapSettingButton() {
        
        // PauseTimer
        self.pauseGame()
        
        // Present Popup
        let gameSettingPopup = GameSettingPopup()
        gameSettingPopup.modalPresentationStyle = .overCurrentContext
        self.present(gameSettingPopup, animated: false, completion: nil)
        gameSettingPopup.didDismissPopUp = {
            self.resumeGame()
        }
    }

    // MARK: - Handle Audio
    
    private func vibrateDevice() {
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
    }
    
    // MARK: - Getter
    
    private func cellWidthOfLevel(level: LevelModel) -> CGFloat {
        let N: CGFloat = CGFloat(level.numberOfRows)
        let spacing: CGFloat = Constants.GameScreen.BoardCollectionView.spacingBetweenCells
        let boardWidth: CGFloat = Constants.GameScreen.BoardCollectionView.boardWidth
        let itemWidth = (boardWidth - (N - 1) * spacing) / N
        return itemWidth
    }
    
    private func currentRemainTimeString() -> String {
        return String(format: "%.2f", self.remainingTime)
    }
}

// MARK: - CollectionView Delegate

extension PlayingGameViewController : UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - Delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = currentLevel.cellWidth
        return shrinkCell ? .zero : CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if indexPath.item == currentLevel.correctIndex {
            remainingTime += 1.0
            
            if GameSettingManager.shared.allowEffectSound {
                GameMusicPlayer.shared.playCorrectSound()
            }
            
            self.goToNextLevel()
        } else {
            remainingTime -= 0.5
            
            if GameSettingManager.shared.allowEffectSound {
                self.vibrateDevice()
                GameMusicPlayer.shared.playInCorrectSound()
            }
        }
    }
    
    // MARK: - Private Methods
    
    private func goToNextLevel() {
                
        // Update current LevelModel
        let nextLevel = LevelStore.shared.allLevels[currentLevel.levelIndex + 1]
        currentLevel = nextLevel
        nextLevel.cellWidth = self.cellWidthOfLevel(level: nextLevel)
        
        // Update LevelCount
        self.zoomX2LabelAnimation(label: levelCountLabel, text: "\(nextLevel.levelIndex + 1)")
        
        self.showCurrentLevel()
    }
}

// MARK: - GameOverPopup Delegate

extension PlayingGameViewController: GameOverPopupDelegate {
    
    func didTapGoHomeButton() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func didTapReplayButton() {
        self.replayGame()
    }
}
