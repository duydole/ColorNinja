//
//  OwnerInfo.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/22/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

let kUserNameKey = "kUserName"
let kMaxScoreKey = "kMaxScoreKey"

class OwnerInfo {
    
    static let shared = OwnerInfo()

    // MARK: Public
    
    func updateUserName(newusername: String) {
        userName = newusername
        userDefault.set(newusername,forKey: kUserNameKey)
    }
    
    func updateMaxScore(newMaxScore: Int) {
        maxScore = newMaxScore
        userDefault.set(maxScore,forKey: kMaxScoreKey)
    }
    
    func getUsername() -> String {
        return userName
    }
    
    func getMaxScore() -> Int {
        return maxScore
    }
    
    // MARK: Private
    
    private var userName: String = ""
    private var maxScore: Int
    private let userDefault = UserDefaults.standard

    private init() {
        if let userName = userDefault.string(forKey: kUserNameKey) {
            self.userName = userName
        }
        let maxScore = userDefault.integer(forKey: kMaxScoreKey)
        self.maxScore = maxScore
    }
}
