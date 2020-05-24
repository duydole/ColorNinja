//
//  DataProvider.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/24/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation

fileprivate let serverUrl = "http://119.82.135.105:8000/"
fileprivate let leaderBoardUrl = serverUrl + "leaderboard/bestscore"
fileprivate let registerUserUrl = serverUrl + "registeruser"
fileprivate let updateUserDataUrl = serverUrl + "user"

enum UpdateUserType: String {
    case Username = "username"
    case AvatarUrl = "avatar"
    case BestScore = "bestscore"
}

class DataBaseService : NSObject {
    
    static let shared = DataBaseService()

    lazy var urlSession : URLSession = {
        let config = URLSessionConfiguration.default
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: Load
    
    public func loadLeaderBoardUsers(completion: @escaping (_ rankingModels: [UserRankingModel]?, _ error: Error?) -> Void) {
        loadLeaderBoardWithCompletion(completion: completion)
    }
    
    // MARK: Update/Insert
    
    public func insertUserToDB(user: OwnerInfo, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let url = URL(string: registerUserUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: Dictionary<String, Any> = [
            "key": user.userId!,    // chú ý refactor chỗ này
            "username": user.getUsername(),
            "avatar": user.avatarUrl ?? ""
        ]
        request.httpBody = parameters.percentEncoded()
        
        print("duydl: Add user to DB: \(parameters)")
        
        postWithRequest(request: request, completion: completion)
    }
    
    public func updateBestScoreForUser(user: OwnerInfo, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        
        let url = URL(string: updateUserDataUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: Dictionary<String, Any> = [
            "key": user.userId!,
            "bestscore":user.getBestScore(),
            "type":UpdateUserType.BestScore.rawValue
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        postWithRequest(request: request, completion: completion)
    }
    
    public func updateUserNameForUser(user: OwnerInfo, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let url = URL(string: updateUserDataUrl)!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let parameters: Dictionary<String, Any> = [
            "key": user.userId!,
            "username":user.getUsername(),
            "type":UpdateUserType.Username.rawValue
        ]
        
        request.httpBody = parameters.percentEncoded()
        
        postWithRequest(request: request, completion: completion)
    }
    
    // MARK: Private
    
    private func loadLeaderBoardWithCompletion(completion: @escaping (_ rankingModels: [UserRankingModel]?, _ error: Error?) -> Void) {
        
        let url = URL(string: leaderBoardUrl)!
        let task = urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(nil, error)
                return
            }
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options : .allowFragments) as? Dictionary<String,Any> {
                    let data = json["data"] as! Dictionary<String, Any>
                    let listRankingModels = self.dataToUserRankingModels(datas: data["scoreusers"] as! [Dictionary<String, Any>])
                    completion(listRankingModels, nil)
                } else {
                    completion(nil,error)
                    return
                }
            } catch let error as NSError {
                completion(nil,error)
                return
            }
            
        }
        task.resume()
    }
    
    private func dataToUserRankingModels(datas: [Dictionary<String, Any>]) -> [UserRankingModel] {
        var rankingModels = [UserRankingModel]()
        for data in datas {
            rankingModels.append(UserRankingModel(userId: data["key"] as! String,
                                                  username: data["username"] as! String,
                                                  bestscore: data["bestscore"] as! Int,
                                                  numWinGame: data["numWinGame"] as! Int,
                                                  numLooseGame: data["numLooseGame"] as! Int))
        }
        return rankingModels
    }
    
    private func postWithRequest(request: URLRequest, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let task = urlSession.dataTask(with: request) { data, response, error in
            
            guard let data = data, let response = response as? HTTPURLResponse, error == nil else {
                print("error", error ?? "Unknown error")
                completion(false, error)
                return
            }
            
            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode)")
                print("response = \(response)")
                completion(false, error)
                return
            }

            let responseString = String(data: data, encoding: .utf8)
            print("duydl: SERVER: \(responseString!)")
            completion(true,nil)
        }

        task.resume()
    }
}



extension DataBaseService : URLSessionDataDelegate {
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        
    }
    
}
