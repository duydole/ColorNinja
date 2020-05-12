//
//  ZaloSDKApiWrapper.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import ZaloSDK

class ZaloSDKApiWrapper: NSObject {

    public static let sharedInstance = ZaloSDKApiWrapper()
    
    public func zaloUserId() -> String{
        return ZaloSDK.sharedInstance().zaloUserId() ?? ""
    }
    
    public func zaloOauthcode() -> String{
        return ZaloSDK.sharedInstance().zaloOauthCode() ?? ""
    }
    
    public func login(withZalo fromController: UIViewController?, type: ZAZaloSDKAuthenType) {
        ZaloSDK.sharedInstance().authenticateZalo(with: type, parentController: fromController, handler: { (response) in
            if response?.errorCode != Int(kZaloSDKErrorCodeNoneError.rawValue) {
                print("phuccc")
                return
            }
            var dic = Dictionary<String, Any>()
            dic["uid"] = response?.userId
            dic["oauthCode"] = response?.oauthCode
            
        })
    }
    
    public func loadZaloFriend(_ offset: Int, count: Int) {
        ZaloSDK.sharedInstance().getUserInvitableFriendList(atOffset: UInt(offset), count: UInt(count), callback: { [weak self] (response) in
             
         })
    }
    
    
    public func logout(){
        ZaloSDK.sharedInstance().unauthenticate()
    }
}
