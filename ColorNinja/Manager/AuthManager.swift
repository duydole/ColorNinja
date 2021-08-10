//
//  AuthManager.swift
//  ZDInstagram
//
//  Created by Duy Đỗ on 19/07/2021.
//

import FirebaseAuth

public enum RegisterUserError: Error {
    case existed
    case unkown
}

/// AuthManager là component cho phép registeruser and login
/// AuthManager sử dụng <Auth> của <Firebase> để create account
public class AuthManager {
    static let shared = AuthManager()
    
    /// Register newuser
    /// 1. Check user existed or not
    /// 2. Create user in <Authentication>
    /// 3. Insert user to <RealtimeDatabase>
    public func registerNewUser(user: ChatAppUser,
                                password: String,
                                completion: @escaping (Bool, RegisterUserError?) -> Void) {
        
        /// Check can create new user or not
        DatabaseManager.shared.isUserExisted(with: user.email) { existed in
            if existed == true {
                completion(false,.existed)
                return
            }
            
            /// Create User with <email> dùng  <Auth> của Firebase
            /// Component sẽ insert là mục <Authentication/User> của Firebase.console
            Auth.auth().createUser(withEmail: user.email, password: password) { auResult, error in
                
                /// Check params
                guard error == nil, auResult != nil else {
                    completion(false,.unkown)
                    return
                }
                
                /// Insert to <RealTimeDatabase>
                DatabaseManager.shared.insertNewUserIfNotExisted(user: user) { success, error in
                    if success {
                        completion(true,nil)
                    } else {
                        completion(false,.unkown)
                    }
                }
            }
        }
    }
    
    /// Login with email
    public func logInUserWith(email: String,
                              password: String,
                              completion: ((Bool, Error?) -> Void)?) {
        
        Auth.auth().signIn(withEmail: email,
                           password: password) { authResult, error in
            guard authResult != nil, error == nil else {
                completion?(false, error)
                return
            }
            completion?(true, nil)
        }
    }
    
    /// Login with credential
    public func loginWithToken(credential: AuthCredential,
                               completion: ((Bool, Error?) -> Void)?) {
        Auth.auth().signIn(with: credential) { authDataResult, error in
            guard authDataResult != nil, error == nil else {
                completion?(false, error)
                return
            }
            completion?(true, nil)
        }
    }
    
    /// Logout
    public func logOutUser(completion: (Bool) -> Void) {
        do {
            try Auth.auth().signOut()
            completion(true)
        }
        catch {
            completion(false)
            fatalError("Error when sign out")
        }
    }
    
    /// isLogging
    public func isLogIn() -> Bool {
        return Auth.auth().currentUser != nil
    }
}
