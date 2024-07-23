//
//  NetworkService.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 04.08.2023.
//

import Foundation

protocol NetworkService {
    func request(endpoint: Requestable) async throws -> Data?
    func multipartRequest(endpoint: Requestable) async throws -> Data?
}

protocol NetworkSessionManager {
    func request(_ request: URLRequest) async throws -> (Data?, URLResponse?, Error?)
}

protocol NetworkErrorLogger {
    func log(request: URLRequest)
    func log(responseData data: Data?, response: URLResponse?)
    func log(error: Error)
}

class NetworkErrorLoggerImpl: NetworkErrorLogger {
    func log(request: URLRequest) {
        
    }
    
    func log(responseData data: Data?, response: URLResponse?) {
        
    }
    
    func log(error: Error) {
        
    }
}

final class DefaultNetworkService {
    private let config: NetworkConfigurable
    private let sessionManager: NetworkSessionManager
    private let logger: NetworkErrorLogger
    
    init(
        config: NetworkConfigurable,
        sessionManager: NetworkSessionManager = DefaultNetworkSessionManager(),
        logger: NetworkErrorLogger
    ) {
        self.config = config
        self.sessionManager = sessionManager
        self.logger = logger
    }
    
    func request(request: URLRequest) async throws -> Data? {
        do {
            let (data, response, error) = try await sessionManager.request(request)
            try handle(data: data, response: response, error: error)
            return data
        } catch {
            if error is NetworkError {
                throw error
            } else {
                throw NetworkError.generic(error: error, data: nil)
            }
        }
    }
    
    private func handle(
        data: Data?,
        response: URLResponse?,
        error: Error?
    ) throws {
        if let urlResponse = response as? HTTPURLResponse {
            switch urlResponse.statusCode {
            case 200..<300:
                break
            case 401:
                throw NetworkError.authenticationError
            case 403:
                throw NetworkError.forbidden
            case 404:
                throw NetworkError.notFound
            case 409:
                throw NetworkError.conflict(data: data)
            case 504:
                throw NetworkError.timeout
            case 500...599:
                throw NetworkError.badRequest
            case 600:
                throw NetworkError.outdated
            default:
                throw NetworkError.error(statusCode: urlResponse.statusCode, data: data)
            }
        } else if let error = error {
            throw NetworkError.generic(error: error, data: data)
        } else {
            throw NetworkError.failed
        }
    }
    
    private func resolve(error: Error, data: Data?) -> NetworkError {
        if let error = error as? NetworkError {
            return error
        }
        let code = URLError.Code(rawValue: (error as NSError).code)
        switch code {
        case .notConnectedToInternet:
            return .connectionError
        case .cancelled:
            return .cancelled
        default:
            return .generic(error: error, data: data)
        }
    }
}

extension DefaultNetworkService: NetworkService {
    func request(endpoint: Requestable) async throws -> Data? {
        do {
            let urlRequest = try endpoint.urlRequest(with: config)
            return try await request(request: urlRequest)
        } catch {
            throw resolve(error: error, data: nil)
        }
    }
    
    func multipartRequest(endpoint: Requestable) async throws -> Data? {
        do {
            let urlRequest = try endpoint.multipartRequest(with: config)
            return try await request(request: urlRequest)
        } catch {
            throw resolve(error: error, data: nil)
        }
    }
}

class DefaultNetworkSessionManager: NetworkSessionManager {
    init() {}
    func request(_ request: URLRequest) async throws -> (Data?, URLResponse?, Error?) {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            return (data, response, nil)
            
        } catch {
            return (nil, nil, error)
        }
    }
}
