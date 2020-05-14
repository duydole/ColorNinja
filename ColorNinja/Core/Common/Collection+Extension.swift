//
//  String+Extension.swift
//  ZaloPayCommonSwift
//
//  Created by bonnpv on 11/1/17.
//  Copyright © 2017 VNG. All rights reserved.
//

import Foundation

public protocol CollectionExtensionBase {
    func toString() -> String
    func toBool() -> Bool
    func toInt() -> Int
    func toFloat() -> Float
    func toInt8() -> Int8
    func toInt16() -> Int16
    func toInt32() -> Int32
    func toInt64() -> Int64
    func toDouble() -> Double
    func toUInt() -> UInt
    func toUInt8() -> UInt8
    func toUInt16() -> UInt16
    func toUInt32() -> UInt32
    func toUInt64() -> UInt64
}

public protocol CollectionExtension: CollectionExtensionBase {
    func toString(defaultValue: String) -> String
    func toBool(defaultValue: Bool) -> Bool
    func toInt(defaultValue: Int) -> Int
    func toFloat(defaultValue: Float) -> Float
    func toInt8(defaultValue: Int8) -> Int8
    func toInt16(defaultValue: Int16) -> Int16
    func toInt32(defaultValue: Int32) -> Int32
    func toInt64(defaultValue: Int64) -> Int64
    func toDouble(defaultValue: Double) -> Double
    func toUInt(defaultValue: UInt) -> UInt
    func toUInt8(defaultValue: UInt8) -> UInt8
    func toUInt16(defaultValue: UInt16) -> UInt16
    func toUInt32(defaultValue: UInt32) -> UInt32
    func toUInt64(defaultValue: UInt64) -> UInt64
}

extension CollectionExtension {
    public func toBool() -> Bool {
        return toBool(defaultValue: false)
    }
    public func toInt() -> Int {
        return toInt(defaultValue: 0)
    }
    public func toFloat() -> Float {
        return toFloat(defaultValue: 0.0)
    }
    public func toInt8() -> Int8 {
        return toInt8(defaultValue: 0)
    }
    public func toInt16() -> Int16 {
        return toInt16(defaultValue: 0)
    }
    public func toInt32() -> Int32 {
        return toInt32(defaultValue: 0)
    }
    public func toInt64() -> Int64 {
        return toInt64(defaultValue: 0)
    }
    public func toString() -> String {
        return toString(defaultValue: "")
    }
    public func toDouble() -> Double {
        return toDouble(defaultValue: 0)
    }
    public func toUInt() -> UInt {
       return toUInt(defaultValue: 0)
    }
    public func toUInt8() -> UInt8 {
       return toUInt8(defaultValue: 0)
    }
    public func toUInt16() -> UInt16 {
        return toUInt16(defaultValue: 0)
    }
    public func toUInt32() -> UInt32 {
        return toUInt32(defaultValue: 0)
    }
    public func toUInt64() -> UInt64 {
        return toUInt64(defaultValue: 0)
    }
}

// MARK: - String
extension String: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        switch self {
        case "True", "true", "yes", "1":
            return true
        case "False", "false", "no", "0":
            return false
        default:
            return defaultValue
        }
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self) ?? defaultValue
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self) ?? defaultValue
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self) ?? defaultValue
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self) ?? defaultValue
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self) ?? defaultValue
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self) ?? defaultValue
    }
    public func toString(defaultValue: String) -> String {
        return self
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self) ?? defaultValue
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self) ?? defaultValue
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self) ?? defaultValue
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self) ?? defaultValue
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self) ?? defaultValue
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self) ?? defaultValue
    }
}

// MARK: - Int
extension Int: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return self
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Int
extension Bool: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self
    }
    public func toInt(defaultValue: Int) -> Int {
        return self == true ? 1 : 0
    }
    public func toFloat(defaultValue: Float) -> Float {
        return self == true ? 1 : 0
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return self == true ? 1 : 0
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return self == true ? 1 : 0
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return self == true ? 1 : 0
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return self == true ? 1 : 0
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return self == true ? 1 : 0
    }
    public func toUInt(defaultValue: UInt) -> UInt {
       return self == true ? 1 : 0
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
       return self == true ? 1 : 0
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
       return self == true ? 1 : 0
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
       return self == true ? 1 : 0
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
       return self == true ? 1 : 0
    }
}

// MARK: - Float
extension Float: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return self
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Int8
extension Int8: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return self
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Int16
extension Int16: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return self
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Int32
extension Int32: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return self
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Int64
extension Int64: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return self
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - Double
extension Double: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return self
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - UInt
extension UInt: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return self
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}


// MARK: - UInt8
extension UInt8: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return self
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - UInt16
extension UInt16: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return self
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}


// MARK: - UInt32
extension UInt32: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return self
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return UInt64(self)
    }
}

// MARK: - UInt64
extension UInt64: CollectionExtension {
    public func toBool(defaultValue: Bool) -> Bool {
        return self > 0
    }
    public func toInt(defaultValue: Int) -> Int {
        return Int(self)
    }
    public func toFloat(defaultValue: Float) -> Float {
        return Float(self)
    }
    public func toInt8(defaultValue: Int8) -> Int8 {
        return Int8(self)
    }
    public func toInt16(defaultValue: Int16) -> Int16 {
        return Int16(self)
    }
    public func toInt32(defaultValue: Int32) -> Int32 {
        return Int32(self)
    }
    public func toInt64(defaultValue: Int64) -> Int64 {
        return Int64(self)
    }
    public func toString(defaultValue: String) -> String {
        return String(self)
    }
    public func toDouble(defaultValue: Double) -> Double {
        return Double(self)
    }
    public func toUInt(defaultValue: UInt) -> UInt {
        return UInt(self)
    }
    public func toUInt8(defaultValue: UInt8) -> UInt8 {
        return UInt8(self)
    }
    public func toUInt16(defaultValue: UInt16) -> UInt16 {
        return UInt16(self)
    }
    public func toUInt32(defaultValue: UInt32) -> UInt32 {
        return UInt32(self)
    }
    public func toUInt64(defaultValue: UInt64) -> UInt64 {
        return self
    }
}









