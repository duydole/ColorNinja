//
//  RankingModel.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/24/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class UserRankingModel {
    let userId: String
    let username: String
    let bestscore: Int
    let numWinGame: Int
    let numLooseGame: Int
    
    init(userId: String, username: String, bestscore: Int, numWinGame: Int, numLooseGame: Int) {
        self.userId = userId
        self.username = username
        self.bestscore = bestscore
        self.numWinGame = numWinGame
        self.numLooseGame = numLooseGame
    }
}
