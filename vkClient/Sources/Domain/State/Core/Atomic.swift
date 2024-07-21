//
//  Atomic.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {

    private var value: Value
    private let queue = DispatchQueue(label: "wrapper.atomic", attributes: .concurrent)

    public init(wrappedValue value: Value) {
        self.value = value
    }

    public var wrappedValue: Value {
        get {
            queue.sync { return value }
        }
        set {
            queue.sync(flags: .barrier) {
                value = newValue
            }
        }
    }
}
