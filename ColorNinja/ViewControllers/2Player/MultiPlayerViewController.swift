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
    private var player2 = PlayerModel(name: "Nam")
    
    var player1Point: UILabel!
    var player2Point: UILabel!
    var currenLevelLabel: UILabel!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        client = ClientSocket(connectWithHost: "119.82.135.105", port: 8080)
        client.delegate = self
        

//        // Test
        LevelStore.shared.setColorForAllLevels()
        currentLevel = LevelStore.shared.allLevels[0]
        showCurrentLevel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        client.close()
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
    
    // MARK: - Communication with Server
    
    private func requirePlayerKeyFromServer(_ json: Dictionary<String, Any>) {
        
        let jsonString = "{\"type\":\(ClientSendType.SendRequiredKey.rawValue),\"key\":\"\(UUID().uuidString)\"} "
        client.sendToServer(message: jsonString)

//        let dic: Dictionary<String, Any> = [
//            "type": ServerRespondeType.RequirePlayerKey.rawValue,
//            "key": UUID().uuidString
//        ]
//
//
//        let encoder = JSONEncoder()
//        if let jsonData = try? encoder.encode(data) {
//            if let jsonString = String(data: jsonData, encoding: .utf8) {
//                let message = jsonString + " "
//                client.sendToServer(message: message)
//            }
//        }
    }
    
    private func waitingAnotherPlayerFromServer(_ json: Dictionary<String, Any>) {
        print("duydl: Waiting another player")
    }
    
    private func serverSendBoardGame(_ json: Dictionary<String, Any>) {
        self.startAnimationReadyView(withList: ["Matched", "3", "2", "1", "Go"]) { (done) in
            self.currentLevel  = self.jsonToLevelModel(json)
            self.showCurrentLevel()
        }
    }
    
    
    private func jsonToLevelModel(_ json: Dictionary<String, Any>) -> LevelModel {
        return LevelModel(levelIndex: 1)
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