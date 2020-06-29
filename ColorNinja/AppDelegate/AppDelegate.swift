//
//  AppDelegate.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import GoogleMobileAds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window : UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // Initial Screen is LoginViewController
    let navigationViewController = UINavigationController(rootViewController: LoginViewController())
    navigationViewController.navigationBar.isHidden = true
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = navigationViewController
    window?.makeKeyAndVisible()
    
    // If didLogin open HomeViewController
    if OwnerInfo.shared.didLogin { 
      let homeVC = HomeViewController()
      navigationViewController.pushViewController(homeVC, animated: false)
    }
    
    setupCommonWhenLaughingApp()
    return true
  }
  
  private func setupCommonWhenLaughingApp() {
    GameMusicPlayer.shared.startBackgroundMusic()
    GADMobileAds.sharedInstance().start(completionHandler: nil)
  }
}

