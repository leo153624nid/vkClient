//
//  DataTransferService.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 07.08.2023.
//

import Foundation

protocol DataTransferService {
    @discardableResult
    func request<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
    @discardableResult
    func request<E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> Data where E.Response == Data
    
    func request<E: ResponseRequestable>(
        with endpoint: E
    ) async throws where E.Response == Void
    @discardableResult
    func multipartRequest<T: Decodable, E: ResponseRequestable>(
        with endpoint: E
    ) async throws -> T where E.Response == T
}

protocol RequestEncoder {
    func encode<T: Encodable>(_ value: T) throws -> Data
}

protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}

protocol DataTransferErrorLogger {
    func log(error: Error)
}

final class DefaultDataTransferService {
    
    private let networkService: NetworkService
    
    init(
        with networkService: NetworkService
    ) {
        self.networkService = networkService
    }
}

extension DefaultDataTransferService: DataTransferService {
    func request<T: Decodable, E: ResponseRequestable>(with endpoint: E) async throws -> T where E.Response == T {
        do {
            let data = try await networkService.request(endpoint: endpoint)
            return try decode(data: data, decoder: endpoint.responseDecoder)
        } catch {
            throw DataTransferError.resolvedNetworkFailure(error)
        }
    }
    
    func request<E: ResponseRequestable>(with endpoint: E) async throws -> Data where E.Response == Data {
        do {
            guard let data = try await networkService.request(endpoint: endpoint) else {
                throw DataTransferError.noResponse("Could not load data")
            }
            return data
        } catch {
            throw DataTransferError.resolvedNetworkFailure(error)
        }
    }
    
    func request<E>(with endpoint: E) async throws where E: ResponseRequestable, E.Response == Void {
        do {
            _ = try await networkService.request(endpoint: endpoint)
        } catch {
            throw DataTransferError.resolvedNetworkFailure(error)
        }
    }
    
    func multipartRequest<T, E>(
        with endpoint: E
    ) async throws -> T where T: Decodable, T == E.Response, E: ResponseRequestable {
        do {
            let data = try await networkService.multipartRequest(endpoint: endpoint)
            return try decode(data: data, decoder: endpoint.responseDecoder)
        } catch {
            throw DataTransferError.resolvedNetworkFailure(error)
        }
    }
    
    // MARK: - Private
    private func decode<T: Decodable>(data: Data?, decoder: ResponseDecoder) throws -> T {
        do {
            guard let data = data else { throw DataTransferError.noResponse("no data found") }
            return try decoder.decode(data)
        } catch {
            throw DataTransferError.parsing(error, "")
        }
    }
}

// MARK: - Request Encoders
public class JSONRequestEncoder: RequestEncoder {
    private let jsonEncoder = JSONEncoder()
    
    init(dateEncodingStrategy: JSONEncoder.DateEncodingStrategy = .deferredToDate) {
        jsonEncoder.dateEncodingStrategy = dateEncodingStrategy
    }
    
    func encode<T>(_ value: T) throws -> Data where T: Encodable {
        return try jsonEncoder.encode(value)
    }
}

// MARK: - Response Decoders
public class JSONResponseDecoder: ResponseDecoder {
    private let jsonDecoder = JSONDecoder()
    
    init(
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        userInfo: [CodingUserInfoKey: Any] = [:]
    ) {
        jsonDecoder.dateDecodingStrategy = dateDecodingStrategy
        jsonDecoder.userInfo = userInfo
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}

public class RawDataResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    func decode<T: Decodable>(_ data: Data) throws -> T {
        if T.self is Data.Type, let data = data as? T {
            return data
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}

public class StringResponseDecoder: ResponseDecoder {
    init() { }
    
    enum CodingKeys: String, CodingKey {
        case `default` = ""
    }
    
    func decode<T>(_ data: Data) throws -> T where T: Decodable {
        if let str = String(decoding: data, as: UTF8.self) as? T {
            return str
        } else {
            let context = DecodingError.Context(
                codingPath: [CodingKeys.default],
                debugDescription: "Expected Data type"
            )
            throw Swift.DecodingError.typeMismatch(T.self, context)
        }
    }
}
