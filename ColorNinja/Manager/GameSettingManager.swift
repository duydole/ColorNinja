//
//  GameSettingManager.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class GameSettingManager {
    
    static let shared = GameSettingManager()
    
    var allowEffectSound: Bool!
    var allowMainSound: Bool {
        return !GameMusicPlayer.shared.isMuteMainSound
    }
    var ownerUserName: String?
    var userModel: PlayerModel!
    
    private init() {
        allowEffectSound = true
        userModel = PlayerModel(name: "Unkown")
    }
}
