//
//  MainViewModel.swift
//  vkClient
//
//  Created by A Ch on 21.07.2024.
//

import Combine
import Foundation
import UIKit

enum MainAction {
    case showLoginView
}

final class MainViewModel: ObservableObject {
//    @Injected private var credentialsService: CredentialsService
    @Injected private var appState: Store<AppState>
//    @Injected private var connectivityManager: ConnectivityManager
    @Injected private var vkIDService: VKIDService

    private var cancellables = Set<AnyCancellable>()

    @Published var showLoginView = false
    // TODO
    @Published var isLoggedIn = true
    @Published var messagingToken: String?
    @Published var displayDevMenu = false
    
    var sheetViewController: UIViewController { vkIDService.sheetViewController }
    
//    let contentVM = ContentViewModel()

    init() {
        setupUpdates()
        setupRoutingUpdates()
//        restoreAuthorization()
//        startNetworkConectionMonitor()
    }

    func perform(action: MainAction) {
        switch action {
        case .showLoginView:
//            guard EnvironmentChecker.isDebug else { return }
//            appState[\.routing].main.showDevMenu = true
            showLoginView.toggle() // TODO: - from appState ?
        }
    }

//    private func restoreAuthorization() {
//        Task {
//            credentialsService.restoreToken()
//        }
//    }
    
//    private func startNetworkConectionMonitor() {
//        connectivityManager.startNetworkConectionMonitor()
//    }
    
}

private extension MainViewModel {
    func setupUpdates() {
        setupStateUpdates()
    }
    
    func setupStateUpdates() {
        Publishers.CombineLatest($isLoggedIn, $messagingToken)
            .sink { [weak self] isLoggedIn, token in
                guard let self else { return }
                if isLoggedIn, token != nil {
//                    self.updateFirebaseToken()
                }
            }
            .store(in: &cancellables)
        
        appState.updates(for: \.common.isLoggedIn)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                guard let self else { return }
                self.isLoggedIn = updated
                if isLoggedIn {
//                    self.registerCalls()
                }
            }
            .store(in: &cancellables)
        
        appState.updates(for: \.common.firebaseToken)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                guard let self else { return }
                self.messagingToken = updated
            }
            .store(in: &cancellables)
    }

    func setupRoutingUpdates() {
        appState.updates(for: \.routing.main.showDevMenu)
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] updated in
                self?.displayDevMenu = updated
            }
            .store(in: &cancellables)

        $displayDevMenu
            .removeDuplicates()
            .sink { [weak self] newValue in
                self?.appState[\.routing].main.showDevMenu = newValue
            }
            .store(in: &cancellables)
    }
}
