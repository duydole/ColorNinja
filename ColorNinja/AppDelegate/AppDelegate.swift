//
//  AppDelegate.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/8/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import GoogleMobileAds
import OneSignal

let onesignalAppId = "6d6c31de-f3c9-40b5-bb18-4e3550b22188"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  var window : UIWindow?
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    
    // APNS OneSignal
    setupAPNSWithLaunchOptions(launchOptions: launchOptions)
      
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

/// OneSignal
extension AppDelegate {
  
  private func setupAPNSWithLaunchOptions(launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    // Check if launched from notification
    let notificationOption = launchOptions?[.remoteNotification]
    
    if let notification = notificationOption as? [String: AnyObject],
      let _ = notification["aps"] as? [String: AnyObject] {
      /// Handle logic when open app with APNs
      /// Tạm thời chưa có handle
    }
    
    #if DEBUG
    //Remove this method to stop OneSignal Debugging
    OneSignal.setLogLevel(.LL_VERBOSE, visualLevel: .LL_NONE)
    logOneSignalUserStatus()
    #endif
    
    //START OneSignal initialization code
    let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false, kOSSettingsKeyInAppLaunchURL: false]
    
    // Replace 'YOUR_ONESIGNAL_APP_ID' with your OneSignal App ID.
    OneSignal.initWithLaunchOptions(launchOptions,
                                    appId: onesignalAppId,
                                    handleNotificationAction: nil,
                                    settings: onesignalInitSettings)
    
    OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
    
    // The promptForPushNotifications function code will show the iOS push notification prompt. We recommend removing the following code and instead using an In-App Message to prompt for notification permission (See step 6)
    OneSignal.promptForPushNotifications(userResponse: { accepted in
      print("User accepted notifications: \(accepted)")
    })
    //END OneSignal initializataion code
  }
  
  private func logOneSignalUserStatus() {
    let status: OSPermissionSubscriptionState = OneSignal.getPermissionSubscriptionState()

    let hasPrompted = status.permissionStatus.hasPrompted
    print("hasPrompted = \(hasPrompted)")
    let userStatus = status.permissionStatus.status
    print("userStatus = \(userStatus)")

    let isSubscribed = status.subscriptionStatus.subscribed
    print("isSubscribed = \(isSubscribed)")
    let userSubscriptionSetting = status.subscriptionStatus.userSubscriptionSetting
    print("userSubscriptionSetting = \(userSubscriptionSetting)")
    let userID = status.subscriptionStatus.userId
    print("userID = \(userID ?? "-")")
    let pushToken = status.subscriptionStatus.pushToken
    print("pushToken = \(pushToken ?? "-")")

    let _ = status.emailSubscriptionStatus.emailUserId
    let _ = status.emailSubscriptionStatus.emailAddress
  }
}
