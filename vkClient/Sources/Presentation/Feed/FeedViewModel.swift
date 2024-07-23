//
//  FeedViewModel.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Combine
import Foundation
import SwiftUI
import UIKit

enum FeedAction {
    case loadNextPage
    case showLoginView
}

final class FeedViewModel: ObservableObject {
    @Injected private var appState: Store<AppState>
//    @Injected private var vkIDService: VKIDService
    @Injected private var newsFeedService: NewsFeedService

    private var cancellables = Set<AnyCancellable>()

    @Published var items: [NewsItem] = []
    @Published var showLoginView = false
    @Published var isLoggedIn = false
    
    init() {
        setupUpdates()
    }

    func perform(action: FeedAction) {
        switch action {
        case .loadNextPage:
            newsFeedService.loadNextPage()
        case .showLoginView:
            showLoginView.toggle()
        }
    }
    
}

private extension FeedViewModel {
    func setupUpdates() {
        setupStateUpdates()
        setupRoutingUpdates()
    }
    
    func setupStateUpdates() {
        appState.updates(for: \.common.isLoggedIn)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                guard let self else { return }
                self.isLoggedIn = updated
            }
            .store(in: &cancellables)
        
        appState.updates(for: \.newsFeed)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                guard let self else { return }
                self.items = updated.items
            }
            .store(in: &cancellables)
        
    }

    func setupRoutingUpdates() {
//        appState.updates(for: \.routing.main.showLoginView)
//            .dropFirst()
//            .removeDuplicates()
//            .receive(on: DispatchQueue.main)
//            .sink { [weak self] updated in
//                self?.showLoginView = updated
//            }
//            .store(in: &cancellables)
//
//        $showLoginView
//            .dropFirst()
//            .removeDuplicates()
//            .sink { [weak self] newValue in
//                self?.appState[\.routing].main.showLoginView = newValue
//            }
//            .store(in: &cancellables)
    }
}
