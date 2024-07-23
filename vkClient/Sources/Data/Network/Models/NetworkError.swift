//
//  NetworkError.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 08.08.2023.
//

import Foundation

enum NetworkError: LocalizedError {
    case error(statusCode: Int, data: Data?)
    case parametersNil
    case encodingFailed
    case missingUrl
    case connectionError
    case authenticationError
    case forbidden
    case conflict(data: Data?)
    case badRequest
    case outdated
    case failed
    case noData
    case cancelled
    case unableToDecode(userInfo: Any?)
    case generic(error: Error, data: Data?)
    case custom(String)
    case notFound
    case timeout
    
    var errorDescription: String? { // TODO: - strings
        return switch self {
        case .parametersNil:
            "L10n.Errors.Network.parametersNil"
        case .encodingFailed:
            "L10n.Errors.Network.encodingFailed"
        case .missingUrl:
            "L10n.Errors.Network.urlNil"
        case .connectionError:
            "L10n.Errors.Network.checkNetwork"
        case .authenticationError:
           "L10n.Errors.Network.authorisationError"
        case .forbidden:
            "L10n.Errors.Network.forbidden"
        case .conflict:
            "L10n.Errors.Network.conflict"
        case .badRequest:
            "L10n.Errors.Network.badRequest"
        case .outdated:
            "L10n.Errors.Network.urlOutdated"
        case .failed:
            "L10n.Errors.Network.networkRequestFailed"
        case .noData:
            "L10n.Errors.Network.couldNotLoadData"
        case .unableToDecode:
            "L10n.Errors.Network.couldNotDecodeResponse"
        case let .error(status, _):
            "L10n.Errors.Network.requestFailedWithCode(status)"
        case .cancelled:
            "L10n.Errors.Network.requestCancelled"
        case let .generic(error, _):
            error.localizedDescription
        case let .custom(string):
            string
        case .notFound:
            "L10n.Errors.Network.notFound"
        case .timeout:
            "L10n.Errors.Network.timeout"
        }
    }
}

extension NetworkError: Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        String(describing: lhs) == String(describing: rhs)
    }
}
