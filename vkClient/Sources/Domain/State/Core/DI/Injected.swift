//
//  Injected.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import SwiftUI

@propertyWrapper
public struct Injected<T> {

    @Atomic var dependency: Box<T> = Box(nil)
    let name: String?

    public init(named: Bool = false, by source: String = #fileID) {
        name = named ? source.components(separatedBy: "/").first : nil
    }

    public var wrappedValue: T {
        get {
            guard let services = Shared(ServiceContainer.self).wrappedValue else {
                fatalError("Service container not defined")
            }
            if dependency.value == nil {
                dependency.value = services.resolve(type: T.self, named: name)
            }
            return dependency.value!
        }
        mutating set {
            dependency.value = newValue
        }
    }
}
