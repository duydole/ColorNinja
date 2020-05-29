//
//  ResultGameModel.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/27/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class ResultGameModel {
    public var user: User
    public var score: Int
    
    init(user: User, score: Int) {
        self.user = user
        self.score = score
    }
}
