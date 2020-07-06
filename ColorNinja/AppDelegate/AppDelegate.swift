//
//  AppDelegate.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import GoogleMobileAds
import FBSDKCoreKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window : UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    window = UIWindow(frame: UIScreen.main.bounds)
    if OwnerInfo.shared.didLogin {
        let navigationViewController = UINavigationController(rootViewController: HomeViewController())
        navigationViewController.navigationBar.isHidden = true
        window?.rootViewController = navigationViewController
    } else {
        window?.rootViewController = LoginViewController()
    }
    
    window?.makeKeyAndVisible()
    
    setupCommonWhenLaughingApp()
    return true
  }
    
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:] ) -> Bool { ApplicationDelegate.shared.application( app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation] )
    }
  
  private func setupCommonWhenLaughingApp() {
    GameMusicPlayer.shared.startBackgroundMusic()
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }
}
