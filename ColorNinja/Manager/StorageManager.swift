//
//  StorageManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import FirebaseStorage

public typealias UploadPictureCompletion = (Result<String, StorageErrors>) -> Void

/// Error when upload image data to Storage
public enum StorageErrors: Error {
    case failedToUpload
    case failedToGetDownloadURL
    case invalidUrl
    case canNotDownloadImageData
}

/// Manager of Firebase Storage
final class StorageManager {
    public static let shared = StorageManager()
    public static let imageStoragePath = "images/"
    
    public static func imagePathWith(imageName: String) -> String {
        return "\(imageStoragePath)\(imageName)"
    }
    
    private let storageRef = Storage.storage().reference()
    
    // MARK: Public methods
    
    /// Download ImageData and upload to Storage
    /// - Parameters:
    ///   - url: urlString of image
    ///   - savedFileName: fileName will be saved on Storage
    ///   - completion: completion handler
    public func downloadImageFromUrlAndUpload(url: String,
                                              savedFileName: String,
                                              completion: UploadPictureCompletion?) {
        guard let url = URL(string: url) else {
            completion?(.failure(.invalidUrl))
            return
        }
        
        /// Download ImageData
        URLSessionManager.shared.downloadData(from: url) { [weak self] data in
            guard let data = data else {
                completion?(.failure(.canNotDownloadImageData))
                return
            }
            
            /// Upload
            self?.uploadUserAvatar(with: data, fileName: savedFileName, completion: completion)
        }
    }
    
    /// Upload ImageData to Storage
    /// - Parameters:
    ///   - data: image data will be uploaded
    ///   - fileName: fileName will be saved on Storage
    ///   - completion: completion handler
    public func uploadUserAvatar(with data: Data,
                                 fileName: String,
                                 completion: UploadPictureCompletion?) {
        
        /// Upload data
        let imagePath = "\(StorageManager.imageStoragePath)\(fileName)"
        storageRef.child(imagePath).putData(data, metadata: nil) { [weak self] storageMetaData, error in
            
            guard error == nil else {
                /// Upload failed
                completion?(.failure(.failedToUpload))
                return
            }
            
            /// Upload success => load URL
            self?.storageRef.child(imagePath).downloadURL { url, error in
                guard let url = url else {
                    completion?(.failure(.failedToGetDownloadURL))
                    return
                }
                
                completion?(.success(url.absoluteString))
            }
        }
        
    }
    
    /// Get download URL from FirebaseStorage
    /// - Parameters:
    ///   - path: path of data which is saved in storage
    ///   - completion: completion handler
    public func getDownloadURL(for path: String, completion: @escaping (Result<URL,Error>) -> Void) {
        storageRef.child(path).downloadURL { url, error in
            guard let url = url, error == nil else {
                completion(.failure(StorageErrors.failedToGetDownloadURL))
                return
            }
            
            completion(.success(url))
        }
    }
}
