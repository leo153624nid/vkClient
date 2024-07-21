//
//  AppState.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 04.08.2023.
//

import Foundation

public struct AppState: Equatable { // TODO
    var common: Common
    
    var routing: Routing
    
    init(
        common: Common = .init(),
        
        routing: Routing = .init()
    ) {
        self.common = common
        
        self.routing = routing
    }
}

// MARK: - Modules
extension AppState {
    struct Common: Equatable {
        var authToken: String?
        var firebaseToken: String?
        var isLoggedIn: Bool {
            authToken != nil
        }
        var userId: Int?
        var userName: String?
    }
}

// MARK: - Routing
extension AppState {
    struct Routing: Equatable {
        var main = Main()
        var content = Content()
        var contacts = [AnyHashable: Contacts]()
    }
}

extension AppState.Routing {
    struct Main: Equatable {
        var showDevMenu = false
        
        // State of current ConversationView
        // (Not allowed in Routing.Content, because changes in Content change parent of ConversationView)
        var conversationId: Int?
        var needToRefreshConversation = false
    }
}

extension AppState.Routing {
    struct Content: Equatable {
        var showCallingView = false
        var showCallSummary = false
        var showConversation = false
        var conversationParams = ConversationParams()
        
        struct ConversationParams: Equatable {
            var conversationId: Int?
            var contactId: Int?
            var contactName = ""
            var phoneNumber = ""
        }
    }
}

extension AppState.Routing {
    struct Contacts: Equatable {
        var showSegmentsView = false
        var showAddContactView = false
        var showContactProfileView = false
        var needToRefresh = true
    }
}
