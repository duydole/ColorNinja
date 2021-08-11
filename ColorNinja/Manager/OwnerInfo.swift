//
//  OwnerInfo.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/22/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import FBSDKLoginKit
import Alamofire

fileprivate let kUserNameKey = "kUserName"
fileprivate let kBestScoreKey = "kBestScoreKey"
fileprivate let kUserLoginType = "kUserLoginType"
fileprivate let kCountRoundDidPlay = "kCountRoundDidPlay"
fileprivate let kCountPrompt = "kCountPrompt"

class OwnerInfo {
    
    static let shared = OwnerInfo()
    
    //MARK: Readonly Prop
    public private(set) var countPrompt: Int = 0
    public private(set) var userId: String = getDeviceId()
    public private(set) var bestScore: Int = 0
    public private(set) var userName: String = ""
    public private(set) var rank: Int = -1
    public private(set) var countRoundDidPlay: Int = 0
    
    public var avatarUrl: String? {
        return nil
    }
    
    // MARK: Public

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
        
        // Rank
        _loadOwnerRank()
        
        // CountRoundDidPlay
        let countRoundDidPlay = userDefault.integer(forKey: kCountRoundDidPlay)
        self.countRoundDidPlay = countRoundDidPlay
        
        // Count Prompt
        _loadCountPromt()
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

class SessionManager {
    public static let shared = SessionManager()
    
    /// currentUser
    public var currentUser: UserModel?
        
    /// Update info when registered newuser
    /// - Parameter newUser: newuser
    public func didRegisterNewUser(newUser: UserModel) {
        currentUser = newUser
        
        /// Update userDefault
        UserDefaultManager.shared.updateWhenRegisteredNewUser(newUser)
        
        /// Download user avatar
        if let urlStr = newUser.avatarUrlStr {
            ImageDownloader.shared.downloadImage(with: URL(string: urlStr)!, cachedKey: urlStr) { image in
                guard let image = image else {
                    return
                }
                
                /// Store to userDefault, then we can load when launch app again
                UserDefaultManager.shared.storeUserAvatar(avatarData: image.pngData()!)
                
                /// Notify update UI when download Avatar success
                NotificationCenter.default.post(Notification(name: Notification.Name(kDownloadAvatarSuccessNotificationName)))
            }
        }
    }
    
    /// Clear all userDefault data
    public func clearInfoOffCurrentUser() {
        UserDefaultManager.shared.clearCurrentUserInfo()
    }
    
    /// Download avatar of current loggine
    /// - Parameter completion: completion handler
    public func getCurrentUserAvatar(completion: @escaping (UIImage?) -> Void) {
        guard let urlStr = currentUser?.avatarUrlStr, urlStr.isEmpty == false else {
            completion(nil)
            return
        }
        
        ImageDownloader.shared.downloadImage(with: URL(string: urlStr)!, cachedKey: urlStr, completion: completion)
    }
    
    private init() {
        currentUser = UserDefaultManager.shared.loadCurrentUser()
    }
}
