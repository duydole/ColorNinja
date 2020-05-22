//
//  RoomGameViewController.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/19/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

class RoomGameViewController: MultiPlayerViewController {
    
    var roomId: Int = -1
    
    var roomIdLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func setupViews() {
        super.setupViews()
        setupRoomId()
    }
    
    private func setupRoomId() {
        roomIdLabel = UILabel()
        roomIdLabel.text = "Room ID: -"
        roomIdLabel.textColor = .white
        roomIdLabel.font = UIFont(name: Font.squirk, size: 25)
        view.addSubview(roomIdLabel)
        roomIdLabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(settingButton)
            make.centerX.equalToSuperview()
        }
    }
    
    private func showWaitingInRoomStatus() {
        showStatus(message: "Share RoomId \(roomId) to your friend :D")
    }
            
    // MARK: Server responde

    override func serverSendRoomInfo(_ json: Dictionary<String, Any>) {
        super.serverSendRoomInfo(json)
        
        let groupId = json["groupId"] as! String
        roomId = groupId.toInt()
        updateRoomId(id: roomId)
        showWaitingInRoomStatus()
    }
    
    override func requirePlayerKeyFromServer(_ json: Dictionary<String, Any>) {
        super.requirePlayerKeyFromServer(json)
        
        if roomId == -1 {
            super.requirePlayerKeyFromServer(json)
        } else {
            joinExistedRoom()
        }
    }
    
    override func serverSendRoomIsNotExisted(_ json: Dictionary<String, Any>) {
        super.serverSendRoomIsNotExisted(json)
        showAlertWithMessage(message: "Room is not existed. You are in new room with id \(roomId)")
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: Client send to server
    
    override func sendRequiredKeyMessage() {
        let jsonString = "{\"type\":\(ClientSendType.SendRequiredKeyGroupMode.rawValue),\"keyPlayer\":\"\(player1.id)\",\"username\":\(player1.name)} "
        client.sendToServer(message: jsonString)
    }
    
    func sendJoinRoomRequestToServer() {
        let jsonString = "{\"type\":\(ClientSendType.SendRequiredKeyGroupMode.rawValue),\"keyPlayer\":\"\(player1.id)\",\"username\":\(player1.name),\"groupId\":\"\(roomId.toString())\"} "
        client.sendToServer(message: jsonString)
    }
    
    // MARK: Private
    
    private func joinExistedRoom() {
        updateRoomId(id: roomId)
        sendJoinRoomRequestToServer()
    }
    
    private func updateRoomId(id: Int) {
        roomIdLabel.text = "Room Id: \(id)"
    }
}
