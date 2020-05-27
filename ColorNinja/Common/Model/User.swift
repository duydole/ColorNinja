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
    public var avatarUrl: String?
    public var bestScore: Int
    public var rank: Int
    
    init(userId: String = UUID().uuidString, username: String = "Unkown", avatarUrl: String = "", bestScore: Int = 0, rank: Int = 0) {
        self.userId = userId
        self.username = username
        self.avatarUrl = avatarUrl
        self.bestScore = bestScore
        self.rank = rank
    }
}
