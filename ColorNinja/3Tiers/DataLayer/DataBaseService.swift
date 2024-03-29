//
//  DataProvider.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/24/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import Alamofire

fileprivate let serverUrl = "http://colorninjagame.tk:8000/"
fileprivate let leaderBoardUrl = serverUrl + "leaderboard/bestscore"
fileprivate let registerUserUrl = serverUrl + "registeruser"
fileprivate let updateUserDataUrl = serverUrl + "user"
fileprivate let appConfigUrl = serverUrl + "appconfig"

enum UpdateUserType: String {
  case Username = "username"
  case AvatarUrl = "avatar"
  case BestScore = "bestscore"
}

typealias CompletionHandler = (_ success: Bool, _ error: DBError?) -> Void
typealias LoadLeaderBoardCompletionHandler = (_ rankingModels: [UserRank]?, _ error: Error?) -> Void
typealias LoadUserRankCompletionHandler = (_ rank: Int) -> Void

class DBError: Error {
  public var errorType: DBErrorType = .DBErrorTypeUnkown
  
  init(errorType: DBErrorType) {
    self.errorType = errorType
  }
}

enum DBErrorType: Int {
  case DBErrorTypeUserExisted = 0
  case DBErrorTypeUnkown
}

///
/// DataBaseService allow you to: Update, Delete, Insert data to Server:
/// Our main data on Server: Users, LeaderBoard, AppConfig
///
class DataBaseService : NSObject {
  
  static let shared = DataBaseService()
  
  // MARK: Load
  
  public func loadLeaderBoardUsers(completion: @escaping LoadLeaderBoardCompletionHandler) {
    if (noConnection()) {
      print("duydl>> No Connection, can't load LeaderBoard.")
      completion([],nil)
      return
    }
    
    /// Request data from `leaderBoardUrl`
    AF.request(leaderBoardUrl)
      .validate()
      .responseDecodable(of: LeaderBoardDBDefine.self) { (response) in
        
        guard let responseJSON = response.value else {
          completion(nil, nil)
          return
        }
        
        /// Get parsedData
        /// responseJSON là struct dạng `LeaderBoardDBDefine`
        guard let userRanks = responseJSON.data.listUserRanks else {
          completion(nil, nil)
          return
        }
        
        completion(userRanks, nil)
      }
  }
  
  public func loadUserRank(user: User, completion: @escaping LoadUserRankCompletionHandler) {
    
    if (noConnection()) {
      completion(-1)
      return
    }
    
    let url = "\(updateUserDataUrl)?key=\(user.userId)"
    AF.request(url)
      .responseJSON { (response) in
        
        guard let json = response.value as! [String : Any]? else {
          completion(-1)
          return
        }
        
        //Check status:
        if (json.keys.contains("data") == false) {
          completion(-1)
          return
        }
        
        let data = json["data"] as! [String: Any]
        if let rank = data["rank"] as! Int? {
          completion(rank)
        }
        else {
          completion(-1)
        }
      }
  }
  
  public func loadAppConfig(completion: ((_ config: Dictionary<String, Any>?) -> ())? ) {
    if (noConnection()) {
      completion?(nil)
      return
    }
    
    AF.request(appConfigUrl)
      .responseJSON { (response) in
        guard let json = response.value as! [String:Any]? else {
          completion?(nil)
          return
        }
        
        completion?(json)
      }
  }
  
  // MARK: Update/Insert
  
  public func insertUserToDB(user: OwnerInfo, completion: CompletionHandler?) {
    
    if (noConnection()) {
      completion?(false,nil)
      return
    }
    
    let parameters: Dictionary<String, Any> = [
      "key": user.userId,    // chú ý refactor chỗ này
      "username": user.userName,
      "avatar": user.avatarUrl ?? ""
    ]
    
    AF.request(registerUserUrl, method: .post, parameters:parameters)
      .responseJSON { (response) in
        if let json = response.value as! [String : Any]? {
          /// Có json response
          
          /// Đeo bao
          guard let error: Int = json["error"] as? Int else {
            completion?(false,DBError(errorType: .DBErrorTypeUnkown))
            return
          }
          
          /// Nếu errorCode < 0
          if error < 0 {
            print("duydl: SERVER: \(json["message"] ?? "Something Error")")
            completion?(false,DBError(errorType: .DBErrorTypeUserExisted))
            return
          } else {
            
            /// Insert thành công vào DB trên server
            completion?(true,nil)
          }
        } else {
          /// Không có jsonResponse
          completion?(false,DBError(errorType: .DBErrorTypeUnkown))
        }
      }
  }
  
  public func updateBestScoreForUser(userid: String, newBestScore: Int, completion: CompletionHandler?) {
    if (noConnection()) {
      completion?(false,nil)
      return
    }
    
    print("duydl: Request update score for user with newScore: \(newBestScore)")
    
    let parameters: Dictionary<String, Any> = [
      "key": userid,
      "bestscore":newBestScore,
      "type":UpdateUserType.BestScore.rawValue
    ]
    
    AF.request(updateUserDataUrl, method: .post, parameters:parameters)
      .validate()
      .responseJSON { (response) in
        let response: JSON? = response.value as? JSON
        if let response = response {
          guard let error: Int = response["error"] as? Int else { return }
          if error < 0 {
            print("duydl: SERVER: \(response["message"] ?? "Something Error")")
            return
          }
          completion?(true,nil)
        } else {
          completion?(false,nil)
        }
      }
  }
  
  public func updateUserNameForUser(userid: String, newUsername: String, completion: CompletionHandler?) {
    if (noConnection()) {
      completion?(false,nil)
      return
    }
    
    let parameters: Dictionary<String, Any> = [
      "key": userid,
      "username":newUsername,
      "type":UpdateUserType.Username.rawValue
    ]
    
    AF.request(updateUserDataUrl, method: .post, parameters:parameters).responseJSON { (response) in
      
      if let json = response.value as! JSON? {
        guard let error: Int = json["error"] as? Int else { return }
        if error < 0 {
          print("duydl: SERVER: \(json["message"] ?? "Something Error")")
          return
        }
        completion?(true,nil)
      }
    }
  }
  
  public func updateAvatarForUser(userid: String, newAvatarUrl: String, completion: CompletionHandler?) {
    
    if (noConnection()) {
      completion?(false,nil)
      return
    }
    
    let parameters: Dictionary<String, Any> = [
      "key": userid,
      "avatar":newAvatarUrl,
      "type":UpdateUserType.AvatarUrl.rawValue
    ]
    AF.request(updateUserDataUrl, method: .post, parameters:parameters).responseJSON { (response) in
      
      if let json = response.value as! JSON? {
        guard let error: Int = json["error"] as? Int else {
          completion?(false, response.error as? DBError)
          return
        }
        if error < 0 {
          print("duydl: SERVER: \(json["message"] ?? "Something Error")")
          completion?(false, response.error as? DBError)
          return
        }
        completion?(true,nil)
      }
    }
  }
  
  // MARK: Private
  
  private func noConnection() -> Bool {
    return !NetworkManager.shared.hasConnection || isServerDie()
  }
  
  private func isServerDie() -> Bool {
    let canOpen = verifyUrl(urlString: serverUrl)
    return canOpen == false
  }
  
  private func verifyUrl (urlString: String?) -> Bool {
    if let urlString = urlString {
      if let url = NSURL(string: urlString) {
        return UIApplication.shared.canOpenURL(url as URL)
      }
    }
    return false
  }
}
