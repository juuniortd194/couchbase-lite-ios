//
//  Properties.swift
//  CouchbaseLite
//
//  Created by Jens Alfke on 2/9/17.
//  Copyright © 2017 Couchbase. All rights reserved.
//

import Foundation


public class Properties {

    public var properties : [String:Any]? {
        get {return convertGetterValue(_impl.properties) as? [String: Any]}
        set {_impl.properties = convertSetterValue(newValue) as? [String : Any]}
    }

    public func property(_ key: String) -> Any? {
        return convertGetterValue(_impl.object(forKey: key))
    }

    public func setProperty(_ key: String, _ value: Any?) {
        return _impl.setObject(convertSetterValue(value), forKey: key)
    }

    public func contains(_ key: String) -> Bool {
        return _impl.containsObject(forKey: key)
    }

    public subscript(key: String) -> Bool {
        get {return _impl.boolean(forKey: key)}
        set {_impl.setBoolean(newValue, forKey: key)}
    }

    public subscript(key: String) -> Int {
        get {return _impl.integer(forKey: key)}
        set {_impl.setInteger(newValue, forKey: key)}
    }

    public subscript(key: String) -> Float {
        get {return _impl.float(forKey: key)}
        set {_impl.setFloat(newValue, forKey: key)}
    }

    public subscript(key: String) -> Double {
        get {return _impl.double(forKey: key)}
        set {_impl.setDouble(newValue, forKey: key)}
    }

    public subscript(key: String) -> String? {
        get {return _impl.string(forKey: key)}
    }

    public subscript(key: String) -> Date? {
        get {return _impl.date(forKey: key)}
    }

    public subscript(key: String) -> Blob? {
        get {return _impl.object(forKey: key) as? Blob}
    }

    public subscript(key: String) -> [Any]? {
        get {return _impl.object(forKey: key) as? [Any]}
    }
    
    public subscript(key: String) -> Subdocument? {
        get {return convertGetterValue(_impl.object(forKey: key)) as? Subdocument}
    }
    
    public subscript(key: String) -> Any? {
        get {return property(key)}
        set {setProperty(key, newValue)}
    }

    init(_ impl: CBLProperties) {
        _impl = impl
    }

    let _impl: CBLProperties
    
    func convertGetterValue(_ value: Any?) -> Any? {
        switch value {
        case let implSubdoc as CBLSubdocument:
            if let subdoc = implSubdoc.swiftSubdocument {
                return subdoc
            }
            return Subdocument(implSubdoc)
        case let array as [Any]:
            var result: [Any] = [];
            for v in array { result.append(convertGetterValue(v)!) }
            return result
        case let dict as [String: Any]:
            var result: [String: Any] = [:]
            for (k, v) in dict { result[k] = convertGetterValue(v)! }
            return result
        default:
            return value
        }
    }
    
    func convertSetterValue(_ value: Any?) -> Any? {
        switch value {
        case let subdoc as Subdocument:
            return subdoc._subdocimpl
        case let array as [Any]:
            var result: [Any] = [];
            for v in array { result.append(convertSetterValue(v)!) }
            return result
        case let dict as [String: Any]:
            var result: [String: Any] = [:]
            for (k, v) in dict { result[k] = convertSetterValue(v)! }
            return result
        default:
            return value
        }
    }
}


public typealias Blob = CBLBlob
