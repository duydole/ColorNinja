//
//  OwnerInfo.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/22/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import FBSDKLoginKit

fileprivate let kUserNameKey = "kUserName"
fileprivate let kBestScoreKey = "kBestScoreKey"
fileprivate let kUserIdKey = "kUserIdKey"
fileprivate let kUserLoginType = "kUserLoginType"
fileprivate let defaultAvatarUrl = "https://cdn1.iconfinder.com/data/icons/foxy-universal-circle-glyph/24/circle-round-userinterface-people-account-person-profile-512.png"

enum LoginType: Int {
    case NotLogin = 0
    case Guest = 1
    case Facebook = 2
    case Zalo = 3
}

class OwnerInfo {
    
    static let shared = OwnerInfo()
    
    let userId: String!
    var avatarUrl: String!
    var loginType: LoginType = .Guest
    
    var didLogin: Bool {
        get {
            if loginType.rawValue != 0 {
                return true
            } else {
                return false
            }
        }
    }
    
    // MARK: Public
    
    func updateLoginType(newLoginType: LoginType) {
        loginType = newLoginType
        userDefault.set(loginType.rawValue,forKey: kUserLoginType)
    }
    
    func updateUserName(newusername: String) {
        userName = newusername
        
        // If existed
        if let _ = userDefault.string(forKey: kUserNameKey) {
            DataBaseService.shared.updateUserNameForUser(userid: OwnerInfo.shared.userId, newUsername: newusername, completion: nil)
        }
        
        userDefault.set(newusername,forKey: kUserNameKey)
    }
    
    func updateBestScore(newBestScore: Int) {
        bestScore = newBestScore
        userDefault.set(bestScore,forKey: kBestScoreKey)
    }
    
    func getUsername() -> String {
        return userName
    }
    
    func getBestScore() -> Int {
        return bestScore
    }
    
    // MARK: Private
    
    private var userName: String = ""
    private var bestScore: Int = 0
    private let userDefault = UserDefaults.standard

    private init() {
        
        // Load cached username
        if let userName = userDefault.string(forKey: kUserNameKey) {
            self.userName = userName
        }
        
        // Load bestScore
        let bestscore = userDefault.integer(forKey: kBestScoreKey)
        self.bestScore = bestscore
        
        // Load userId
        if let userId = userDefault.string(forKey: kUserIdKey) {
            self.userId = userId
        } else {
            self.userId = UUID().uuidString
            userDefault.set(userId,forKey: kUserIdKey)
        }
        
        
        // Load loginType
        let loginType = userDefault.integer(forKey: kUserLoginType)
        if loginType == 0 {
            userDefault.set(0, forKey: kUserLoginType)
        } else {
            self.loginType = LoginType(rawValue: loginType) ?? LoginType.Guest
        }
        
        avatarUrl = defaultAvatarUrl
        
        
        #if DEBUG
        //updateBestScore(newBestScore: 0)
        //updateLoginType(newLoginType: .NotLogin)
        #endif
    }
}
