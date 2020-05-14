//
//  ZaloUser.swift
//  ColorNinja
//
//  Created by Do Huu Phuc on 5/13/20.
//  Copyright © 2020 Do Le Duy. All rights reserved.
//

import UIKit

fileprivate let kDefaultMale        = "male"

struct ConstantsZaloUserSwift {
    static let kDisplayName         = "name"
    static let kPicture             = "picture"
    static let kPictureData         = "data"
    static let kAvatar              = "url"
    static let kUserId              = "id"
    static let kUserGender          = "gender"
    static let kUsingZaloPay        = "usingApp"
    static let kAscciDisplayName    = "ascciDisplayName"
    static let kzaloPayId           = "zaloPayId"
}

private struct UMConstant {
    static let zaloid      = "zaloid"
    static let userid      = "userid"
    static let zalopayname = "zalopayname"
    static let avatar      = "avatar"
    static let displayname = "displayname"
    static let phonenumber = "phonenumber"
    static let repphonenumber = "repphonenumber"
    static let gender      = "gender"
    static let birthdate   = "birthdate"
}

private struct ZaloConstant {
    static let displayName  = "name"
    static let picture      = "picture"
    static let pictureData  = "data"
    static let largeAvatar  = "url"
    static let userId       = "id"
    static let userGender   = "gender"
    static let birthDate    = "birthday"
}

@objc public enum Gender : Int {
    case male = 1
    case female = 2
}
@objcMembers
public class ZaloUserSwift: NSObject {
    public var userId = ""
    public var displayName:String = "" {
        didSet {
                self.asciiDisplayName = displayName.uppercased()
                if let first = self.asciiDisplayName.first {
                    self.firstCharacterInDisplayName = String(first)
                } else {
                    self.firstCharacterInDisplayName = ""
                }
        }
    }
    public var avatar:String = ""
    public var gender: Gender = .male
    public var birthDay: Date =  Date()
    public var usedZaloPay = false
    // zaloPayId: userid trong hệ thống của zalopay
    // zaloPayName: zalopayid (accountname) trong hệ thống của zalopay
    public var zaloPayId:String = ""
    public var phone:String = ""
    public var replacePhone:String = ""
    public var zaloPayName:String = ""
    public var firstCharacterInDisplayName:String = ""
    public var asciiDisplayName:String = ""
    
    public class func userDictionary(_ user: ZaloUserSwift) -> [AnyHashable: Any] {
        var dict = [AnyHashable: Any]()
        dict[ConstantsZaloUserSwift.kDisplayName] = user.displayName
        dict[ConstantsZaloUserSwift.kAvatar] = user.avatar
        dict[ConstantsZaloUserSwift.kUserId] = user.userId
        dict[ConstantsZaloUserSwift.kUserGender] = user.gender.rawValue
        dict[ConstantsZaloUserSwift.kUsingZaloPay] = user.usedZaloPay
        dict[ConstantsZaloUserSwift.kAscciDisplayName] = user.asciiDisplayName
        dict[ConstantsZaloUserSwift.kzaloPayId] = user.zaloPayId
        return dict
    }
    
    public class func userFromDictionary(_ dictionary: [AnyHashable: Any],usingZaloPay:Bool = false ) -> ZaloUserSwift {
        return ZaloUserSwift(fromDictionary: dictionary,usingZaloPay:usingZaloPay)
    }
    
    convenience init(fromDictionary dictionary: [AnyHashable: Any],usingZaloPay:Bool) {
        self.init()
        self.userId = dictionary.string(forKey: ConstantsZaloUserSwift.kUserId)
        self.displayName = dictionary.string(forKey: ConstantsZaloUserSwift.kDisplayName)
        let picture = dictionary[ConstantsZaloUserSwift.kPicture] as? JSON
        let data = picture?[ConstantsZaloUserSwift.kPictureData] as? JSON
        self.avatar = data?.string(forKey: ConstantsZaloUserSwift.kAvatar) ?? ""
        self.gender = (dictionary.string(forKey: ConstantsZaloUserSwift.kUserGender)) == kDefaultMale ? .male : .female
        self.usedZaloPay = usingZaloPay//dictionary.bool(forKey: ConstantsZaloUserSwift.kUsingZaloPay)
    }
    
    public func compare(byDisplayValue other: ZaloUserSwift) -> ComparisonResult {
        return (asciiDisplayName ).compare((other.asciiDisplayName))
    }
    
    public override func isEqual(_ object: Any?) -> Bool {
        guard let orther = object as? ZaloUserSwift else {
            return false
        }
        return userId == orther.userId
    }
    
    public class func currentUserFromZaloPayUM(_ json: [AnyHashable: Any]?) -> ZaloUserSwift? {
        guard let json = json else {
            return nil
        }
        let user = ZaloUserSwift()
        user.userId = json.string(forKey: UMConstant.zaloid)
        user.zaloPayId = json.string(forKey: UMConstant.userid)
        user.zaloPayName = json.string(forKey: UMConstant.zalopayname)
        user.avatar = json.string(forKey: UMConstant.avatar)
        user.displayName = json.string(forKey: UMConstant.displayname)
        user.phone = json.string(forKey: UMConstant.phonenumber)
        user.replacePhone = json.string(forKey: UMConstant.repphonenumber)
        user.gender = Gender.init(rawValue: json.int(forKey: UMConstant.gender)) ?? Gender.female
        user.birthDay = Date.init(timeIntervalSince1970: json.double(forKey: UMConstant.birthdate))
        return user
    }
    
    public class func currentUserFromZaloSDK(_ json: [AnyHashable: Any]?) -> ZaloUserSwift? {
        guard let json = json else {
            return nil
        }
        let currentUser = ZaloUserSwift()
        currentUser.displayName = json.string(forKey: ZaloConstant.displayName)
        let picture = json[ZaloConstant.picture] as? JSON
        let data = picture?[ZaloConstant.pictureData] as? JSON
        currentUser.avatar = data?.string(forKey: ZaloConstant.largeAvatar) ?? ""
        currentUser.userId = json.string(forKey: ZaloConstant.userId)
        currentUser.gender =  json.string(forKey: ZaloConstant.userGender) == kDefaultMale ? .male : .female
        currentUser.birthDay = Date.date(from: json.string(forKey: ZaloConstant.birthDate), format: "dd/mm/yyyy") ?? Date()
        return currentUser
    }
    
    public func coppy() -> ZaloUserSwift {
        let user = ZaloUserSwift()
        user.userId = self.userId
        user.displayName = self.displayName
        user.avatar = self.avatar
        user.gender = self.gender
        user.birthDay = self.birthDay
        user.usedZaloPay = self.usedZaloPay
        user.zaloPayId = self.zaloPayId
        user.phone = self.phone
        user.replacePhone = self.replacePhone
        user.zaloPayName = self.zaloPayName
        return user
    }
}

