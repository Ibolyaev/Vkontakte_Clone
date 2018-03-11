//
//  VKError.swift
//  MyApp
//
//  Created by Игорь Боляев on 10.03.2018.
//  Copyright © 2018 Ronin. All rights reserved.
//

import Foundation

enum VKError: Error {
    case JPEGRepresentationFailed
    case tokenFailed
    case readDataError(description: String, errorCode: Int)
}

extension VKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .JPEGRepresentationFailed:
            return NSLocalizedString("Failed to transfer image to JPEG", comment: "")
        case .tokenFailed:
            return NSLocalizedString("Failed to read credentials to VKontakte, please try to re-login", comment: "")
        case .readDataError(let desc, let errorCode):
            return NSLocalizedString("Failed to read data: \(desc) error code: \(errorCode)", comment: "")
        }
    }
}
