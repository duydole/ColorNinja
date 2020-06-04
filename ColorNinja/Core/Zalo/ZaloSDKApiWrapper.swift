//
//  ZaloSDKApiWrapper.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/12/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

#if !DISABLE_ZALOSDK
import UIKit
import ZaloSDK
import RxSwift

fileprivate let KData = "data"

class ZaloSDKApiWrapper: NSObject {

    public static let sharedInstance = ZaloSDKApiWrapper()
    
    private override init() {
        super.init()
    }
    
    public func zaloUserId() -> String {
        return ZaloSDK.sharedInstance().zaloUserId() ?? ""
    }
    
    public func zaloOauthcode() -> String {
        return ZaloSDK.sharedInstance().zaloOauthCode() ?? ""
    }
    
    
    public func isAuthen() -> Bool? {
        return (ZaloSDK.sharedInstance()?.isAuthenticatedZalo(completionHandler: { (response) in
            //
        }))
    }
    
    public func login(withZalo fromController: UIViewController?, type: ZAZaloSDKAuthenType, callback: @escaping (_ success: Bool)->()) {
        ZaloSDK.sharedInstance().authenticateZalo(with: type, parentController: fromController, handler: { (response) in
            if response?.errorCode != Int(kZaloSDKErrorCodeNoneError.rawValue) {
                callback(false)
                return
            }
            callback(true)
        })
    }
    
    
    public func loadZaloUserProfile(callback: @escaping (ZaloUserSwift?)->()) {
        ZaloSDK.sharedInstance().getZaloUserProfile(callback: { (response) in
            /// check responseData is ZOProfileResponseObject: vì có case crash zaloSDK trả ra ZOGraphResponseObject.
            guard let responseData = response,
                responseData.responds(to: #selector(getter: ZOProfileResponseObject.data)) else {
                    return
            }
            if responseData.errorCode == Int(kZaloSDKErrorCodeNoneError.rawValue)
            {
                if let data = responseData.data {
                    let user = ZaloUserSwift.currentUserFromZaloSDK(data)
                    callback(user)
                }
            }
        })
    }
    
    public func loadZaloFriend(_ offset: Int, count: Int) {
        ZaloSDK.sharedInstance().getUserInvitableFriendList(atOffset: UInt(offset), count: UInt(count), callback: { [weak self] (response) in
            self?.parseWithResponseGetListFriend(response: response)
            print("phuc")
         })
    }
    
    private func parseWithResponseGetListFriend(response:ZOGraphResponseObject?) {
        
        if response?.errorCode != Int(kZaloSDKErrorCodeNoneError.rawValue) {

            
        }
        
        let friends: [ZaloUserSwift]
        let selector = #selector(getter: ZOFriendsListResponseObject.data)
        guard response?.responds(to: selector) == true, let data = response?.data as? JSON else {
            friends = []
            return
        }
        let dataDic = data[KData]
        let dataJson = dataDic as? [JSON]
        friends = dataJson?.map({
            ZaloUserSwift.userFromDictionary($0,usingZaloPay:true)
        }) ?? []
        
    }
    
    public func shareFeedZalo(_ feed: ZOFeed?, andParentVC parent: UIViewController) {
        ZaloSDK.sharedInstance()?.share(feed, in: parent, callback: { (response) in
            if response?.errorCode != Int(kZaloSDKErrorCodeNoneError.rawValue) {
                let errorCode = response?.errorCode ?? 0
                let error = NSError(domain: "ColorNinja", code: errorCode, userInfo: nil)
                
            } else {
                
            }
        })
    }
    
     
     public func sendMessageZalo(_ url: String, andParentVC parent: UIViewController?)  {
         let feed: ZOFeed = ZOFeed(link: url, appName: "ColorNinja", message: "tesst", others: nil)
        ZaloSDK.sharedInstance()?.shareZalo(using: .appOrWeb)
        ZaloSDK.sharedInstance().sendMessage(feed, in: parent) { (response) in
             
             if response?.errorCode != Int(kZaloSDKErrorCodeNoneError.rawValue) {
                 let errorCode = response?.errorCode ?? 0
                 let error = NSError(domain: "Zalo", code: errorCode, userInfo: nil)
             } else {

             }
         }
     }
    
    public func logout(){
        ZaloSDK.sharedInstance().unauthenticate()
    }
}
#endif
