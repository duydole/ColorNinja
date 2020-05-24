//
//  PlayerModel.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class User {
    
    public var userId: String
    public var username: String
    
    init(userId: String = UUID().uuidString, username: String = "Unkown") {
        self.userId = userId
        self.username = username
    }
}
