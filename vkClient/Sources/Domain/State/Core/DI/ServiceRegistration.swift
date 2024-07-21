//
//  ServiceRegistration.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

struct ServiceRegistration<TService> {

    let identifier: ServiceIdentifier
    let factory: () -> TService
    let scope: ServiceScope
}
