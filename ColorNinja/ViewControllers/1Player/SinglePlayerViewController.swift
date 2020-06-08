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


let INIT_REMAIN_TIME: TimeInterval = 2.0

class SinglePlayerViewController : BaseGameViewController {
  
  private var lightBulbButton: UIButton!
  private var levelCountLabel : UILabel!
  private var promptCountLable : UILabel!
  private var appImage : UIImageView!
  private var remainTimeLabel : UILabel!
  private var didResumeWithRewards: Bool = false
  
  var remainingTime : TimeInterval = INIT_REMAIN_TIME
  var timer : Timer!
  
  // MARK: Life Cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    currentLevel = LevelStore.shared.allLevels[0]
  }
  
  override func viewWillAppear(_ animated: Bool) {
    LevelStore.shared.setColorForAllLevels()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    
    // Animation ReadyView
    self.startAnimationReadyView(withList: ["Ready","3","2","1","Go!"]) { (done) in
      self.showCurrentLevel()
      if self.presentedViewController == nil {
        self.startTimer()
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    stopTimer()
  }
  
  // MARK: Handle Animations
  
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
  
  // MARK: Setup views
  
  override func setupViews() {
    super.setupViews()
    
    setupViewsInTopContainer()
    setupPromptCount()
  }
  
  private func setupViewsInTopContainer() {
    
    let paddingTop: CGFloat = scaledValue(35)
    let paddingLeftRight: CGFloat = scaledValue(30)
        
    // Level
    let levelLabel = ViewCreator.createTitleLabelForTopContainer(text: "LEVEL")
    topContainer.addSubview(levelLabel)
    levelLabel.snp.makeConstraints { (make) in
      make.top.equalTo(paddingTop)
      make.leading.equalTo(paddingLeftRight)
    }
    
    // Level Count
    levelCountLabel = ViewCreator.createSubTitleLabelForTopContainer(text: "1")
    topContainer.addSubview(levelCountLabel)
    levelCountLabel.snp.makeConstraints { (make) in
      make.top.equalTo(levelLabel.snp.bottom)
      make.leading.equalTo(topContainer)
      make.centerX.equalTo(levelLabel.snp.centerX)
    }
    
    // Time
    let timeLabel = ViewCreator.createTitleLabelForTopContainer(text: "TIME")
    topContainer.addSubview(timeLabel)
    timeLabel.snp.makeConstraints { (make) in
      make.top.equalTo(paddingTop)
      make.trailing.equalTo(-paddingLeftRight)
    }
    
    // Remaing Time
    remainTimeLabel = ViewCreator.createSubTitleLabelForTopContainer(text: self.currentRemainTimeString())
    topContainer.addSubview(remainTimeLabel)
    remainTimeLabel.snp.makeConstraints { (make) in
      make.top.equalTo(timeLabel.snp.bottom)
      make.left.equalTo(timeLabel.snp.left)
    }
    
    
    // Add lightbulb
    lightBulbButton = UIButton()
    lightBulbButton.setImage(UIImage(named: "lightbulb"), for: .normal)
    lightBulbButton.addTarget(self, action: #selector(didTapLightBubButton), for: .touchUpInside)
    view.addSubview(lightBulbButton)
    lightBulbButton.snp.makeConstraints { (make) in
      make.bottom.equalTo(levelLabel)
      make.width.height.equalTo(scaledValue(70))
      make.centerX.equalToSuperview()
    }
  }
  
  private func setupPromptCount() {
    promptCountLable = ViewCreator.createSubTitleLabelForTopContainer(text: "\(OwnerInfo.shared.countPrompt)")
    topContainer.addSubview(promptCountLable)
    promptCountLable.snp.makeConstraints { (make) in
      make.bottom.equalTo(levelCountLabel)
      make.centerX.equalToSuperview()
    }
  }
  
  // MARK: Handle Timer
  
  private func startTimer() {
    weak var weakS = self
    timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
      guard let weakSelf = weakS else { return }
      weakSelf.remainingTime -= 0.01
      weakSelf.remainTimeLabel.text = weakSelf.currentRemainTimeString()
      
      // stop timer
      if weakSelf.remainingTime < 0.001 {
        weakSelf.processGameOver()
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
  
  // MARK: Game Flow
  
  private func processGameOver() {
    
    // Loading...
    activityIndicator.startAnimating()
    
    // Reset CountDownLabel
    self.remainingTime = 0.00
    self.remainTimeLabel.text = self.currentRemainTimeString()
    
    // StopTimer
    self.stopTimer()
    
    // Increase CountRoundDidPlay
    OwnerInfo.shared.increaseCountRoundDidPlay()
    
    // Increase CountPrompt
    let curPromt = OwnerInfo.shared.countPrompt
    OwnerInfo.shared.updateCountPrompt(newCountPrompt: curPromt + 1)
    
    // Update Max Score
    let resultScored = currentLevel.levelIndex + 1
    if resultScored > OwnerInfo.shared.bestScore {
      OwnerInfo.shared.updateBestScore(newBestScore: resultScored)
    }
    
    /// Luôn luôn quăng score lên Server để server tự update.
    DataBaseService.shared.updateBestScoreForUser(userid: OwnerInfo.shared.userId, newBestScore: resultScored) { (success, error) in
      if let _ = error {
        assert(false)
        return
      }
      
      self.getRankAndShowGameOverPopup()
    }
  }
  
  private func getRankAndShowGameOverPopup() {
    DataBaseService.shared.loadUserRank(user: OwnerInfo.shared.toUser()) { (rank) in
      OwnerInfo.shared.updateUserRank(newRank: rank)
      DispatchQueue.main.async {
        
        // Stop animator
        self.activityIndicator.stopAnimating()
        
        // Show Popup GameOver
        let gameOverPopup = GameOverPopup()
        if self.didResumeWithRewards {
          gameOverPopup.allowWatchAdsToGainReward = false
        }
        gameOverPopup.modalPresentationStyle = .overCurrentContext
        let user = OwnerInfo.shared.toUser()
        gameOverPopup.resultModel = ResultGameModel(user: user, score: self.currentLevel.levelIndex + 1)
        gameOverPopup.delegate = self
        self.present(gameOverPopup, animated: false, completion: nil)
      }
    }
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
  
  private func goToNextLevel() {
    
    // Update current LevelModel
    let nextLevel = LevelStore.shared.allLevels[currentLevel.levelIndex + 1]
    currentLevel = nextLevel
    
    // Update LevelCount
    self.zoomX2LabelAnimation(label: levelCountLabel, text: "\(nextLevel.levelIndex + 1)")
    
    self.showCurrentLevel()
  }
  
  // MARK: Event handler
  
  @objc func didTapLightBubButton() {
    if OwnerInfo.shared.countPrompt > 0 && remainingTime != INIT_REMAIN_TIME {
      let curCountPrompt = OwnerInfo.shared.countPrompt
      OwnerInfo.shared.updateCountPrompt(newCountPrompt: curCountPrompt - 1)
      promptCountLable.text = "\(curCountPrompt - 1)"
      shakeResultCell()
    }
  }

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
    
  // MARK: Handle Audio
  
  private func vibrateDevice() {
    AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
  }
  
  // MARK: Handle boardgame animation
  
  private func shakeResultCell() {
    let resultIndexPath = IndexPath(item: currentLevel.correctIndex, section: 0)
    shakeCellAtIndexPath(indexPath: resultIndexPath)
  }
  
  private func shakeCellAtIndexPath(indexPath: IndexPath) {
    
    let cell = boardCollectionView.cellForItem(at: indexPath)
    UIView.animate(withDuration: 0.05, animations: {
      cell?.center.x -= 5
    }) { (success) in
      UIView.animate(withDuration: 0.1, animations: {
        cell?.center.x += 10
      }) { (success) in
        UIView.animate(withDuration: 0.05, animations: {
          cell?.center.x -= 5
        }) { (success) in
          
        }
      }
    }
    
  }

  // MARK: Getter
  
  private func currentRemainTimeString() -> String {
    return String(format: "%.2f", self.remainingTime)
  }
}

// MARK: CollectionView Delegate

extension SinglePlayerViewController {
    
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
        shakeCellAtIndexPath(indexPath: indexPath)
        GameMusicPlayer.shared.playInCorrectSound()
      }
    }
  }
}


// MARK: GameOverPopup Delegate

extension SinglePlayerViewController: GameOverPopupDelegate {
  
  func didTapGoHomeButton() {
    self.dismiss(animated: false, completion: nil)
  }
  
  func didTapReplayButton() {
    didResumeWithRewards = false    /// can watch ads to continue play game
    promptCountLable.text = "\(OwnerInfo.shared.countPrompt)"
    self.replayGame()
  }
  
  func didEarnedRewardToContinuePlay(reward: Int) {
    if reward > 0 {
      // Cann't watch ads to earn reward anymore.
      didResumeWithRewards = true
      
      // Reset lại View
      remainingTime = Double(reward)
      self.remainTimeLabel.text = self.currentRemainTimeString()
      
      self.resumeGame()
    } else {
      self.dismiss(animated: false, completion: nil)
    }
  }
}
