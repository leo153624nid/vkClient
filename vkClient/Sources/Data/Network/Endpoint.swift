//
//  Endpoint.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 04.08.2023.
//

import Foundation

enum HTTPMethodType: String {
    case `get`  = "GET"
    case post   = "POST"
    case put    = "PUT"
    case patch  = "PATCH"
    case delete = "DELETE"
}

enum BodyEncoding {
    case jsonSerializationData
    case stringEncodingAscii
}

struct Endpoint<R>: ResponseRequestable {
    
    typealias Response = R
    
    let path: String
    let isFullPath: Bool
    let method: HTTPMethodType
    let headerParameters: [String: String]
    let queryParametersEncodable: Encodable?
    let queryParameters: [String: Any]
    let bodyParametersEncodable: Encodable?
    let bodyParameters: [String: Any]
    let bodyEncoding: BodyEncoding
    let encodeBodyWithoutDictionary: Bool
    let requestEncoder: RequestEncoder
    let responseDecoder: ResponseDecoder

    init(
        path: String,
        isFullPath: Bool = false,
        method: HTTPMethodType,
        headerParameters: [String: String] = [:],
        queryParametersEncodable: Encodable? = nil,
        queryParameters: [String: Any] = [:],
        bodyParametersEncodable: Encodable? = nil,
        bodyParameters: [String: Any] = [:],
        bodyEncoding: BodyEncoding = .jsonSerializationData,
        requestEncoder: RequestEncoder = JSONRequestEncoder(),
        responseDecoder: ResponseDecoder = JSONResponseDecoder(),
        encodeBodyWithoutDictionary: Bool = false
    ) {
        self.path = path
        self.isFullPath = isFullPath
        self.method = method
        self.headerParameters = headerParameters
        self.queryParametersEncodable = queryParametersEncodable
        self.queryParameters = queryParameters
        self.bodyParametersEncodable = bodyParametersEncodable
        self.bodyParameters = bodyParameters
        self.bodyEncoding = bodyEncoding
        self.requestEncoder = requestEncoder
        self.responseDecoder = responseDecoder
        self.encodeBodyWithoutDictionary = encodeBodyWithoutDictionary
    }
    
    func set(headerParameters: [String: String]) -> Endpoint<R> {
        return Endpoint<R>(
            path: self.path,
            isFullPath: self.isFullPath,
            method: self.method,
            headerParameters: headerParameters,
            queryParametersEncodable: self.queryParametersEncodable,
            queryParameters: self.queryParameters,
            bodyParametersEncodable: self.bodyParametersEncodable,
            bodyParameters: self.bodyParameters,
            bodyEncoding: self.bodyEncoding,
            requestEncoder: self.requestEncoder,
            responseDecoder: self.responseDecoder,
            encodeBodyWithoutDictionary: self.encodeBodyWithoutDictionary
        )
    }
}

protocol ResponseRequestable: Requestable {
    associatedtype Response
}

protocol Requestable {
    
    var path: String { get }
    var isFullPath: Bool { get }
    var method: HTTPMethodType { get }
    var headerParameters: [String: String] { get }
    var queryParametersEncodable: Encodable? { get }
    var queryParameters: [String: Any] { get }
    var bodyParametersEncodable: Encodable? { get }
    var bodyParameters: [String: Any] { get }
    var bodyEncoding: BodyEncoding { get }
    var encodeBodyWithoutDictionary: Bool { get }
    var requestEncoder: RequestEncoder { get }
    var responseDecoder: ResponseDecoder { get }
    
    func urlRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
    func multipartRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest
    func set(headerParameters: [String: String]) -> Self
}

enum RequestGenerationError: Error {
    case components
}

