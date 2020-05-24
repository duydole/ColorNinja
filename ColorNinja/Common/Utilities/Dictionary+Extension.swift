//
//  Dictionary+Extension.swift
//  ZaloPayCommonSwift
//
//  Created by bonnpv on 11/1/17.
//  Copyright © 2017 VNG. All rights reserved.
//

import Foundation


extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension Dictionary {
    public func int(forKey: Key, defaultValue: Int) -> Int {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let intValue = value as? Int {
            return intValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toInt()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toInt(defaultValue: defaultValue)
    }
    
    public func string(forKey:Key, defaultValue: String) -> String {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let strValue = value as? String {
            return strValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toString()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSNumber
        return "\(value)"
    }
    
    public func double(forKey:Key, defaultValue: Double) -> Double {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let doubleValue = value as? Double {
            return doubleValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toDouble()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toDouble(defaultValue: defaultValue)
    }
    
    public func float(forKey:Key, defaultValue: Float) -> Float {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let floatValue = value as? Float {
            return floatValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toFloat()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toFloat(defaultValue: defaultValue)
    }
    
    public func int8(forKey: Key, defaultValue: Int8) -> Int8 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let int8Value = value as? Int8 {
            return int8Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toInt8()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toInt8(defaultValue: defaultValue)
    }
    
    public func int16(forKey: Key, defaultValue: Int16) -> Int16 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let int16Value = value as? Int16 {
            return int16Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toInt16()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toInt16(defaultValue: defaultValue)
    }
    
    public func int32(forKey:Key, defaultValue: Int32) -> Int32 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let int32Value = value as? Int32 {
            return int32Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toInt32()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toInt32(defaultValue: defaultValue)
    }
    
    public func int64(forKey:Key, defaultValue: Int64) -> Int64 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let int64Value = value as? Int64 {
            return int64Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toInt64()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toInt64(defaultValue: defaultValue)
    }
    
    public func uInt(forKey:Key, defaultValue: UInt) -> UInt {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let uintValue = value as? UInt {
            return uintValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toUInt()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toUInt(defaultValue: defaultValue)
    }
    
    public func uInt8(forKey:Key, defaultValue: UInt8) -> UInt8 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let uint8Value = value as? UInt8 {
            return uint8Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toUInt8()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toUInt8(defaultValue: defaultValue)
    }
    
    public func uInt16(forKey:Key, defaultValue: UInt16) -> UInt16 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let uint16Value = value as? UInt16 {
            return uint16Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toUInt16()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toUInt16(defaultValue: defaultValue)
    }
    
    public func uInt32(forKey:Key, defaultValue: UInt32) -> UInt32 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let uint32Value = value as? UInt32 {
            return uint32Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toUInt32()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toUInt32(defaultValue: defaultValue)
    }
    
    public func uInt64(forKey:Key, defaultValue: UInt64) -> UInt64 {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let uint64Value = value as? UInt64 {
            return uint64Value
        }
        if let collection = value as? CollectionExtension {
            return collection.toUInt64()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toUInt64(defaultValue: defaultValue)
    }
    
    public func bool(forKey:Key, defaultValue: Bool) -> Bool {
        guard let value = self[forKey] else {
            return defaultValue
        }
        if let boolValue = value as? Bool {
            return boolValue
        }
        if let collection = value as? CollectionExtension {
            return collection.toBool()
        }
        // Case not String, Bool, Double, Float, Int, Int8, Int16, Int32, Int64, UInt, UInt8, UInt16, UInt32, UInt64
        // Example: NSTaggedPointerString
        return "\(value)".toBool(defaultValue: defaultValue)
    }
}

extension Dictionary where Key == Int {
    public func bool(forKey: Key) -> Bool {
        return bool(forKey: forKey, defaultValue: false)
    }
}

extension Dictionary where Value == Any{
    public func int(forKey: Key) -> Int {
        return int(forKey: forKey, defaultValue:0)
    }
    public func string(forKey: Key) -> String {
        return string(forKey: forKey, defaultValue: "")
    }
    public func double(forKey: Key) -> Double {
        return double(forKey: forKey, defaultValue: 0)
    }
    public func float(forKey: Key) -> Float {
        return float(forKey: forKey, defaultValue: 0)
    }
    public func int8(forKey: Key) -> Int8 {
        return int8(forKey: forKey, defaultValue: 0)
    }
    public func int16(forKey: Key) -> Int16 {
        return int16(forKey: forKey, defaultValue: 0)
    }
    public func int32(forKey: Key) -> Int32 {
        return int32(forKey: forKey, defaultValue: 0)
    }
    public func int64(forKey: Key) -> Int64 {
        return int64(forKey: forKey, defaultValue: 0)
    }
    public func uInt(forKey: Key) -> UInt {
        return uInt(forKey: forKey, defaultValue: 0)
    }
    public func uInt8(forKey: Key) -> UInt8 {
        return uInt8(forKey: forKey, defaultValue: 0)
    }
    public func uInt16(forKey: Key) -> UInt16 {
        return uInt16(forKey: forKey, defaultValue: 0)
    }
    public func uInt32(forKey: Key) -> UInt32 {
        return uInt32(forKey: forKey, defaultValue: 0)
    }
    public func uInt64(forKey: Key) -> UInt64 {
        return uInt64(forKey: forKey, defaultValue: 0)
    }
    public func bool(forKey: Key) -> Bool {
        return bool(forKey: forKey, defaultValue: false)
    }
}

public func += <K, V> (left: inout [K:V], right: [K:V]) {
    right.forEach { left[$0.key] = $0.value }
}

public extension Dictionary where Key == String{
    typealias ObjectType = [Key: Value]
    
    func copy() -> ObjectType {
        var shadow = ObjectType()
        shadow += self
        return shadow
    }
}

public typealias JSON = [String: Any]
public extension Dictionary where Value == Any {
    func value<T>(forKey key: Key, defaultValue: @autoclosure () -> T) -> T {
        guard let value = self[key] as? T else {
            return defaultValue()
        }
        return value
    }
}

public func +<T ,V>(lhs: [T: V], rhs: [T: V]) -> [T: V] {
    var lhs = lhs
    rhs.forEach({ lhs[$0.key] = $0.value })
    return lhs
}


public extension Dictionary where Key == String {
    /// Find value by path (note only use for dict [String: Any])
    ///
    /// - Parameters:
    ///   - path: this is string that has format: "key1.key2.key3"
    ///   - defaultValue: value default if it doesn't find
    /// - Returns: value
    func value<T>(forPath path: String, defaultValue: @autoclosure () -> T) -> T {
        guard self.keys.count > 0 else {
            return defaultValue()
        }
        var allNode = path.components(separatedBy: ".")
        guard allNode.count > 0 else { return defaultValue() }
        // condition
        var temp: JSON = self
        defer {
            temp.removeAll()
            allNode.removeAll()
        }
        let totalNode = allNode.count - 1
        finding: for node in allNode.enumerated() {
            if node.offset == totalNode {
                // Happy case
                return temp.value(forKey: node.element, defaultValue: defaultValue())
            }
            guard let next = temp[node.element] as? JSON else { break finding }
            temp = next
        }
        return defaultValue()
    }
}
