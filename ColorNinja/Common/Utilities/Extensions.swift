//
//  Extensions.swift
//  ZDZalo
//
//  Created by Duy Đỗ on 31/07/2021.
//

import UIKit

// MARK: UIView+Extension

extension UIView {
    
    public var width: CGFloat {
        return frame.size.width
    }
    
    public var height: CGFloat {
        return frame.size.height
    }

    public var top: CGFloat {
        return frame.origin.y
    }
    
    public var bottom: CGFloat {
        return frame.origin.y + frame.size.height
    }
    
    public var left: CGFloat {
        return frame.origin.x
    }
    
    public var right: CGFloat {
        return frame.origin.x + frame.size.width
    }
}

// MARK: String+Extension

extension String {
    func safeDatabaseKey() -> String {
        let s = self.replacingOccurrences(of: ".", with: "-")
        return s.replacingOccurrences(of: "@", with: "-")
    }
}

// MARK: Array+Extension

extension Array {
    
    func randAObject() -> Any? {
        if isEmpty {
            return nil
        }
        
        let randIndex = Int.random(in: 0..<self.count)
        return self[randIndex]
    }
}

// MARK: String+Extension

extension String {
    
    public func isEmptyAndCheckNoSpace() -> Bool {
        return replacingOccurrences(of: " ", with: "").isEmpty
    }
}
