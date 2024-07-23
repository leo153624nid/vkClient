//
//  NewsFeedEndpoint.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Foundation

extension APIEndpoints {
    struct NewsFeed {
        private static let basePath = "newsfeed"
        private static let methodPath = ".get"
        
        static func fetchNews(parameters: NewsRequestParameters, token: String) -> Endpoint<NewsFeedData> {
            let headerParameters = generateAuthHeaders(with: token)
            return Endpoint(
                path: "\(NewsFeed.basePath)\(NewsFeed.methodPath)",
                method: .get,
                headerParameters: headerParameters,
                queryParametersEncodable: parameters,
                requestEncoder: JSONRequestEncoder(),
                responseDecoder: JSONResponseDecoder(
                    dateDecodingStrategy: .secondsSince1970
                )
            )
        }
        
    }
}
