//
//  UserDefaultManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import UIKit

/// Manage UserDefault data of user
final class UserDefaultManager {
    public static let shared = UserDefaultManager()
    
    private let userDefault = UserDefaultsWrapper()
    
    /// Update userinfo to UserDefault when registered a new user
    /// - Parameter newUser: newuser
    public func updateWhenRegisteredNewUser(_ newUser: UserModel) {
        userDefault.setValue(value: newUser.firstName, forKey: "firstName")
        userDefault.setValue(value: newUser.lastName, forKey: "lastname")
        userDefault.setValue(value: newUser.email, forKey: "email")
        userDefault.setValue(value: newUser.avatarUrlStr ?? "", forKey: "avatarUrlStr")
        userDefault.setValue(value: newUser.maxScore, forKey: "maxScore")
    }
    
    public func storeUserAvatar(avatarData: Data) {
        userDefault.setValue(value: avatarData, forKey: "avatarData")
    }
    
    /// Load currentUserInfo
    /// - Returns: current user instance
    public func loadCurrentUser() -> UserModel {
        let firstname = userDefault.getString(forKey: "firstname") ?? ""
        let lastname = userDefault.getString(forKey: "lastname") ?? ""
        let email = userDefault.getString(forKey: "email") ?? ""
        let avatarUrlStr = userDefault.getString(forKey: "avatarUrlStr") ?? ""
        let maxScore = userDefault.getInt(forKey: "maxScore") ?? 0
        
        /// Load avatar and cache
        let avatarData = userDefault.getData(forKey: "avatarData")
        if let data = avatarData, avatarUrlStr.isEmpty == false {
            ImageDownloader.shared.cacheImage(data: data, key: avatarUrlStr)
        }
        
        return UserModel(firstName: firstname,
                         lastName: lastname,
                         email: email,
                         maxScore: maxScore,
                         avatarUrlStr: avatarUrlStr)
    }
    
    /// Remove all info of current user
    public func clearCurrentUserInfo() {
        userDefault.removeValue(forKey: "firstName")
        userDefault.removeValue(forKey: "lastname")
        userDefault.removeValue(forKey: "email")
        userDefault.removeValue(forKey: "avatarUrlStr")
        userDefault.removeValue(forKey: "maxScore")
        userDefault.removeValue(forKey: "avatarData")
    }
}

// MARK: UserDefaultsWrapper

/// Every thing with UserDefault must call to this object
final class UserDefaultsWrapper {
    private let userDefault = UserDefaults.standard

    public func setValue(value: Any, forKey key: String) {
        userDefault.setValue(value, forKey: key)
    }
    
    public func removeValue(forKey key: String) {
        userDefault.removeObject(forKey: key)
    }
    
    public func getString(forKey key: String) -> String? {
        return userDefault.value(forKey:key) as? String
    }
    
    public func getInt(forKey key: String) -> Int? {
        return userDefault.value(forKey: key) as? Int
    }
    
    public func getData(forKey key: String) -> Data? {
        return userDefault.value(forKey: key) as? Data
    }
}
