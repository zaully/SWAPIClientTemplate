//
//  People+Savable.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol People: class {
    var id: Int64 { get }
    var birthYear: String? { get }
    var eyeColor: String? { get }
    var gender: String? { get }
    var hairColor: String? { get }
    var height: String? { get }
    var mass: String? { get }
    var name: String? { get }
    var skinColor: String? { get }
    var speciesUrl: String? { get }
    var films: [String]? { get }
}

extension PeopleModel: People {}

extension PeopleModel: Savable {
    static var key: SavableKey {
        return .int64(field: "id")
    }

    func update(with index: Any, and json: [String: Any]) -> Bool {
        guard let index = index as? Int64 else { return false }
        id = index
        birthYear = json["birth_year"] as? String
        height = json["height"] as? String
        mass = json["mass"] as? String
        hairColor = json["hair_color"] as? String
        skinColor = json["skin_color"] as? String
        eyeColor = json["eye_color"] as? String
        name = json["name"] as? String
        gender = json["gender"] as? String
        speciesUrl = (json["species"] as? [String])?.first
        films = (json["films"] as? [String]) ?? []
        return true
    }
}
