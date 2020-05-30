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

enum LoginType: Int {
    case NotLogin = 0
    case Guest = 1
    case Facebook = 2
    case Zalo = 3
}

class OwnerInfo {
    
    static let shared = OwnerInfo()
    
    public private(set) var userId: String = ""
    public private(set) var loginType: LoginType = .NotLogin
    public private(set) var bestScore: Int = 0
    public private(set) var userName: String = ""
    public private(set) var rank: Int = -1
    public var didLogin: Bool {
        get {
            if loginType.rawValue != 0 {
                return true
            } else {
                return false
            }
        }
    }
    public var avatarUrl: String? {
        get {
            switch loginType {
            case .Facebook:
                return "http://graph.facebook.com/\(userId)/picture?type=large"
            default:
                return nil
            }
        }
    }
    
    // MARK: Public
    
    func updateUserId(newUserId: String) {
        userId = newUserId
        userDefault.set(newUserId, forKey: kUserIdKey)
    }
    
    func updateLoginType(newLoginType: LoginType) {
        loginType = newLoginType
        userDefault.set(loginType.rawValue,forKey: kUserLoginType)
    }
    
    func updateUserName(newusername: String) {
        
        // UpdateMemory
        let parsedUserName = newusername.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        userName = parsedUserName
        
        // UpdateDB
        if let _ = userDefault.string(forKey: kUserNameKey) {
            DataBaseService.shared.updateUserNameForUser(userid: OwnerInfo.shared.userId, newUsername: userName, completion: nil)
        }
        
        // Update LocalDisk
        userDefault.set(userName,forKey: kUserNameKey)
    }
    
    func updateBestScore(newBestScore: Int) {
        bestScore = newBestScore
        userDefault.set(bestScore,forKey: kBestScoreKey)
    }
    
    func updateUserRank(newRank: Int) {
        rank = newRank
    }
    
    func toUser() -> User {
        return User(userId: self.userId, username: self.userName, avatarUrl: self.avatarUrl, bestScore: self.bestScore, rank: self.rank)
    }
    
    // MARK: Private
    
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
            if userId == "" {
                updateUserId(newUserId: UUID().uuidString)
            } else {
                self.userId = userId
            }
        } else {
            updateUserId(newUserId: UUID().uuidString)
        }
        
        
        // Load loginType
        let loginType = userDefault.integer(forKey: kUserLoginType)
        if loginType == 0 {
            updateLoginType(newLoginType: .NotLogin)
        } else {
            self.loginType = LoginType(rawValue: loginType) ?? LoginType.Guest
        }
        
        // LoadRanking of currentUser
        _loadOwnerRank()
        
        #if DEBUG
        //updateBestScore(newBestScore: 0)
        //updateLoginType(newLoginType: .NotLogin)
        #endif
    }
    
    private func _loadOwnerRank() {
        DataBaseService.shared.loadUserRank(user: self.toUser()) { (rank) in
            if rank != -1 {
                self.updateUserRank(newRank: rank)
            }
        }
    }
}
