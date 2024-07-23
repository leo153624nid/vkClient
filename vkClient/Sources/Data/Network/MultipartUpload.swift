//
//  MultipartUpload.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 15.11.2023.
//

import Foundation

public struct MultipartUpload: Equatable, Hashable {
    let fileName: String
    let mimeType: MimeType
    let data: Data
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(fileName)
        hasher.combine(mimeType.value)
        hasher.combine(data)
    }
    
    public static func == (lhs: MultipartUpload, rhs: MultipartUpload) -> Bool {
        return lhs.fileName == rhs.fileName && lhs.mimeType.value == rhs.mimeType.value
    }
}

extension MultipartUpload: Encodable {
    enum CodingKeys: String, CodingKey {
        case fileName
        case mimeType
        case data
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(fileName, forKey: .fileName)
        try container.encode(mimeType.value, forKey: .mimeType)
        try container.encode(data.base64EncodedString(), forKey: .data)
    }
}

public struct MimeType {
    private let ext: String?
    public var value: String {
        guard let ext = ext else {
            return DEFAULT_MIME_TYPE
        }
        return MIME_TYPES[ext.lowercased()] ?? DEFAULT_MIME_TYPE
    }
    
    public init(fileExtension: String) {
        ext = fileExtension
    }
}
