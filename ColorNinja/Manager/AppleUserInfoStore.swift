//
//  AppleUserInfoStore.swift
//  ColorNinja
//
//  Created by Le Nguyen Quoc Cuong on 7/29/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

class AppleUserInfoStore {
    
    private init() {}
    
    static func getUserDisplayName(for id: String) -> String? {
        return UserDefaults.standard.value(forKey: id) as? String
    }
    
    static func setUserDisplayName(for id: String, name: String) {
        UserDefaults.standard.set(name, forKey: id)
    }
}
