//
//  MainViewModel.swift
//  vkClient
//
//  Created by A Ch on 21.07.2024.
//

import Combine
import Foundation
import SwiftUI
import UIKit

enum MainAction {
    case showLoginView
}

final class MainViewModel: ObservableObject {
//    @Injected private var credentialsService: CredentialsService
//    @Injected private var connectivityManager: ConnectivityManager
    @Injected private var appState: Store<AppState>
    @Injected private var vkIDService: VKIDService
    @Injected private var keychainStorage: KeychainStorage

    private var cancellables = Set<AnyCancellable>()

    @Published var showLoginView = false
    @Published var isLoggedIn = true
    
    let feedViewModel = FeedViewModel()
    var sheetViewController: UIViewController? { vkIDService.sheetViewController }
    var backgroundColor: Color {
        isLoggedIn ? .green : .red
    }
    
    init() {
        restoreAuthorization()
        setupUpdates()
//        startNetworkConectionMonitor()
    }

    func perform(action: MainAction) {
        switch action {
        case .showLoginView:
            showLoginView.toggle()
        }
    }
    
    private func startAuth() {
        perform(action: .showLoginView)
    }

    private func restoreAuthorization() {
        guard let token = keychainStorage.getAuthToken() else {
            appState[\.common].authToken = nil
            isLoggedIn = false
            return
        }
        appState[\.common].authToken = token
        isLoggedIn = true
    }
    
//    private func startNetworkConectionMonitor() {
//        connectivityManager.startNetworkConectionMonitor()
//    }
    
}

private extension MainViewModel {
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
        
    }

    func setupRoutingUpdates() {
        appState.updates(for: \.routing.main.showLoginView)
            .dropFirst()
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                self?.showLoginView = updated
            }
            .store(in: &cancellables)

        $showLoginView
            .dropFirst()
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.appState[\.routing].main.showLoginView = newValue
            }
            .store(in: &cancellables)
    }
}
