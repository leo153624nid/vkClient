//
//  KeychainService.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 14.08.2023.
//

import Foundation
import KeychainSwift

protocol KeychainStorage {
    @discardableResult
    func setAuthToken(token: String) -> Bool
    
    func getAuthToken() -> String?
    
    @discardableResult
    func deleteAuthToken() -> Bool
    
    func clear()
}

final class KeychainStorageImpl {
    private let keychain = KeychainSwift()
    
    enum Keys: String, CaseIterable {
        case authTokenKey = "vkClientAuthToken"
    }
}

extension KeychainStorageImpl: KeychainStorage {
    @discardableResult
    func setAuthToken(token: String) -> Bool {
        keychain.set(token, forKey: Keys.authTokenKey.rawValue)
    }
    
    func getAuthToken() -> String? {
        guard let token = keychain.get(Keys.authTokenKey.rawValue) else {
            return nil
        }
        return token
    }
    
    @discardableResult
    func deleteAuthToken() -> Bool {
        keychain.delete(Keys.authTokenKey.rawValue)
    }
    
    func clear() {
        Keys.allCases.forEach { keychain.delete($0.rawValue) }
    }
    
}
