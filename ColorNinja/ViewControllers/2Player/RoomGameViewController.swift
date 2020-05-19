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
    
    
    override func sendRequiredKeyMessage() {
        let jsonString = "{\"type\":\(ClientSendType.SendRequiredKeyGroupMode.rawValue),\"keyPlayer\":\"\(player1.id)\",\"username\":\(player1.name)} "
        client.sendToServer(message: jsonString)
    }
    
    override func serverSendRoomInfo(_ json: Dictionary<String, Any>) {
        
    }
}
