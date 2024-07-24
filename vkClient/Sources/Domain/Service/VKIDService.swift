//
//  VKIDService.swift
//  vkClient
//
//  Created by A Ch on 21.07.2024.
//

import Foundation
import UIKit
import VKID

protocol VKIDService {
    var sheetViewController: UIViewController? { get }
    
    func open(url: URL) -> Bool
}

final class VKIDServiceImpl: VKIDService {
    @Injected private var appState: Store<AppState>
    @Injected private var keychainStorage: KeychainStorage
    
    private let vkid: VKID
    
    var sheetViewController: UIViewController?
    
    init(clientId: String, clientSecret: String) {
        do {
            // Setup VKID
            let appCredentials = AppCredentials(clientId: clientId,
                                                clientSecret: clientSecret)
            let vkid = try VKID(config: Configuration(appCredentials: appCredentials))
            self.vkid = vkid
            
            // Setup SheetViewController
            let oneTapSheet = OneTapBottomSheet(
                serviceName: "vkClient",
                targetActionText: .signIn,
                oneTapButton: .init(height: .medium(.h44),
                                    cornerRadius: 8),
                theme: .matchingColorScheme(.system),
                autoDismissOnSuccess: true
            ) { [weak self] authResult in
                switch authResult {
                case .success(let result):
                    self?.appState[\.common].authToken = result.accessToken.value
                    self?.keychainStorage.setAuthToken(token: result.accessToken.value)
                case .failure(let error):
                    print(error.localizedDescription) // TODO: - show error in view
                }
            }
            self.sheetViewController = vkid.ui(for: oneTapSheet).uiViewController()
            
        } catch {
            preconditionFailure("Failed to initialize VKID: \(error)") // TODO: - show error, no failure
        }
    }
    
    func open(url: URL) -> Bool {
        return vkid.open(url: url)
    }
    
}
