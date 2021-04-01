//
//  UserRanks.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/26/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

// Reponse of leaderboard/bestscore
// Build the struct base on Json which server return
struct LeaderBoardDBDefine: Decodable {
    let data: UserRanks
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// List UserRanks
struct UserRanks: Decodable {
    let listUserRanks: [UserRank]?
    
    enum CodingKeys: String, CodingKey {
        case listUserRanks = "scoreusers"
    }
}

// UserRank Info base on Json of server
struct UserRank: Decodable {
  
    let id: String
    let name: String?
    let bestscore: Int
    let numWinGame: Int
    let numLooseGame: Int
    let avatarUrl: String
    var rank: Int = 0

  enum CodingKeys: String, CodingKey {
    case id = "key"
    case name = "username"
    case bestscore = "bestscore"
    case numWinGame = "numWinGame"
    case numLooseGame = "numLooseGame"
    case avatarUrl = "avatar"
  }
}
