//
//  ZaloService.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/15/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

fileprivate let kUserName    = "kUserZaloName"
fileprivate let kAvatar    = "kUserZaloAvatar"


fileprivate let userNameDefault    = "Guest"
fileprivate let avatarURLDefault    = "https://sage.edu.vn/wp-content/uploads/2019/03/Untitled-design-2-min-11.jpg"

class ZaloService: NSObject {
    
    public static let sharedInstance = ZaloService()
    
    public func loadZaloProfileIfNeed(callback: @escaping (_ name: String, _ avatarURL: String) -> ()) {
        
        let userDefault = UserDefaults.standard
        if let userName = userDefault.string(forKey: kUserName),  let avatarURL = userDefault.string(forKey: kAvatar)
        {
            callback(userName, avatarURL)
            return
        }
        
        ZaloSDKApiWrapper.sharedInstance.loadZaloUserProfile { (userZalo) in
            guard let user = userZalo else {
                callback(userNameDefault, avatarURLDefault)
                return
            }
            
            userDefault.set(user.displayName, forKey: kUserName)
            userDefault.set(user.avatar, forKey: kAvatar)
            callback(user.displayName, user.avatar)
        }
    }
    
    public func isLoginZalo() -> Bool {
        if ZaloSDKApiWrapper.sharedInstance.zaloOauthcode().count == 0 {
            return false
        }
        return true
    }
    
    public func logoutZalo() {
        ZaloSDKApiWrapper.sharedInstance.logout()
    }
}
