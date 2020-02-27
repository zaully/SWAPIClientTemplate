//
//  Savable.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import CoreData

public enum SavableKey {
    case int64(field: String)
    case string(field: String)

    var field: String {
        switch self {
        case .int64(let field), .string(let field):
            return field
        }
    }

    var keyFormat: String {
        switch self {
        case .int64:
            return "%ld"
        case .string:
            return "%@"
        }
    }
}

protocol Savable: NSManagedObject {
    static var key: SavableKey { get }
    func update(with index: Any, and json: [String: Any]) -> Bool
}

extension Savable {
    static var entityName: String {
        return entity().name!
    }
}
