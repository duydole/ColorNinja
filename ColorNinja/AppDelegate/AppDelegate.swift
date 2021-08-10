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
//import OneSignal
import Firebase
import GoogleSignIn

let onesignalAppId = "6d6c31de-f3c9-40b5-bb18-4e3550b22188"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Firsebase
        setupFirebase()
        
        /// RootViewController
        window = UIWindow(frame: UIScreen.main.bounds)
        if AuthManager.shared.isLogIn() {
            let navigationViewController = UINavigationController(rootViewController: HomeViewController())
            navigationViewController.navigationBar.isHidden = true
            window?.rootViewController = navigationViewController
        } else {
            window?.rootViewController = LoginViewController()
        }
        
        window?.makeKeyAndVisible()

        
        /// PreSetup
        setupCommonWhenLaughingApp()
        
        return true
    }
    
    func application( _ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

        /// Setup login with facebook
        ApplicationDelegate.shared.application(app, open: url, sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: options[UIApplication.OpenURLOptionsKey.annotation])
        
        return GIDSignIn.sharedInstance.handle(url)
    }
    
    private func setupCommonWhenLaughingApp() {
        GameMusicPlayer.shared.startBackgroundMusic()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
    }
}
