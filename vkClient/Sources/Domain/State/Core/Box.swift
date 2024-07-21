//
//  Box.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

class Box<T> {

    var value: T?

    init(_ value: T?) {
        self.value = value
    }
}
