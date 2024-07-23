//
//  AppState.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 04.08.2023.
//

import Foundation

public struct AppState: Equatable { // TODO
    var common: Common
    var newsFeed: NewsFeed
    
    var routing: Routing
    
    init(
        common: Common = .init(),
        newsFeed: NewsFeed = .init(),
        
        routing: Routing = .init()
    ) {
        self.common = common
        self.newsFeed = newsFeed
        
        self.routing = routing
    }
}

// MARK: - Modules
extension AppState {
    struct Common: Equatable {
        var authToken: String? {
            didSet {
                print(authToken)
            }
        }
        var isLoggedIn: Bool {
            authToken != nil
        }
    }
}

extension AppState {
    struct NewsFeed: Equatable {
        var items: [NewsItem] = [] {
            didSet {
                print("ITEMS.COUNT: \(items.count)")
            }
        }
    }
}

// MARK: - Routing
extension AppState {
    struct Routing: Equatable {
        var main = Main()
//        var content = Content()
//        var contacts = [AnyHashable: Contacts]()
    }
}

extension AppState.Routing {
    struct Main: Equatable {
        var showLoginView = false
    }
}

//extension AppState.Routing {
//    struct Content: Equatable {
//        var showCallingView = false
//        var showCallSummary = false
//        var showConversation = false
//        var conversationParams = ConversationParams()
//        
//        struct ConversationParams: Equatable {
//            var conversationId: Int?
//            var contactId: Int?
//            var contactName = ""
//            var phoneNumber = ""
//        }
//    }
//}

//extension AppState.Routing {
//    struct Contacts: Equatable {
//        var showSegmentsView = false
//        var showAddContactView = false
//        var showContactProfileView = false
//        var needToRefresh = true
//    }
//}
