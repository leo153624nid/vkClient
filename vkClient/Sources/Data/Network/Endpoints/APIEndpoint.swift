//
//  APIEndpoint.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 11.08.2023.
//

import Foundation

struct APIEndpoints {
    static func map(headers: [RequestHeader]) -> [String: String] {
        return headers
            .map({ [$0.key: $0.value] })
            .reduce([:], { $0.merge(dict: $1) })
    }
    
    static func generateAuthHeaders(with token: String) -> [String: String] { // TODO: - update headers
        return [
//            "Accept": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
}



extension Dictionary { // TODO: - move to own file
    func merge(dict: [Key: Value]) -> Self {
        var mutable = self
        for (k, v) in dict {
            mutable.updateValue(v, forKey: k)
        }
        return mutable
    }
}
