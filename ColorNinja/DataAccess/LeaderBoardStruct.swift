//
//  UserRanks.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/26/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

// Reponse of leaderboard/bestscore
struct LeaderBoardDBDefine: Decodable {
    let data: UserRanks
    
    enum CodingKeys: String, CodingKey {
        case data = "data"
    }
}

// list RankingModel
struct UserRanks: Decodable {
    let listUserRanks: [UserRank]?
    
    enum CodingKeys: String, CodingKey {
        case listUserRanks = "scoreusers"
    }
}

// UserRank info
struct UserRank: Decodable {
  
    let id: String
    let name: String?
    let bestscore: Int
    let numWinGame: Int
    let numLooseGame: Int

  enum CodingKeys: String, CodingKey {
    case id = "key"
    case name = "username"
    case bestscore = "bestscore"
    case numWinGame = "numWinGame"
    case numLooseGame = "numLooseGame"
  }
}
