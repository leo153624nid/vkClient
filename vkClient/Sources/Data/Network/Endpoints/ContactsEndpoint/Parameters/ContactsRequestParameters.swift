//
//  ContactsParameters.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 29.08.2023.
//

import Foundation

struct ContactsRequestParameters: Encodable {
    let keyword: String?
    let segmentId: Int?
    let page: Int
    let perPage: Int
    let orderBy = "recent_activity"
    let includeUnnasigned = false
    
    enum CodingKeys: String, CodingKey {
        case keyword
        case segmentId = "segment_id"
        case page
        case perPage = "per_page"
        case orderBy = "order_by"
        case includeUnnasigned = "include_unassigned"
    }
}

struct ContactRequestParameters: Encodable {
    let include: [[CodingKey]]
    
    enum CodingKeys: String, CodingKey {
        case include
    }
    
    init(fields: [[CodingKey]] = [
//        [Contact.CodingKeys.user],
//        [Contact.CodingKeys.status],
//        [Contact.CodingKeys.company],
//        [Contact.CodingKeys.address],
//        [Contact.CodingKeys.workPhone],
//        [Contact.CodingKeys.mobilePhone],
//        [Contact.CodingKeys.collaborators],
//        [Contact.CodingKeys.customAttributes, Contact.CodingKeys.type]
    ]) {
        self.include = fields
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

//        let fieldsString = FieldsParameterMapper.map(fields: include)
//        try container.encode(fieldsString, forKey: .include)
    }
}

struct CompanyContactsRequestParameters: Encodable {
    let companyId: Int
    
    enum CodingKeys: String, CodingKey {
        case companyId = "company_id"
    }
}
