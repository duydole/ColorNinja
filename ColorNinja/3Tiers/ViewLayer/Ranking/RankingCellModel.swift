//
//  RankingCellModel.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import AlamofireImage
import Alamofire

enum TopPlayerType: Int {
  case top1    = 0
  case top2    = 1
  case top3    = 2
  case normal  = 3
}

extension TopPlayerType {
  var colorTitle: UIColor {
    switch self {
    case .top1:
      return ColorRGB(255, 255, 0)
    case .top2:
      return .white
    case .top3:
      return ColorRGB(255, 153, 102)
    default:
      return .black
    }
  }
}

class RankingCellModel: NSObject {
  
  // MARK: - Property
  
  public var ranking: Int = 0
  public var record: Int = 0
  public var name: String = ""
  public var avatarURL: String?
  public var playerType: TopPlayerType = .normal
  public var id: String!
  public var rate: Int!
  public var avatarImage: UIImage!
  
  public init(userRank: UserRank) {
    super.init()
    
    ranking = userRank.rank
    record = userRank.bestscore
    name = userRank.name ?? "Default"
    avatarURL = userRank.avatarUrl
    if ranking == 1 {
      playerType = .top1
    } else if ranking == 2 {
      playerType = .top2
    } else if ranking == 3 {
      playerType = .top3
    }
    id = userRank.id
    
    let totalGames = userRank.numWinGame + userRank.numLooseGame
    if totalGames > 0 {
      rate = Int(100*(Float(userRank.numWinGame) / Float(totalGames)))
    } else {
      rate = 0
    }
    
    downloadAvatarIfNeed()
  }
  
  private func downloadAvatarIfNeed() {
    if let avatarURL = avatarURL {
      if notEmptyString(string: avatarURL) {
        AF.request(avatarURL).responseImage { (response) in
          if let image = response.value {
              self.avatarImage = image
          } else {
              self.avatarImage = UIImage(named: "defaultAvatar")
          }
        }
      } else {
        self.avatarImage = UIImage(named: "defaultAvatar")
      }
    }
  }
}
