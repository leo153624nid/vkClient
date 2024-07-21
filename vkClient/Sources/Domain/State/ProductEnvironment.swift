//
//  ProductEnvironment.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 08.08.2023.
//

import Foundation

final class ProductEnvironment: ServiceContainer {
        private let clientId = "52017937" // TODO
        private let clientSecret = "Ux1cPTrYQHW0C6XhYmSs"
    
    override init() {
        super.init()

        registerAppState()
        registerVKIDService()
//        registerConnectivityManager()
//        registerDataTransferService()
//        registerCredentialsModule()
//        registerContactsModule()
    }
    
    private func registerAppState() {
        register(type: Store<AppState>.self, scope: .application) {
            Store<AppState>(.init())
        }
    }
    
    private func registerVKIDService() {
        register(type: VKIDService.self) {
            VKIDServiceImpl(clientId: self.clientId, clientSecret: self.clientSecret)
        }
    }

//    private func registerConnectivityManager() {
//        register(type: ConnectivityManager.self, scope: .application) {
//            ConnectivityManager(logger: os.Logger.monitor)
//        }
//    }
    
//    private func registerDataTransferService() {
//        register(type: DataTransferService.self) {
//            let standService = StandServiceImpl()
//            standService.setupStand()
//
//            return DefaultDataTransferService(
//                with: DefaultNetworkService(
//                    config: ApiDataNetworkConfig(
//                        baseURL: standService.baseURL,
//                        headers: standService.requiredHeaders
//                    ),
//                    logger: NetworkErrorLoggerImpl() // now unused
//                )
//            )
//        }
//    }
    
//    private func registerCredentialsModule() {
//        register(type: CredentialsService.self) {
//            CredentialsServiceImpl()
//        }
//        register(type: AuthRepository.self) {
//            AuthRepositoryImpl()
//        }
//        register(type: RefreshTokenRepository.self) {
//            RefreshTokenRepositoryImpl(logger: os.Logger.auth)
//        }
//        register(type: KeychainStorage.self) {
//            KeychainStorageImpl()
//        }
//        register(type: AccountRepository.self) {
//            AccountRepositoryImpl()
//        }
//    }
    
//    private func registerContactsModule() {
//        register(type: ContactsService.self) {
//            ContactsServiceImpl()
//        }
//        register(type: ContactsRepository.self) {
//            ContactsRepositoryImpl()
//        }
//    }
    
}
