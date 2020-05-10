//
//  RankingCellModel.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

enum TopPlayerType: Int {
    case top1    = 0
    case top2    = 1
    case top3    = 2
    case normal = 3
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
    public var avatarURL: String = ""
    public var playerType: TopPlayerType = .normal
    
    public init(ranking: Int, name: String, avatarURL: String, record: Int, type: TopPlayerType = .normal) {
        self.ranking = ranking
        self.name = name
        self.avatarURL = avatarURL
        self.record = record
        self.playerType = type
    }
    
}
