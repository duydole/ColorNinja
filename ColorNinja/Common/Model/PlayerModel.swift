//
//  PlayerModel.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/16/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class PlayerModel {
    
    var id: String = UUID().uuidString
    var name: String = "Unknown"
    var currentPoint: Int = 0
    
    init(name: String, id: String) {
        self.id = id
        self.name = name
    }
    
    init(name: String) {
        self.name = name
    }
}
