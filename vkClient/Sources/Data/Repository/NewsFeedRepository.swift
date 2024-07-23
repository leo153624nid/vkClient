//
//  NewsFeedRepository.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Foundation

protocol NewsFeedRepository {
    func fetchNews(parameters: NewsRequestParameters, token: String) async throws -> NewsFeedData
}

final class NewsFeedRepositoryImpl {
    @Injected private var dataTransferService: DataTransferService
}

extension NewsFeedRepositoryImpl: NewsFeedRepository {
    func fetchNews(parameters: NewsRequestParameters, token: String) async throws -> NewsFeedData {
        let endpoint = APIEndpoints.NewsFeed.fetchNews(parameters: parameters, token: token)
        return try await dataTransferService.request(with: endpoint)
    }
    
}
