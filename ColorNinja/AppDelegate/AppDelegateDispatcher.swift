//
//  AppDelegateDispatcher.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/18/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

public class AppDelegateDispatcher: NSObject, UIApplicationDelegate {
    
    //MARK: Properties
    private (set) lazy var allService: [BaseAppDelegate] = [
                                       ZaloSDKAppDelegate(),
                                       FacebookSDKAppDelegate(),
    ]
    
    //MARK: UIApplicationDelegate
    public func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        for service in self.allService {
            _ = service.application(application, didFinishLaunchingWithOptions: launchOptions)
        }
        return true
    }
    
    public func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        for service in self.allService{
            if service.application(app, open: url, options: options) {
                return true
            }
        }
        return false;
    }
    
    public func applicationWillResignActive(_ application: UIApplication) {
        for service in self.allService {
            service.applicationWillResignActive(application)
        }
    }
    
    public func applicationWillEnterForeground(_ application: UIApplication) {
        for service in self.allService {
            service.applicationWillEnterForeground(application)
        }
    }
    
    public func applicationDidBecomeActive(_ application: UIApplication) {
        for service in self.allService {
            service.applicationDidBecomeActive(application)
        }
    }
    
    public func applicationDidEnterBackground(_ application: UIApplication) {
        for service in self.allService {
            service.applicationDidEnterBackground(application)
        }
    }
    
    public func applicationWillTerminate(_ application: UIApplication) {
        for service in self.allService {
            service.applicationWillTerminate(application)
        }
    }
    
    public func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        for service in self.allService {
            service.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
        }
    }
    
    public func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        for service in self.allService {
            service.application(application, didReceiveRemoteNotification: userInfo)
        }
    }
    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        var result = false
        for service in self.allService {
            if service.application(application, continue: userActivity, restorationHandler: restorationHandler) || service.application(application, continue: userActivity) {
                result = true
            }
        }
        return result
    }

    public func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        for service in self.allService {
            service.application(application, performActionFor: shortcutItem, completionHandler: completionHandler)
        }
    }
}
