//
//  DatabaseManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 31/07/2021.
//

import FirebaseDatabase

/// Error when insert user
public enum InsertUserError: Error {
    
    case existedInDatabase
}

final class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private let databaseRef = Database.database().reference()

    // MARK: Public methods
    
    /// Check user email is existed or not
    /// - Parameters:
    ///   - email: user email will be checked
    ///   - completion: completion handler
    public func isUserExisted(with email: String, completion: @escaping (Bool) -> Void) {
        isExistedValueOfKey(key: email.safeDatabaseKey(), completion: completion)
    }
    
    /// Insert NewUser if not eixsted
    /// - Parameters:
    ///   - user: user will be inserted
    ///   - completion: completion handler
    public func insertNewUserIfNotExisted(user: UserModel, completion: ((Bool, Error?) -> Void)?) {
        isUserExisted(with: user.email) { [weak self] existed in
            if existed {
                completion?(false,InsertUserError.existedInDatabase)
            } else {
                self?.insertNewUser(user: user, completion: completion)
            }
        }
    }
    
    /// Fetch all users
    /// - Parameter completion: completion handler
    public func fetchAllUsers(completion: @escaping ([UserModel]?) -> Void) {
        getDataOfKey(key: "users") { dataSnapshot in
            
            guard let usersDict = dataSnapshot.value as? [String: [String: String]] else {
                completion(nil)
                return
            }
            
            var users: [UserModel] = []
            for userDict in usersDict.values {
                guard let user = UserModel.convertDictToUser(dataDict: userDict) else {
                    continue
                }
                users.append(user)
            }
            completion(users)
        }
    }
    
    /// Search Users with name
    /// - Parameters:
    ///   - name: keyword of name will be searched
    ///   - completion: completion handler
    public func searchUserWithName(_ name: String, completion: @escaping ([UserModel]?) -> Void) {
        fetchAllUsers { users in
            guard let users = users else {
                completion(nil)
                return
            }
            
            let filteredUsers =  users.filter { user in
                return user.fullName.lowercased().hasPrefix(name.lowercased())
            }
            completion(filteredUsers)
        }
    }
    
    /// Insert NewUser to Database
    /// - Parameters:
    ///   - user: chatUser will be inserted
    ///   - completion: completion handler
    func insertNewUser(user: UserModel, completion: ((Bool, Error?) -> Void)?) {
        
        self.getDataOfKey(key: "users") { fetchedData in
            
            var users:[String: [String:String]] = [:]
            if var firebaseUsersDict = fetchedData.value as? [String: [String:String]] {
                firebaseUsersDict[user.userId] = user.toJson
                users = firebaseUsersDict
            }
            else {
                users[user.userId] = user.toJson
            }
            
            self.insertToFireBaseDatabase("users", users, completion)
        }
    }
}

// MARK: Private

extension DatabaseManager {

    private func insertToFireBaseDatabase(_ key: String,
                                          _ value: Any,
                                          _ completion: ((Bool, Error?) -> Void)?) {
        databaseRef.child(key).setValue(value) { error, _ in
            guard error == nil else {
                completion?(false,error)
                return
            }
            
            completion?(true,nil)
        }
    }
    
    private func isExistedValueOfKey(key: String, completion: @escaping (Bool) -> Void) {
        databaseRef.child(key).observeSingleEvent(of: .value) { dataSnapshot in
            if dataSnapshot.exists() {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    private func getDataOfKey(key: String, completion: @escaping (DataSnapshot) -> Void) {
        databaseRef.child(key).observeSingleEvent(of: .value, with: completion)
    }
}
