//
//  NewsRequestParameters.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Foundation

struct NewsRequestParameters: Encodable { // TODO: - update
    let filters: String?
    let startFrom: String?
    let count: Int
    let v: String = "5.199"
    
    enum CodingKeys: String, CodingKey {
        case filters
        case startFrom = "start_from"
        case count
        case v
    }
}
