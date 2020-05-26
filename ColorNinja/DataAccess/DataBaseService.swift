//
//  DataProvider.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/24/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let serverUrl = "http://119.82.135.105:8000/"
fileprivate let leaderBoardUrl = serverUrl + "leaderboard/bestscore"
fileprivate let registerUserUrl = serverUrl + "registeruser"
fileprivate let updateUserDataUrl = serverUrl + "user"

enum UpdateUserType: String {
    case Username = "username"
    case AvatarUrl = "avatar"
    case BestScore = "bestscore"
}

enum ErrorCode {
    case NoDataReturn
    case StatusCodeNot200s
}

typealias completionHandler = (_ success: Bool, _ error: Error?) -> Void

class DataBaseService : NSObject {
    
    static let shared = DataBaseService()
    
    // MARK: Load
    
    public func loadLeaderBoardUsers(completion: @escaping (_ rankingModels: [UserRank]?, _ error: Error?) -> Void) {
        AF.request(leaderBoardUrl).validate().responseDecodable(of: LeaderBoardDBDefine.self) { (response) in
            guard let responseJSON = response.value else {
                completion(nil, nil)
                return
            }
            guard let userRanks = responseJSON.data.listUserRanks else {
                completion(nil, nil)
                return
            }
            
            completion(userRanks, nil)
        }
    }
    
    // MARK: Update/Insert
    
    public func insertUserToDB(user: OwnerInfo, completion: completionHandler?) {
        
        let parameters: Dictionary<String, Any> = [
            "key": user.getUserId(),    // chú ý refactor chỗ này
            "username": user.getUsername(),
            "avatar": user.avatarUrl
        ]
        
        AF.request(registerUserUrl, method: .post, parameters:parameters).responseJSON { (response) in
            let response: JSON = response.value as! JSON
            guard let error: Int = response["error"] as? Int else { return }
            if error < 0 {
                print("duydl: SERVER: \(response["message"] ?? "Something Error")")
                return
            }
            completion?(true,nil)
        }
    }
        
    public func updateBestScoreForUser(userid: String, newBestScore: Int, completion: completionHandler?) {
        let parameters: Dictionary<String, Any> = [
            "key": userid,
            "bestscore":newBestScore,
            "type":UpdateUserType.BestScore.rawValue
        ]
        
        AF.request(updateUserDataUrl, method: .post, parameters:parameters).responseJSON { (response) in
            let response: JSON = response.value as! JSON
            guard let error: Int = response["error"] as? Int else { return }
            if error < 0 {
                print("duydl: SERVER: \(response["message"] ?? "Something Error")")
                return
            }
            completion?(true,nil)
        }
    }
    
    public func updateUserNameForUser(userid: String, newUsername: String, completion: completionHandler?) {
        let parameters: Dictionary<String, Any> = [
            "key": userid,
            "username":newUsername,
            "type":UpdateUserType.Username.rawValue
        ]
        
        AF.request(updateUserDataUrl, method: .post, parameters:parameters).responseJSON { (response) in
            let response: JSON = response.value as! JSON
            guard let error: Int = response["error"] as? Int else { return }
            if error < 0 {
                print("duydl: SERVER: \(response["message"] ?? "Something Error")")
                return
            }
            completion?(true,nil)
        }
    }
}
