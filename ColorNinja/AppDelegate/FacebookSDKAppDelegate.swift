//
//  FacebookSDKAppDelegate.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import FBSDKCoreKit

class FacebookSDKAppDelegate: BaseAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
        return true
    }
    
    override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return ApplicationDelegate.shared.application(app, open: url, options: options)
    }
    
}
