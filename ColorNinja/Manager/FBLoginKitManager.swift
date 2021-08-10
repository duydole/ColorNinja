//
//  FBLoginKitManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import FBSDKLoginKit

public typealias RequestDataFaceBookCompletion = ([String:Any]?,Error?) -> Void

class FBLoginKitManager {
    public static let shared = FBLoginKitManager()
    
    public func requestDataWith(token: String,
                                fields: [String: Any],
                                completion: RequestDataFaceBookCompletion?) {
        
        /// Create Request
        let facebookRequest = FBSDKLoginKit.GraphRequest(graphPath: "me",
                                                         parameters: fields,
                                                         tokenString: token,
                                                         version: nil,
                                                         httpMethod: .get)
        
        /// Execute request
        facebookRequest.start {_, result, error in
            if let error = error {
                completion?(nil,error)
                return
            }
            
            if let result = result as? [String: Any] {
                completion?(result,nil)
                return
            }
        }
    }
}
