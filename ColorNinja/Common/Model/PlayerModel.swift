//
//  PlayerModel.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class User {
    
    var userId: String?
    var name: String = "Unknown"
    var currentPoint: Int = 0
    var maxPoint: Int = 0
    
    init(name: String, id: String) {
        self.userId = id
        self.name = name
    }
    
    init(name: String) {
        self.name = name
    }
}
