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
    
    let services = AppDelegateDispatcher()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let homeVC = HomeViewController2()
        let loginVC = LoginViewController()
        let naviVC = UINavigationController(rootViewController: loginVC)
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = naviVC
        window?.makeKeyAndVisible()
        
        if ZaloService.sharedInstance.isLoginZalo() {
            homeVC.modalPresentationStyle = .fullScreen
            showMiniLoading(onView: loginVC.view)
            loginVC.present(homeVC, animated: true) {
                hideLoading()
            }
        }
        
        // Check didLogin or not
        if OwnerInfo.shared.didLogin {
            naviVC.pushViewController(homeVC, animated: false)
        }
        
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        GameMusicPlayer.shared.startBackgroundMusic()
        _ = services.application(application, didFinishLaunchingWithOptions: launchOptions)
        
        #if DEBUG
        GameMusicPlayer.shared.muteBackgroundGameMusic()
        #endif
        
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return services.application(app, open: url, options: options)
    }
    
}

