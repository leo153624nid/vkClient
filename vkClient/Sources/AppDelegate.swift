//
//  AppDelegate.swift
//  vkClient
//
//  Created by A Ch on 20.07.2024.
//

import Foundation
import UIKit
import VKID

class AppDelegate: NSObject, UIApplicationDelegate {
//    private let clientId = "52017937"
//    private let clientSecret = "Ux1cPTrYQHW0C6XhYmSs"
    let vkid: VKID = { // TODO
        do {
            let vkid = try VKID(
                config: Configuration(
                    appCredentials: AppCredentials(
                        clientId: "52017937",         // ID вашего приложения
                        clientSecret: "Ux1cPTrYQHW0C6XhYmSs"  // ваш защищенный ключ (client_secret)
                    )
                )
            )
            return vkid
        } catch {
            preconditionFailure("Failed to initialize VKID: \(error)")
        }
    }()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {

        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey : Any] = [:]
    ) -> Bool {
        return self.vkid.open(url: url)
    }
}
