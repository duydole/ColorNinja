//
//  MultiPlayerViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

let MAX_LEVEL: Int = 30

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
  
  override func viewDidAppear(_ animated: Bool) {
    
  }
  
  private func setupClientSocket() {
    client = ClientSocket(connectWithHost: "119.82.135.105", port: 8080)
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
    statusLabel.font = UIFont.systemFont(ofSize: scaledValue(23), weight: .bold)
    view.addSubview(statusLabel)
    statusLabel.snp.makeConstraints { (make) in
      make.center.equalToSuperview()
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
    let listStringAnimation = levelIndex == 1 ? ["Matched", "3", "2", "1", "Go!"] : ["Next"]
    
    if levelIndex > 1 {
      let isOwnerWin = json["isPreviousWinner"] as! Bool
      if isOwnerWin {
        p1Score += 1
        zoomLabelAnimation(scale: 3, label: player1Point, text: "\(p1Score)")
      } else {
        p2Score += 1
        zoomLabelAnimation(scale: 3, label: player2Point, text: "\(p2Score)")
      }
    }
    
    if levelIndex == MAX_LEVEL + 1 {
      requireServerStopGame()
      return
    }
    
    currenLevelLabel.text = levelCountString()
    self.boardCollectionView.alpha = 0
    shrinkCell = true
    
    print("duydl: Start Animation Matched, 3, 2, 1")
    self.startAnimationReadyView(withList: listStringAnimation) { (done) in
      self.boardCollectionView.alpha = 1
      self.currentLevel  = self.jsonToLevelModel(json)
      self.showCurrentLevel()
    }
  }
  
  private func serverSendMatchedInfo(_ json: Dictionary<String, Any>) {
    let usernames = json["key_usernames"] as! Dictionary<String, String>
    for id in usernames.keys {
      if id != player1.userId {
        player2Title.text = getRealNameWithoutPlus(name: usernames[id] ?? "")
        player2.userId = id
        player2.username = player2Title.text!
      }
    }
    
    self.statusLabel.isHidden = true
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
      self.dismiss(animated: true, completion: nil)
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
  
  // MARK: - Other
  
  private func jsonToLevelModel(_ json: Dictionary<String, Any>) -> LevelModel {
    let boardGameInfo = json["boardGame"] as! Dictionary<String, Any>
    let levelIndex: Int = boardGameInfo["round"] as! Int
    let mainColorIndex: Int = boardGameInfo["color"] as! Int
    let correctIndex: Int = boardGameInfo["index"] as! Int
    let numberOfRows = boardGameInfo["sizeBoard"] as! Int
    let mainColor = ColorStore.shared.allColors[mainColorIndex]
    let RGBIndexWillBeChanged = boardGameInfo["secondColor"] as! Int
    return LevelModel(levelIndex: levelIndex,
                      numberOfRows: numberOfRows,
                      mainColor: mainColor,
                      correctIndex: correctIndex,
                      RGBIndexWillBeChanged: RGBIndexWillBeChanged)
  }
  
  private func levelCountString() -> String {
    return "\(currentLevel.levelIndex+1)/\(MAX_LEVEL)"
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
