//
//  MultiPlayerViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class MultiPlayerViewController : BaseGameViewController {
    
    private var client: ClientSocket!
    private var player1 = PlayerModel(name: "You")
    private var player2 = PlayerModel(name: "Friend")
    
    var player1Point: UILabel!
    var player2Point: UILabel!
    var currenLevelLabel: UILabel!
    
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
    
    // MARK: - Setup views
    
    override func setupViews() {
        super.setupViews()
        self.setupTopContainer()
    }
    
    func setupTopContainer() {
        
        let paddingTop = 20
        let paddingLR = 30
        
        // Player 1
        let player1Title = ViewCreator.createTitleLabelForTopContainer(text: player1.name)
        topContainer.addSubview(player1Title)
        player1Title.snp.makeConstraints { (make) in
            make.top.equalTo(paddingTop)
            make.leading.equalTo(paddingLR)
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
        topContainer.addSubview(levelTitle)
        levelTitle.snp.makeConstraints { (make) in
            make.top.equalTo(paddingTop)
            make.centerX.equalToSuperview()
        }
        
        // LevelCount
        currenLevelLabel = ViewCreator.createSubTitleLabelForTopContainer(text: "0/30")
        topContainer.addSubview(currenLevelLabel)
        currenLevelLabel.snp.makeConstraints { (make) in
            make.top.equalTo(levelTitle.snp.bottom).offset(paddingTop/2)
            make.centerX.equalToSuperview()
        }
        
        // Player 2
        let player2Title = ViewCreator.createTitleLabelForTopContainer(text: player2.name)
        topContainer.addSubview(player2Title)
        player2Title.snp.makeConstraints { (make) in
            make.top.equalTo(paddingTop)
            make.trailing.equalTo(-paddingLR)
        }
        
        // Point of P2
        player2Point = ViewCreator.createSubTitleLabelForTopContainer(text: "0")
        topContainer.addSubview(player2Point)
        player2Point.snp.makeConstraints { (make) in
            make.top.equalTo(player2Title.snp.bottom).offset(paddingTop/2)
            make.centerX.equalTo(player2Title)
        }
        
    }
    
    // MARK: - Server Responde
    
    private func requirePlayerKeyFromServer(_ json: Dictionary<String, Any>) {
        self.sendRequiredKeyMessage()
    }
    
    private func waitingAnotherPlayerFromServer(_ json: Dictionary<String, Any>) {
        print("duydl: WAITING ANOTHER PLAYER!")
    }
    
    private func serverSendBoardGame(_ json: Dictionary<String, Any>) {
        
        let boardGameInfo = json["boardGame"] as! Dictionary<String, Any>
        let levelIndex: Int = boardGameInfo["round"] as! Int
        let listStringAnimation = levelIndex == 1 ? ["Matched", "3", "2", "1", "Go!"] : ["Next"]
    
        if levelIndex > 1 {
            let isOwnerWin = json["isPreviosWinner"] as! Bool
            if isOwnerWin {
                player1.currentPoint += 1
                player1Point.text = "\(player1.currentPoint)"
            } else {
                player2.currentPoint += 1
                player2Point.text = "\(player2.currentPoint)"
            }
        }
        
        currenLevelLabel.text = levelCountString()
        self.boardCollectionView.alpha = 0
        shrinkCell = true
        self.startAnimationReadyView(withList: listStringAnimation) { (done) in
            self.boardCollectionView.alpha = 1
            self.currentLevel  = self.jsonToLevelModel(json)
            self.showCurrentLevel()
        }
    }
    
    // MARK: - Send Message to Server
    
    private func sendRequiredKeyMessage() {
        // [type: keyPlayer: username:]
        let jsonString = "{\"type\":\(ClientSendType.SendRequiredKey.rawValue),\"keyPlayer\":\"\(player1.id)\",\"username\":\(player1.name)} "
        client.sendToServer(message: jsonString)
    }
    
    private func sendWinMessage() {
        let jsonString = "{\"type\":\(ClientSendType.WinLevel.rawValue),\"round\":\(currentLevel.levelIndex)} "
        client.sendToServer(message: jsonString)
    }
    
    private func sendLooseMessage() {
        let jsonString = "{\"type\":\(ClientSendType.LooseLevel.rawValue)} "
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
        return "\(currentLevel.levelIndex+1)/30"
    }
}

// MARK: - ClientDelegate

extension MultiPlayerViewController : ClientDelegate {
    func didReceiveJson(json: Dictionary<String, Any>) {
        
        let serverRespondeType = client.respondeTypeOf(json: json)
        
        switch serverRespondeType {
        case .RequirePlayerKey:
            self.requirePlayerKeyFromServer(json)
        case .WaitingAnotherPlayer:
            self.waitingAnotherPlayerFromServer(json)
        case .BoardGame:
            self.serverSendBoardGame(json)
        default:
            print("duydl: UNKNOW MESSAGE TYPE OF SERVER")
        }
    }
}
