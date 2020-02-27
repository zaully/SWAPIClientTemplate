//
//  AppError.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol AppError {
    var errorCode: Int { get }
    var message: String { get }
}

class ErrorWrapper: AppError {
    var errorCode: Int {
        return error.code
    }

    var message: String {
        return error.localizedDescription
    }

    private let error: NSError

    init(error: Error) {
        self.error = error as NSError
    }
}

extension NSError: AppError {
    var errorCode: Int {
        return code
    }

    var message: String {
        return localizedDescription
    }

    convenience init(code: Int, description: String) {
        self.init(domain: Params.domain, code: code, userInfo: [
            NSLocalizedDescriptionKey: description
        ])
    }
}

private enum Params {
    static let domain = "StarWarsCharactersErrorDomain"
}
