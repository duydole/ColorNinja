//
//  UserDefaultManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation

final class UserDefaultManager {
    public static let shared = UserDefaultManager()
    
    private let userDefault = UserDefaults.standard
    
    // MARK: Public methods
    
    public func setString(str: String, forKey key: String) {
        userDefault.setValue(str, forKey: key)
    }
    
    public func getString(forKey key: String) -> String? {
        return userDefault.value(forKey:key) as? String
    }
    
    public func updateWhenRegisteredNewUser(_ newUser: UserModel) {
        setString(str: newUser.email, forKey: "email")
    }
}
