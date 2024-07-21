//
//  Store.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Combine

public typealias Store<State> = CurrentValueSubject<State, Never>

public extension Store {
    
    subscript<T>(keyPath: WritableKeyPath<Output, T>) -> T where T: Equatable {
        get {
            value[keyPath: keyPath]
        }
        set {
            var value = self.value
            if value[keyPath: keyPath] != newValue {
                value[keyPath: keyPath] = newValue
                self.value = value
            }
        }
    }

    func updates<Value>(for keyPath: KeyPath<Output, Value>) -> AnyPublisher<Value, Failure> where Value: Equatable {
        return map(keyPath).removeDuplicates().eraseToAnyPublisher()
    }

}
