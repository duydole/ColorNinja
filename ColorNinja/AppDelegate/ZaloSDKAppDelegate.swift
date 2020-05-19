//
//  ZaloSDKAppDelegate.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import ZaloSDK

class ZaloSDKAppDelegate: BaseAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.prepareForZalo()
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (ZDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options))!
    }
    
    
    private func prepareForZalo() {
        ZaloSDK.sharedInstance().initialize(withAppId: "3798956987156040112")
        ZaloService.sharedInstance.loadZaloProfileIfNeed { (_, _) in
            // Preload
        }
    }
}
