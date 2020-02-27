//
//  Species+Savable.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol Species: class {
    var id: String? { get }
    var name: String? { get }
}

extension SpeciesModel: Species {}

extension SpeciesModel: Savable {
    static var key: SavableKey {
        return .string(field: "id")
    }

    func update(with index: Any, and json: [String: Any]) -> Bool {
        guard let index = index as? String else { return false }
        id = index
        name = json["name"] as? String
        return true
    }
}
