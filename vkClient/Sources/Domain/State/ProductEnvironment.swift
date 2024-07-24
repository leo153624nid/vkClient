//
//  ProductEnvironment.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 08.08.2023.
//

import Foundation

final class ProductEnvironment: ServiceContainer { // TODO: - delete //comments
    private lazy var appConfiguration = AppConfiguration()
    
    override init() {
        super.init()

        registerAppState()
        registerDataTransferService()
        registerVKIDService()
//        registerConnectivityManager()
        registerCredentialsModule()
        registerNewsFeedModule()
    }
    
    private func registerAppState() {
        register(type: Store<AppState>.self, scope: .application) {
            Store<AppState>(.init())
        }
    }
    
    private func registerDataTransferService() {
        register(type: DataTransferService.self) {
            DefaultDataTransferService(
                with: DefaultNetworkService(
                    config: ApiDataNetworkConfig(
                        baseURL: self.appConfiguration.baseUrl,
                        headers: self.appConfiguration.requiredHeaders
                    ),
                    logger: NetworkErrorLoggerImpl()
                )
            )
        }
    }
    
    private func registerVKIDService() {
        register(type: VKIDService.self) {
            VKIDServiceImpl(clientId: self.appConfiguration.clientId,
                            clientSecret: self.appConfiguration.clientSecret)
        }
    }

//    private func registerConnectivityManager() {
//        register(type: ConnectivityManager.self, scope: .application) {
//            ConnectivityManager(logger: os.Logger.monitor)
//        }
//    }
    
    private func registerCredentialsModule() {
//        register(type: CredentialsService.self) {
//            CredentialsServiceImpl()
//        }
//        register(type: AuthRepository.self) {
//            AuthRepositoryImpl()
//        }
//        register(type: RefreshTokenRepository.self) {
//            RefreshTokenRepositoryImpl(logger: os.Logger.auth)
//        }
        register(type: KeychainStorage.self) {
            KeychainStorageImpl()
        }
    }
    
    private func registerNewsFeedModule() {
        register(type: NewsFeedService.self) {
            NewsFeedServiceImpl()
        }
        register(type: NewsFeedRepository.self) {
            NewsFeedRepositoryImpl()
        }
    }
    
}
