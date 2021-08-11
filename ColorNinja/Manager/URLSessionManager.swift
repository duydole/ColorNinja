//
//  URLSessionManager.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 08/08/2021.
//

import Foundation
import UIKit

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
    
    /// Download Image from URL
    /// - Parameters:
    ///   - url: Download URL
    ///   - completion: completion handler
    public func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
