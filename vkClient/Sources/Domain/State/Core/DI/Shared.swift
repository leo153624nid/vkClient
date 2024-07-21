//
//  Shared.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

private var sharedInstances = [AnyHashable: Any]()

@propertyWrapper
public struct Shared<T> {

    private let identifier: String

    public init(_ type: T.Type) {
        identifier = String(reflecting: type)
    }

    public init(wrappedValue defaultValue: T?) {
        identifier = String(reflecting: T.self)
        if defaultValue != nil {
            sharedInstances[identifier] = defaultValue
        }
    }

    public var wrappedValue: T? {
        get {
            sharedInstances[identifier] as? T
        }
        set {
            sharedInstances[identifier] = newValue
        }
    }
}
