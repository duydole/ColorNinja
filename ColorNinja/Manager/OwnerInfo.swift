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
let kUserIdKey = "kUserIdKey"

class OwnerInfo {
    
    static let shared = OwnerInfo()
    
    let userId: String!
    
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
    private var maxScore: Int = 0
    private let userDefault = UserDefaults.standard

    private init() {
        
        // Load cached username
        if let userName = userDefault.string(forKey: kUserNameKey) {
            self.userName = userName
        }
        
        // Load maxScore
        let maxScore = userDefault.integer(forKey: kMaxScoreKey)
        self.maxScore = maxScore
        
        // Load userId
        if let userId = userDefault.string(forKey: kUserIdKey) {
            self.userId = userId
        } else {
            self.userId = UUID().uuidString
            userDefault.set(userId,forKey: kUserIdKey)
        }
    }
}
