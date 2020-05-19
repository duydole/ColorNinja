//
//  FacebookService.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/19/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import FBSDKLoginKit
class FacebookService: NSObject {

    public func addLoginFacebookButton(inView view: UIView) {
        let loginButton = FBLoginButton()
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
    
    public func isLoginFacebook() -> Bool {
        if let token = AccessToken.current, !token.isExpired {
            return true
        }
        return false
    }
      
}
