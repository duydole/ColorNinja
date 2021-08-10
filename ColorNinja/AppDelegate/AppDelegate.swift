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
import Firebase
import GoogleSignIn

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window : UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        /// Firsebase
        FirebaseApp.configure()

        /// RootViewController
        var rootViewController: UIViewController = LoginViewController()
        if AuthManager.shared.isLogIn() {
            let navigationViewController = UINavigationController(rootViewController: HomeViewController())
            navigationViewController.navigationBar.isHidden = true
            rootViewController = navigationViewController
        }
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = rootViewController
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
}
