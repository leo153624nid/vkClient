//
//  ContactsEndpoint.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 29.08.2023.
//

import Foundation

extension APIEndpoints {
    struct Contacts {
        private static let basePath = "contacts"
        private static let checkInPath = "check-in"
        private static let contactStatus = "contact-status"
        private static let customAttributeTypes = "custom-attributes-types"
        
//        static func fetchContacts(parameters: ContactsRequestParameters, token: String) -> Endpoint<ContactsData> {
//            let headerParameters = generateAuthHeaders(with: token)
//            return Endpoint(
//                path: "\(Contacts.basePath)",
//                method: .get,
//                headerParameters: headerParameters,
//                queryParametersEncodable: parameters,
//                requestEncoder: JSONRequestEncoder(),
//                responseDecoder: JSONResponseDecoder(
//                    dateDecodingStrategy: .secondsSince1970
//                )
//            )
//        }
        
        
    }
}
