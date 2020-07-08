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
fileprivate let kCountRoundDidPlay = "kCountRoundDidPlay"
fileprivate let kCountPrompt = "kCountPrompt"

enum LoginType: Int {
  case NotLogin = 0
  case Guest = 1
  case Facebook = 2
  case Zalo = 3
}

class OwnerInfo {
  
  static let shared = OwnerInfo()
  
  //MARK: Readonly Prop
  public private(set) var countPrompt: Int = 0
  public private(set) var userId: String = ""
  public private(set) var loginType: LoginType = .NotLogin
  public private(set) var bestScore: Int = 0
  public private(set) var userName: String = ""
  public private(set) var rank: Int = -1
  public private(set) var countRoundDidPlay: Int = 0
  public var didLogin: Bool {
    get {
        if loginType != .NotLogin {
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
  
  func updateCountPrompt(newCountPrompt: Int) {
    countPrompt = newCountPrompt
    userDefault.set(countPrompt,forKey: kCountPrompt)
  }
  
  func increaseCountRoundDidPlay() {
    countRoundDidPlay += 1
    userDefault.set(countRoundDidPlay, forKey: kCountRoundDidPlay)
  }
  
  func toUser() -> User {
    return User(userId: self.userId, username: self.userName, avatarUrl: self.avatarUrl, bestScore: self.bestScore, rank: self.rank)
  }
  
  func updateInfoBeforeLogout() {
    updateLoginType(newLoginType: .NotLogin)
  }
  
  // MARK: Private
  
  private let userDefault = UserDefaults.standard
  
  private init() {
    _loadUserInfo()
  }
  
  private func _loadUserInfo() {
    
    // UserName
    if let userName = userDefault.string(forKey: kUserNameKey) {
      self.userName = userName
    }
    
    // BestScore
    let bestscore = userDefault.integer(forKey: kBestScoreKey)
    self.bestScore = bestscore
    
    // UserId
    if let userId = userDefault.string(forKey: kUserIdKey) {
      if userId == "" {
        updateUserId(newUserId: UUID().uuidString)
      } else {
        self.userId = userId
      }
    } else {
      updateUserId(newUserId: UUID().uuidString)
    }
    
    // LoginType
    let loginType = userDefault.integer(forKey: kUserLoginType)
    if loginType == 0 {
      updateLoginType(newLoginType: .NotLogin)
    } else {
      self.loginType = LoginType(rawValue: loginType) ?? LoginType.Guest
    }
    
    // Rank
    _loadOwnerRank()
    
    // CountRoundDidPlay
    let countRoundDidPlay = userDefault.integer(forKey: kCountRoundDidPlay)
    self.countRoundDidPlay = countRoundDidPlay
    
    // Count Prompt
    _loadCountPromt()
    
    // Debug only
    #if DEBUG
    //resetUserInfo()
    #endif
  }
  
  private func resetUserInfo() {
    updateBestScore(newBestScore: 0)
    updateLoginType(newLoginType: .NotLogin)
    userDefault.set(0, forKey: kCountRoundDidPlay)
    userDefault.set(0, forKey: kCountRoundDidPlay)
    userDefault.set("",forKey: kUserIdKey)
  }
  
  private func _loadOwnerRank() {
    DataBaseService.shared.loadUserRank(user: self.toUser()) { (rank) in
      if rank != -1 {
        self.updateUserRank(newRank: rank)
      }
    }
  }
  
  private func _loadCountPromt() {
    let countPrompt = userDefault.integer(forKey: kCountPrompt)
    self.countPrompt = countPrompt
    if countRoundDidPlay < 5 {
      updateCountPrompt(newCountPrompt: 5)
    }
  }
}
