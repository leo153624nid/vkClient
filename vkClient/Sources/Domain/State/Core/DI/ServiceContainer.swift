//
//  ServiceContainer.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

open class ServiceContainer {

    private let lock: NSRecursiveLock
    private var registrations: [AnyHashable: Any]

    public init() {
        lock = NSRecursiveLock()
        registrations = [:]
    }

    public func register<Service>(
        type: Service.Type,
        scope: ServiceScope = .unique,
        named: String? = nil,
        factory: @escaping () -> Service
    ) {
        defer { lock.unlock() }
        lock.lock()
        let identifier = ServiceIdentifier(type: String(reflecting: type), name: named)
        let registration = ServiceRegistration(identifier: identifier, factory: factory, scope: scope)
        registrations[identifier] = registration
    }

    public func resolve<Service>(type: Service.Type, named: String? = nil) -> Service {
        defer { lock.unlock() }
        lock.lock()
        let identifier = ServiceIdentifier(type: String(reflecting: type), name: named)
        guard let registration = registrations[identifier] as? ServiceRegistration<Service> else {
            fatalError("Service not found: \(identifier)")
        }
        return registration.scope.resolve(registration: registration)
    }

    public func reset(scope: ServiceScope) {
        defer { lock.unlock() }
        lock.lock()
        scope.reset()
    }
}
