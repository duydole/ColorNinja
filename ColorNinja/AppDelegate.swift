//
//  AppDelegate.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import GoogleMobileAds
import ZaloSDK

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window : UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        self.prepareForZalo()
        
        let homeVC = HomeViewController()
        let loginVC = LoginViewController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = loginVC
        window?.makeKeyAndVisible()
        
        if ZaloService.sharedInstance.isLoginZalo() {
            homeVC.modalPresentationStyle = .fullScreen
            showMiniLoading(onView: loginVC.view)
            loginVC.present(homeVC, animated: true) {
                hideLoading()
            }
        }
        
//        Thread.sleep(forTimeInterval: 1.0)
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GameMusicPlayer.shared.startBackgroundMusic()

        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        return ZDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }

    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return (ZDKApplicationDelegate.sharedInstance()?.application(app, open: url, options: options))!
    }

    private func prepareForZalo() {
        ZaloSDK.sharedInstance().initialize(withAppId: "3798956987156040112")
        ZaloService.sharedInstance.loadZaloProfileIfNeed { (_, _) in
            // Preload
        }
    }
}

