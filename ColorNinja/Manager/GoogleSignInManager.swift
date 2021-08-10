//
//  GoogleSignInManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import UIKit
import GoogleSignIn
import Firebase

public enum GoogleSignInError: Error {
    case clientIdIsNil
}

final class GoogleSignInManager {
    public static let shared = GoogleSignInManager()
    
    public func signInWithPresenting(viewController: UIViewController, completion:((GIDGoogleUser?, Error?) -> Void)?) {
        
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            completion?(nil,GoogleSignInError.clientIdIsNil)
            return
        }
        let config = GIDConfiguration(clientID: clientID)
        
        GIDSignIn.sharedInstance.signIn(with: config, presenting: viewController, callback: completion)
    }
}
