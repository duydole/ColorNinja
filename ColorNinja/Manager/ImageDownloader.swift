//
//  ImageDownloader.swift
//  ColorNinja
//
//  Created by Duy Đỗ on 10/08/2021.
//  Copyright © 2021 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit

final class ImageDownloader {
    public static let shared = ImageDownloader()
    private var cached: [String: UIImage] = [:]
    
    /// Download a image, and cache them, if existed in cache just return image
    /// - Parameters:
    ///   - url: Download URL
    ///   - completion: completion handler
    public func downloadImage(with url: URL, cachedKey: String, completion: ((UIImage?) -> Void)?) {
        
        /// Check cache
        if let image = cached[cachedKey] {
            completion?(image)
            return
        }
        
        /// StartDownload
        URLSessionManager.shared.downloadImage(from: url) { [weak self] image in
            completion?(image)
            
            /// Cache
            if let image = image {
                self?.cached[cachedKey] = image
            }
        }
    }
    
    /// Cache Image with key
    /// - Parameters:
    ///   - image: UIImage will be cached
    ///   - key: cached key
    public func cacheImage(image: UIImage, key: String) {
        cached[key] = image
    }
    
    /// Convert data to UIImage then cache
    /// - Parameters:
    ///   - data: data of image
    ///   - key: cached key
    public func cacheImage(data: Data, key: String) {
        let image = UIImage(data: data)
        if let image = image {
            cached[key] = image
        }
    }
}
