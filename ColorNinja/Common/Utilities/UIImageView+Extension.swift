//
//  UIImageView+Extension.swift
//  ColorNinja
//
//  Created by Do Le Duy on 5/26/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = NSURL(string: urlString) {
            let request = NSURLRequest(URL: url)
            NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
                (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
                self.image = UIImage(data: data)
            }
        }
    }
}
