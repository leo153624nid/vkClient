//
//  AppConfiguration.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 16.08.2023.
//

import Foundation

final class AppConfiguration {
    private lazy var plistContent: [String: Any] = {
        var plistFormat = PropertyListSerialization.PropertyListFormat.xml
        guard let path = Bundle.main.path(forResource: "AppConfiguration", ofType: "plist") else {
            fatalError(ConfigurationError.pathNotFound("AppConfiguration.plist").localizedDescription)
        }
        guard let xml = FileManager.default.contents(atPath: path) else {
            fatalError(ConfigurationError.fileNotFound(path).localizedDescription)
        }
        do {
            guard let plistData = try PropertyListSerialization.propertyList(
                from: xml,
                options: .mutableContainersAndLeaves,
                format: &plistFormat
            ) as? [String: Any] else {
                fatalError(ConfigurationError.unexpectedType.localizedDescription)
            }
            return plistData
        } catch {
            print(error)
            fatalError(ConfigurationError.unexpectedType.localizedDescription)
        }
    }()
    
    lazy var appSchemaVersion: UInt64 = {
        guard let schema = plistContent["app_schema_version"] as? UInt64 else {
            fatalError("Bad app_schema_version")
        }
        return schema
    }()

    lazy var baseUrl: URL = {
        guard let urlString = plistContent["base_url"] as? String, let url = URL(string: urlString) else {
            fatalError("Bad base_url")
        }
        return url
    }()

    lazy var requiredHeaders: [String: String] = {
        guard let headers = plistContent["required_headers"] as? [String: String] else {
            return [:]
        }
        return headers
    }()
    
    lazy var clientId: String = {
        guard let clientId = plistContent["vk_client_id"] as? String else {
            fatalError("Bad vk_client_id")
        }
        return clientId
    }()
    
    lazy var clientSecret: String = {
        guard let clientSecret = plistContent["vk_client_secret"] as? String else {
            fatalError("Bad vk_client_secret")
        }
        return clientSecret
    }()

}

extension AppConfiguration {
    enum ConfigurationError: Error {
        case pathNotFound(String)
        case fileNotFound(String)
        case unexpectedType
        
        var localizedDescription: String {
            switch self {
            case let .pathNotFound(filename):
                return "Could not find path for file \(filename)"
            case let .fileNotFound(path):
                return "Could not find any file at path \(path)"
            case .unexpectedType:
                return "Unexpected file type"
            }
        }
    }
}
