//
//  RankingCellModel.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/10/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

class RankingCellModel: NSObject {

    // MARK: - Property
    
    public var ranking: Int = 0
    public var record: Int = 0
    public var name: String = ""
    public var avatarURL: String = ""
    
    public init(ranking: Int, name: String, avatarURL: String, record: Int) {
        self.ranking = ranking
        self.name = name
        self.avatarURL = avatarURL
        self.record = record
    }
    
}
