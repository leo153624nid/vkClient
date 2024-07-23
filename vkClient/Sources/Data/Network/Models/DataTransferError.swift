//
//  DataTransferError.swift
//  vkClient
//
//  Created by Aleksey Chaykin on 09.08.2023.
//

import Foundation

enum DataTransferError: LocalizedError {
    
    case noResponse(String)
    case parsing(Error, String)
    case resolvedNetworkFailure(Error)
    case customObjectError(LocalizedError)
    
    var errorDescription: String? {
        return switch self {
        case .noResponse:
            "Empty response"
        case let .parsing(error, _):
            error.localizedDescription
        case let .resolvedNetworkFailure(error):
            error.localizedDescription
        case let .customObjectError(error):
            error.errorDescription
        }
    }
    
}

extension Error {
    func isCancelledDataTransfer() -> Bool {
        if let error = self as? DataTransferError,
            case let .resolvedNetworkFailure(err) = error,
            err.localizedDescription.lowercased() == "cancelled" {
            return true
        }
        return false
    }
}