extension Requestable {
    func url(with config: NetworkConfigurable) throws -> URL {
        let baseURL = config.baseURL.absoluteString.last != "/"
        ? config.baseURL.absoluteString + "/"
        : config.baseURL.absoluteString
        let endpoint = isFullPath ? path : baseURL.appending(path)
        
        guard var urlComponents = URLComponents(string: endpoint) else { throw RequestGenerationError.components }
        var urlQueryItems = [URLQueryItem]()

        let queryParameters = try queryParametersEncodable?.toDictionary(encoder: requestEncoder) ??
        self.queryParameters
        queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        config.queryParameters.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: $0.value))
        }
        if !urlQueryItems.isEmpty {
            urlComponents.queryItems = urlQueryItems
        }
        guard let url = urlComponents.url else { throw RequestGenerationError.components }
        return url
    }
    
    func urlRequest(with config: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: config)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = config.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        if bodyParametersEncodable != nil {
            allHeaders["Content-Type"] = "application/json"
        }

        if !encodeBodyWithoutDictionary {
            let bodyParamaters = try bodyParametersEncodable?.toDictionary(encoder: requestEncoder)
            ?? self.bodyParameters
            if !bodyParamaters.isEmpty {
                urlRequest.httpBody = encodeBody(bodyParamaters: bodyParamaters, bodyEncoding: bodyEncoding)
            }
        } else if let bodyParamaters = try? bodyParametersEncodable?.toData(encoder: requestEncoder) {
            urlRequest.httpBody = bodyParamaters
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        return urlRequest
    }
    
    func multipartRequest(with networkConfig: NetworkConfigurable) throws -> URLRequest {
        let url = try self.url(with: networkConfig)
        var urlRequest = URLRequest(url: url)
        var allHeaders: [String: String] = networkConfig.headers
        headerParameters.forEach { allHeaders.updateValue($1, forKey: $0) }
        let boundary = "Boundary-\(UUID().uuidString)"
        allHeaders["Content-Type"] = "multipart/form-data; boundary=\(boundary)"
        
        let bodyParameters = try bodyParametersEncodable?.toDictionary(encoder: requestEncoder) ?? self.bodyParameters
        if !bodyParameters.isEmpty {
            urlRequest.httpBody = generateDataBody(bodyParameters: bodyParameters, boundary: boundary)
        }
        urlRequest.httpMethod = method.rawValue
        urlRequest.allHTTPHeaderFields = allHeaders
        
        return urlRequest
    }
    
    private func encodeBody(bodyParamaters: [String: Any], bodyEncoding: BodyEncoding) -> Data? {
        switch bodyEncoding {
        case .jsonSerializationData:
            return try? JSONSerialization.data(withJSONObject: bodyParamaters)
        case .stringEncodingAscii:
            return bodyParamaters.queryString.data(using: String.Encoding.ascii, allowLossyConversion: true)
        }
    }
    
    private func generateDataBody(bodyParameters: [String: Any], boundary: String) -> Data {
        let lineBreak = "\r\n"
        var body = Data()
        for (key, value) in bodyParameters {
            if let uploads = value as? [[String: Any]] {
                addUploadsBodyPart(body: &body,
                                   key: key,
                                   uploads: uploads,
                                   boundary: boundary,
                                   lineBreak: lineBreak)
            } else {
                var jsonObject: Any?
                if let arr = value as? [[String: Any]] {
                    jsonObject = arr
                } else if let dict = value as? [String: Any] {
                    jsonObject = dict
                } else if let arr = value as? [String] {
                    jsonObject = arr
                }
                if let jsonObject = jsonObject {
                    if let stringArray = jsonObject as? [String] {
                        addBodyPart(body: &body,
                                    key: key,
                                    value: stringArray,
                                    boundary: boundary,
                                    lineBreak: lineBreak)
                    } else {
                        let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
                        if let data = jsonData, let string = String(data: data, encoding: .utf8) {
                            addBodyPart(body: &body,
                                        key: key,
                                        value: string,
                                        boundary: boundary,
                                        lineBreak: lineBreak)
                        }
                    }
                    
                } else {
                    addBodyPart(body: &body,
                                key: key,
                                value: value,
                                boundary: boundary,
                                lineBreak: lineBreak)
                }
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    private func addUploadsBodyPart(
        body: inout Data,
        key: String,
        uploads: [[String: Any]],
        boundary: String,
        lineBreak: String
    ) {
        for upload in uploads {
            if let fileName = upload[MultipartUpload.CodingKeys.fileName.rawValue] as? String,
               let mimeType = upload[MultipartUpload.CodingKeys.mimeType.rawValue] as? String,
               let dataString = upload[MultipartUpload.CodingKeys.data.rawValue] as? String,
               let data = Data(base64Encoded: dataString) {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; ")
                body.append("name=\"\(key)\"; ")
                body.append("filename=\"\(fileName)\"\(lineBreak)")
                body.append("Content-Type: \(mimeType + lineBreak + lineBreak)")
                body.append(data)
                body.append(lineBreak)
            }
        }
    }
            
    private func addBodyPart(
        body: inout Data,
        key: String,
        value: Any,
        boundary: String,
        lineBreak: String
    ) {
        body.append("--\(boundary + lineBreak)")
        if let stringValue = value as? String {
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            body.append("\(stringValue)\(lineBreak)")
        } else {
            body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
            if value is NSNull {
                body.append("\(lineBreak)")
            } else {
                body.append("\(value)\(lineBreak)")
            }
        }
    }
}

extension Dictionary {
    var queryString: String {
        return self.map { "\($0.key)=\($0.value)" }
            .joined(separator: "&")
            .addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? ""
    }
}

extension Encodable {
    func toDictionary(encoder: RequestEncoder) throws -> [String: Any]? {
        let data = try encoder.encode(self)
        let josnData = try JSONSerialization.jsonObject(with: data)
        return josnData as? [String: Any]
    }

    func toData(encoder: RequestEncoder) throws -> Data? {
        return try? encoder.encode(self)
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
