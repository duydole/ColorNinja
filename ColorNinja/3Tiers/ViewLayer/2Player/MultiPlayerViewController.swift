//
//  MultiPlayerViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

#if DEBUG
let MAX_LEVEL: Int = 30
#else
let MAX_LEVEL: Int = 30
#endif
let serverIp = "http://colorninjagame.tk"
let serverPort: UInt32 = 8080

class MultiPlayerViewController : BaseGameViewController {
  
  var client: ClientSocket!
  var player1 = OwnerInfo.shared.toUser()
  var player2 = User(username: "----")
  
  private var player1Title: UILabel!
  private var player2Title: UILabel!
  
  private var player1Point: UILabel!
  private var player2Point: UILabel!
  
  private var currenLevelLabel: UILabel!
  private var statusLabel: UILabel!
  private var rematchButton: UIButton!
  private var centerImageView: UIImageView!
  
  private var p1Score: Int = 0
  private var p2Score: Int = 0
  
  // MARK: - Life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setupClientSocket()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    client.close()
  }
  
  private func setupClientSocket() {
    client = ClientSocket(connectWithHost: serverIp, port: serverPort)
    client.delegate = self
  }
  
  func showStatus(message: String) {
    statusLabel.isHidden = false
    statusLabel.text = message
  }
  
  // MARK: - Setup views
  
  override func setupViews() {
    super.setupViews()
    setupTopContainer()
    setupStatusLabel()
    setupRematchViews()
    setupCenterImageView()
  }
  
  func setupTopContainer() {
    
    let paddingTop = scaledValue(20)
    let paddingLR = scaledValue(30)
    let maxUserNameLabelWidth = scaledValue(100)
    
    // Player 1
    player1Title = ViewCreator.createTitleLabelForTopContainer(text: getRealNameWithoutPlus(name: player1.username))
    topContainer.addSubview(player1Title)
    player1Title.snp.makeConstraints { (make) in
      make.top.equalTo(paddingTop)
      make.leading.equalTo(paddingLR)
      make.width.equalTo(maxUserNameLabelWidth)
    }
    
    // Point of P1
    player1Point = ViewCreator.createSubTitleLabelForTopContainer(text: "0")
    topContainer.addSubview(player1Point)
    player1Point.snp.makeConstraints { (make) in
      make.top.equalTo(player1Title.snp.bottom).offset(paddingTop/2)
      make.centerX.equalTo(player1Title)
    }
    
    // Level
    let levelTitle = ViewCreator.createTitleLabelForTopContainer(text: "LEVEL")
    levelTitle.font = UIFont.systemFont(ofSize: scaledValue(25), weight: .bold)
    topContainer.addSubview(levelTitle)
    levelTitle.snp.makeConstraints { (make) in
      make.bottom.equalTo(player1Title)
      make.centerX.equalToSuperview()
    }
    
    // LevelCount
    currenLevelLabel = ViewCreator.createSubTitleLabelForTopContainer(text: "0/\(MAX_LEVEL)")
    topContainer.addSubview(currenLevelLabel)
    currenLevelLabel.snp.makeConstraints { (make) in
      make.top.equalTo(levelTitle.snp.bottom).offset(paddingTop/2)
      make.centerX.equalToSuperview()
    }
    
    // Player 2
    player2Title = ViewCreator.createTitleLabelForTopContainer(text: getRealNameWithoutPlus(name: player2.username))
    topContainer.addSubview(player2Title)
    player2Title.snp.makeConstraints { (make) in
      make.top.equalTo(paddingTop)
      make.trailing.equalTo(-paddingLR)
      make.width.equalTo(maxUserNameLabelWidth)
    }
    
    // Point of P2
    player2Point = ViewCreator.createSubTitleLabelForTopContainer(text: "0")
    topContainer.addSubview(player2Point)
    player2Point.snp.makeConstraints { (make) in
      make.top.equalTo(player2Title.snp.bottom).offset(paddingTop/2)
      make.centerX.equalTo(player2Title)
    }
    
  }
  
  func setupStatusLabel() {
    statusLabel = UILabel()
    statusLabel.textColor = .yellow
    statusLabel.font = UIFont.systemFont(ofSize: scaledValue(20), weight: .bold)
    view.addSubview(statusLabel)
    statusLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
    }
  }
  
  func setupRematchViews() {
    rematchButton = UIButton()
    rematchButton.isHidden = true
    rematchButton.setTitle("REMATCH", for: .normal)
    rematchButton.backgroundColor = .white
    rematchButton.titleLabel!.font = UIFont(name: Font.squirk, size: scaledValue(30))
    rematchButton.layer.cornerRadius = scaledValue(13)
    rematchButton.makeShadow()
    rematchButton.setTitleColor(.black, for: .normal)
    view.addSubview(rematchButton)
    rematchButton.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.equalTo(scaledValue(200))
    }
    
    rematchButton.addTarget(self, action: #selector(didTapRematchButton), for: .touchUpInside)
  }
  
  func setupCenterImageView() {
    let imageWidth = scaledValue(350)
    centerImageView = UIImageView()
    centerImageView.isHidden = true
    view.addSubview(centerImageView)
    centerImageView.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
      make.width.height.equalTo(imageWidth)
    }
  }
  
  // MARK: - Server Responde
  
  func requirePlayerKeyFromServer(_ json: Dictionary<String, Any>) {
    self.sendRequiredKeyMessage()
  }
  
  private func waitingAnotherPlayerFromServer(_ json: Dictionary<String, Any>) {
    showStatus(message: "Looking for competitor...")
  }
  
  private func serverSendBoardGame(_ json: Dictionary<String, Any>) {
    
    // workaround:
    // Không hiểu nhiều khi nó không ẩn
    if statusLabel.isHidden == false {
      statusLabel.isHidden = true
    }
    
    let boardGameInfo = json["boardGame"] as! Dictionary<String, Any>
    let levelIndex: Int = boardGameInfo["round"] as! Int
    let isOwnerWin = json["isPreviousWinner"] as! Bool
    let isFirstGame = levelIndex == 1
    
    if !isFirstGame {
      increaseScoreView(isOwnerWin: isOwnerWin)
    }
    
    let overMaxLevel = levelIndex == MAX_LEVEL + 1
    if overMaxLevel {
      requireServerStopGame()
      return
    }
    
    currenLevelLabel.text = "\(levelIndex)/\(MAX_LEVEL)"
    self.boardCollectionView.alpha = 0
    shrinkCell = true
    
    // Nếu game đầu tiên:
    if (isFirstGame) {
      startAnimationReadyView(withList: ["Matched", "3", "2", "1", "Go!"]) { (done) in
        self.showCurrentLevelWithJson(json: json)
      }
    } else {
      let scaleFactor: CGFloat = 0.2
      if isOwnerWin {
        centerImageView.image = UIImage(named: "winicon")
        animationImageView(imageView: centerImageView, scale: scaleFactor, completion:  {
          self.showCurrentLevelWithJson(json: json)

        })
      } else {
        centerImageView.image = UIImage(named: "looseicon")
        animationImageView(imageView: centerImageView, scale: scaleFactor, completion: {
          self.showCurrentLevelWithJson(json: json)
        })
      }
    }
  }
  
  private func animationImageView(imageView: UIImageView, scale: CGFloat, completion: (() -> ())?) {
    UIView.animate(withDuration: 0.35, delay: 0.0, options: .curveEaseInOut, animations: {
      self.centerImageView.isHidden = false
      self.centerImageView.transform = CGAffineTransform(scaleX: scale, y: scale)
    }) { (success) in
      Thread.sleep(forTimeInterval: 0.3)
      self.centerImageView.isHidden = true
      self.centerImageView.transform = .identity
      completion?()
    }
  }
  
  private func increaseScoreView(isOwnerWin: Bool) {
    if isOwnerWin {
      p1Score += 1
      zoomLabelAnimation(scale: 3, label: player1Point, text: "\(p1Score)")
    } else {
      p2Score += 1
      zoomLabelAnimation(scale: 3, label: player2Point, text: "\(p2Score)")
    }
  }
  
  private func showCurrentLevelWithJson(json: Dictionary<String, Any>) {
    self.boardCollectionView.alpha = 1
    self.currentLevel  = self.jsonToLevelModel(json)
    self.showCurrentLevel()
  }
  
  private func serverSendMatchedInfo(_ json: Dictionary<String, Any>) {
    print("duydl: Server send MatchedInfo")
    let usernames = json["key_usernames"] as! Dictionary<String, String>
    for id in usernames.keys {
      if id != player1.userId {
        player2Title.text = getRealNameWithoutPlus(name: usernames[id] ?? "")
        player2.userId = id
        player2.username = player2Title.text!
      }
    }
    
    self.statusLabel.isHidden = true
    self.boardCollectionView.isHidden = false
    self.rematchButton.isHidden = true
  }
  
  private func serverSendFinalResult(_ json: Dictionary<String, Any>) {
    
    // SERVER: {"keyWinner":"BotNam2738","winnerscore":30,"scorePlayers":[{"keyPlayer":"BotNam2738","score":30},{"keyPlayer":"618BC71B-8479-4BC6-B2FA-B860159B222E","score":0}],"type":4,"message":""}
    let winnerName = getRealNameWithoutPlus(name: p1Score > p2Score ? player1.username : player2.username)
    let looserName = getRealNameWithoutPlus(name: p1Score < p2Score ? player1.username : player2.username)
    
    let winnerScore = json["winnerscore"] as! Int
    player1Point.text = p1Score > p2Score ? "\(winnerScore)" : "\(MAX_LEVEL - winnerScore)"
    player2Point.text = p2Score > p1Score ? "\(winnerScore)" : "\(MAX_LEVEL - winnerScore)"
    
    let alert = UIAlertController(title: "GameOver", message: "\(winnerName) won, \(looserName) is too slow!", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
      self.showRematchButton()
    }))
    self.present(alert, animated: true, completion: nil)
  }
  
  func serverSendRoomInfo(_ json: Dictionary<String, Any>) {
    
  }
  
  func serverSendRoomIsNotExisted(_ json: Dictionary<String, Any>) {
    
  }
  
  func serverSendCompetitorOutRoom(_ json: Dictionary<String, Any>) {
    showAlertWithMessage(message: "Your competitor disconnected!")
  }
  
  // MARK: - Send Message to Server
  
  func sendRequiredKeyMessage() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      let jsonString = "{\"type\":\(ClientSendType.SendRequiredKey.rawValue),\"keyPlayer\":\"\(self.player1.userId)\",\"username\":\(self.player1.username)} "
      self.client.sendToServer(message: jsonString)
    }
  }
  
  private func sendWinMessage() {
    let jsonString = "{\"type\":\(ClientSendType.WinLevel.rawValue),\"round\":\(currentLevel.levelIndex)} "
    client.sendToServer(message: jsonString)
  }
  
  private func sendLooseMessage() {
    let jsonString = "{\"type\":\(ClientSendType.LooseLevel.rawValue),\"round\":\(currentLevel.levelIndex)} "
    client.sendToServer(message: jsonString)
  }
  
  private func requireServerStopGame() {
    let jsonString = "{\"type\":\(ClientSendType.StopGame.rawValue)} "
    client.sendToServer(message: jsonString)
  }
  
  // MARK: - Board Delegate
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    if indexPath.item == currentLevel.correctIndex {
      if GameSettingManager.shared.allowEffectSound {
        GameMusicPlayer.shared.playCorrectSound()
      }
      sendWinMessage()
    } else {
      if GameSettingManager.shared.allowEffectSound {
        GameMusicPlayer.shared.playInCorrectSound()
      }
      sendLooseMessage()
    }
  }
  
  // MARK: Handle Events
  
  @objc func didTapRematchButton() {
    resetAllViewsAndData()
    sendRematchToServer()
    
    rematchButton.isHidden = true
    showStatus(message: "Waiting your competitor to rematch! ^.^")
  }
  
  private func resetAllViewsAndData() {
    player1Point.text = "0"
    player2Point.text = "0"
    currenLevelLabel.text = "0/\(MAX_LEVEL)"
    
    p1Score = 0
    p2Score = 0
  }
  
  private func sendRematchToServer() {
    let jsonString = "{\"type\":\(ClientSendType.RequireRematch.rawValue)} "
    client.sendToServer(message: jsonString)
  }
  
  // MARK: - Other
  
  private func jsonToLevelModel(_ json: Dictionary<String, Any>) -> LevelModel {
    let boardGameInfo = json["boardGame"] as! Dictionary<String, Any>
    let levelIndex: Int = boardGameInfo["round"] as! Int
    let mainColorIndex: Int = boardGameInfo["color"] as! Int
    let correctIndex: Int = boardGameInfo["index"] as! Int
    let numberOfRows = boardGameInfo["sizeBoard"] as! Int
    let mainColor = ColorStore.shared.allColors[mainColorIndex%ColorStore.shared.allColors.count]
    let RGBIndexWillBeChanged = boardGameInfo["secondColor"] as! Int
    return LevelModel(levelIndex: levelIndex,
                      numberOfRows: numberOfRows,
                      mainColor: mainColor,
                      correctIndex: correctIndex,
                      RGBIndexWillBeChanged: RGBIndexWillBeChanged)
  }
  
  private func showRematchButton() {
    boardCollectionView.isHidden = true
    rematchButton.isHidden = false
  }
}

// MARK: - ClientDelegate

extension MultiPlayerViewController : ClientDelegate {
  func didReceiveJson(json: Dictionary<String, Any>) {
    
    let serverRespondeType = client.respondeTypeOf(json: json)
    
    switch serverRespondeType {
    case .RequirePlayerKey:
      requirePlayerKeyFromServer(json)
    case .WaitingAnotherPlayer:
      waitingAnotherPlayerFromServer(json)
    case .BoardGame:
      serverSendBoardGame(json)
    case .MatchedInfo:
      serverSendMatchedInfo(json)
    case .LevelResult:
      serverSendFinalResult(json)
    case .RoomInfo:
      serverSendRoomInfo(json)
    case .RoomIsNotExisted:
      serverSendRoomIsNotExisted(json)
    case .CompetitorOutRoom:
      serverSendCompetitorOutRoom(json)
    case .RoundExpried:
      break
    default:
      if NetworkManager.shared.hasConnection {
        showAlertWithMessage(message: json["message"] as! String)
      } else {
        showAlertWithMessage(message: "Sorry. Please check your network connection!")
      }
      print("duydl: UNKNOW MESSAGE TYPE OF SERVER")
    }
  }
}
