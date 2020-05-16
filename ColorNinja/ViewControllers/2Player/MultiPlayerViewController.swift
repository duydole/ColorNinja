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
    override var readyListString: [String] {
        return ["Matched", "Ready", "3", "2", "1", "Go!"]
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        client = ClientSocket(connectWithHost: "119.82.135.105", port: 6565)
        client.delegate = self
    }
    
    // MARK: - Communication with server
    
    private func requirePlayerKeyFromServer(_ json: Dictionary<String, Any>) {
        print("duydl: Send to server PlayerKey")
        let data: Dictionary = [
            "type": "get_key",
            "key": UUID().uuidString
        ]
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(data) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                let message = jsonString + " "
                client.sendToServer(message: message)
            }
        }
    }
    
    private func waitingAnotherPlayerFromServer(_ json: Dictionary<String, Any>) {
        print("duydl: Waiting another player")
    }
    
    private func serverSendBoardGame(_ json: Dictionary<String, Any>) {
        print("duydl: Matched")
        print("duydl: Let go")
        self.animationReadyView(index: 0) { (success) in
            
        }
    }
}

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
