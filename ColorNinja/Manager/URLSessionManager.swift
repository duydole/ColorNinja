//
//  URLSessionManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation

class URLSessionManager {
    public static let shared = URLSessionManager()
    
    /// Download data from URL
    /// - Parameters:
    ///   - url: Download URL
    ///   - completion: completion handler will downloaded data
    public func downloadData(from url: URL, completion: @escaping (Data?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            completion(data)
        }.resume()
    }
}
