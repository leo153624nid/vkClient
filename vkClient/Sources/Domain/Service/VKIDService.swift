//
//  VKIDService.swift
//  vkClient
//
//  Created by A Ch on 21.07.2024.
//

import Foundation
import VKID
import UIKit

protocol VKIDService {
    var sheetViewController: UIViewController { get }
    
    func open(url: URL) -> Bool
}

final class VKIDServiceImpl: VKIDService {
    var sheetViewController: UIViewController
    
    //    private let clientId = "52017937"
    //    private let clientSecret = "Ux1cPTrYQHW0C6XhYmSs"
    private let vkid: VKID
    
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
            ) { authResult in
                // authResult handling // TODO
            }
            self.sheetViewController = vkid.ui(for: oneTapSheet).uiViewController()
            
        } catch {
            preconditionFailure("Failed to initialize VKID: \(error)")
        }
    }
    
    func open(url: URL) -> Bool {
        return vkid.open(url: url)
    }
    
}
