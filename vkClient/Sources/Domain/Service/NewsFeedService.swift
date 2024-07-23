//
//  NewsFeedService.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Foundation

//protocol NewsFeedService: ConnectivityManagerProtocol {
protocol NewsFeedService {
    func loadNextPage()
    func refreshData()
}

final class NewsFeedServiceImpl {
    @Injected private var repository: NewsFeedRepository
    @Injected private var appState: Store<AppState>
//    @Injected private var connectivityManager: ConnectivityManager
    
    private let pageSize = 10
}

extension NewsFeedServiceImpl: NewsFeedService {
    var isOffline: Bool {
//        connectivityManager.isOffline
        return false
    }
    
    func loadNextPage() {
        Task {
            if !isOffline {
//                let page = appState[\.contacts][viewId]?.page ?? 1
                let params = NewsRequestParameters(
                    filters: nil,
                    startFrom: nil,
                    count: pageSize
                )
                
                do {
                    let newsData = try await loadNewsFromNetwork(parameters: params)
                    
//                    if page == contactsData.meta.pagination.totalPages {
//                        appState[\.contacts][viewId]?.hasMoreItems = false
//                    } else {
//                        appState[\.contacts][viewId]?.hasMoreItems = true
//                        appState[\.contacts][viewId]?.page += 1
//                    }
                    
                    appState[\.newsFeed].items.append(contentsOf: newsData.items)
//                    appState[\.contacts][viewId]?.errorString = ""
//                    appState[\.contacts][viewId]?.showBanner = false
                } catch {
//                    appState[\.contacts][viewId]?.errorString = error.localizedDescription
//                    appState[\.contacts][viewId]?.showBanner = true
                    print(error)
                }
            } else {
                // offline mode
                print("offline")
            }
        }
    }
    
    func refreshData() { // TODO: - update
//        Task {
//            appState[\.contacts][viewId]?.isLoading = true
//            
//            if !isOffline {
//                do {
//                    let params = ContactsRequestParameters(
//                        contactType: contactType,
//                        keyword: nil,
//                        segmentId: segmentId,
//                        page: 1,
//                        perPage: pageSize
//                    )
//                    
//                    let contactsData = try await loadContactsFromNetwork(parameters: params)
//                    
//                    if params.page == contactsData.meta.pagination.totalPages {
//                        appState[\.contacts][viewId]?.hasMoreItems = false
//                        appState[\.contacts][viewId]?.page = params.page
//                    } else {
//                        appState[\.contacts][viewId]?.hasMoreItems = true
//                        appState[\.contacts][viewId]?.page = params.page + 1
//                    }
//                    
//                    appState[\.contacts][viewId]?.contacts = contactsData.data
//                    try await contactStorage.save(list: contactsData.data)
//                    appState[\.contacts][viewId]?.showBanner = false
//                    appState[\.contacts][viewId]?.errorString = ""
//                } catch {
//                    appState[\.contacts][viewId]?.isLoading = false
//                    appState[\.contacts][viewId]?.showBanner = true
//                    appState[\.contacts][viewId]?.errorString = error.localizedDescription
//                }
//            } else {
//                // offline mode
//                await getAllContactsFromDataBase(contactType: contactType, viewId: viewId)
//            }
//            
//            appState[\.routing].contacts[viewId]?.needToRefresh = false
//            appState[\.contacts][viewId]?.isLoading = false
//        }
    }
    
    private func loadNewsFromNetwork(parameters: NewsRequestParameters) async throws -> NewsFeedData {
        guard let token = appState[\.common].authToken else {
            throw AppStateTokenError.noToken
        }
        return try await repository.fetchNews(parameters: parameters, token: token)
    }
    
}
