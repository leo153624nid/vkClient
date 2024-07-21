//
//  AppDelegate.swift
//  vkClient
//
//  Created by A Ch on 20.07.2024.
//

import Foundation
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    @Injected private var vkIDService: VKIDService
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        return true
    }
    
    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        return vkIDService.open(url: url)
    }
}
