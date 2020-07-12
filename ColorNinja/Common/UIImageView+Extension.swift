//
//  UIImageView+Extension.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/15/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit
import Alamofire
import Foundation
import AlamofireImage

extension UIImageView {
  
  public func downloaded(from url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    contentMode = mode
    URLSession.shared.dataTask(with: url) { data, response, error in
      guard
        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
        let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
        let data = data, error == nil,
        let image = UIImage(data: data)
        else {
          DispatchQueue.main.async() { [weak self] in
            self?.image = UIImage(named: "ninjaicon")
          }
          return
      }
      
      DispatchQueue.main.async() { [weak self] in
        self?.image = image
      }
    }.resume()
  }
  
  public func downloaded(from link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
    guard let url = URL(string: link) else { return }
    downloaded(from: url, contentMode: mode)
  }
  
  public func setImageWithLink(from link: String) {
    AF.request(link).responseImage { (response) in
      if let image = response.value {
        DispatchQueue.main.async {
          self.image = image
        }
      } else {
        DispatchQueue.main.async {
          self.image = UIImage(named: "defaultAvatar")
        }
      }
    }
  }
}
