//
//  Model.swift
//  ColorNinja
//
//  Created by Duy Đỗ on 10/08/2021.
//  Copyright © 2021 Do Le Duy. All rights reserved.
//

import Foundation

public struct UserModel {
        
    public let firstName: String
    public let lastName: String
    public let email: String
    public var maxScore: Int
    public var avatarUrlStr: String?
    
    /// FileName of avatar will be stored on Storage
    public var avatarFileName: String {
        return UserModel.avatarFileName(with: email)
    }
    
    public var fullName: String {
        return firstName + " " + lastName
    }
    
    public var userId: String {
        return email.safeDatabaseKey()
    }
    
    /// Convert data of  self  to Json
    public var toJson: [String: String] {
        return ["firstname":firstName,
                "lastname":lastName,
                "avatarUrl":avatarUrlStr ?? "",
                "email": email,
                "maxscore": String(maxScore)]
    }
    
    public static func avatarFileName(with email: String) -> String {
        return "\(email.safeDatabaseKey())_avatar.png"
    }
    
    /// Convert DictionaryData to object UserModel
    /// - Parameter dataDict: data of user
    /// - Returns: new instance of UserModel
    public static func convertDictToUser(dataDict: Dictionary<String, String>) -> UserModel? {
        guard let firstname = dataDict["firstname"],
              let lastname = dataDict["lastname"],
              let avatarUrlStr = dataDict["avatarUrl"],
              let email = dataDict["email"],
              let maxscore = dataDict["maxscore"] else {
            return nil
        }
        
        return UserModel(firstName: firstname,
                         lastName: lastname,
                         email: email,
                         maxScore: maxscore.toInt(),
                         avatarUrlStr: avatarUrlStr)
    }
}
