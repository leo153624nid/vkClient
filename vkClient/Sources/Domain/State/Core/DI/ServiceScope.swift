//
//  ServiceScope.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 28.07.2023.
//

import Foundation

public class ServiceScope {

    func resolve<Service>(registration: ServiceRegistration<Service>) -> Service {
        fatalError("Not supported")
    }

    func reset() { }

    public static var unique: ServiceScope {
        UniqueServiceScope()
    }

    public static let application: ServiceScope = CachedServiceScope()

    public static let session: ServiceScope = CachedServiceScope()
}

final class UniqueServiceScope: ServiceScope {

    override func resolve<Service>(registration: ServiceRegistration<Service>) -> Service {
        registration.factory()
    }
}

final class CachedServiceScope: ServiceScope {

    private var cache: [AnyHashable: Any] = [:]

    override func resolve<Service>(registration: ServiceRegistration<Service>) -> Service {
        if let cached = cache[registration.identifier] as? Service {
            return cached
        }
        let service = registration.factory()
        cache[registration.identifier] = service
        return service
    }

    override func reset() {
        cache.removeAll()
    }
}
