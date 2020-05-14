//
//  Date+Extension.swift
//  ZaloPayCommonSwift
//
//  Created by vuongvv on 8/2/18.
//  Copyright © 2018 VNG. All rights reserved.
//

import UIKit

// MARK: -- Date
public extension Date {
    func string(using format: String = "yyyyMMddHHmm", with timeZone: TimeZone = .current) -> String {
        let formater = DateFormatter()
        formater.dateFormat = format
        formater.timeZone = timeZone
        formater.calendar = Calendar(identifier: .gregorian)
        return formater.string(from: self)
    }
    
    static func date(from string: String?, format: String = "yyyyMMddHHmm") -> Date? {
        guard let string = string else {
            return nil
        }
        let formater = DateFormatter()
        formater.dateFormat = format
        formater.timeZone = TimeZone(secondsFromGMT: 0)
        formater.calendar = Calendar(identifier: .gregorian)
        return formater.date(from: string)
    }
}
