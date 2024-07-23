//
//  NewsFeedData.swift
//  vkClient
//
//  Created by A Ch on 23.07.2024.
//

import Foundation

// MARK: - NewsFeedData
struct NewsFeedData: Decodable { // TODO: - update
    let items: [NewsItem]
    let newOffset: String?
    let nextFrom: String?
    let error: VKError?
    
    struct VKError: Decodable {
        let error_code: Int
        let error_msg: String
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.items = (try? container.decode([NewsItem].self, forKey: .items)) ?? []
        self.newOffset = try container.decodeIfPresent(String.self, forKey: .newOffset)
        self.nextFrom = try container.decodeIfPresent(String.self, forKey: .nextFrom)
        self.error = try? container.decodeIfPresent(VKError.self, forKey: .error)
    }
    
    enum CodingKeys: String, CodingKey {
        case items
        case newOffset = "new_offset"
        case nextFrom = "next_from"
        case error
    }
}

// MARK: - NewsItem
struct NewsItem: Decodable { // TODO: - update
    let postId: Int
    let date: Date
    let text: String

    init(
        postId: Int,
        date: Date,
        text: String
    ) {
        self.postId = postId
        self.date = date
        self.text = text
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.postId = try container.decode(Int.self, forKey: .postId)
        self.date = try container.decode(Date.self, forKey: .date)
        self.text = try container.decode(String.self, forKey: .text)
    }

    enum CodingKeys: String, CodingKey {
        case postId = "post_id"
        case date
        case text
    }
}

extension NewsItem: Equatable {
    static func == (lhs: NewsItem, rhs: NewsItem) -> Bool {
        lhs.postId == rhs.postId
        && lhs.date == rhs.date
        && lhs.text == rhs.text
    }
}
