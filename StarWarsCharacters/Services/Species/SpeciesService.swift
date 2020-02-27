//
//  SpeciesService.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol SpeciesService: class {
    func getSpecies(for people: People, completion: ((Species?, AppError?) -> Void)?)
}

class SpeciesServiceImpl: SpeciesService {

    private let storage: DataStorage
    private let http: HttpService

    init(storage: DataStorage, http: HttpService) {
        self.storage = storage
        self.http = http
    }
    
    func getSpecies(for people: People, completion: ((Species?, AppError?) -> Void)?) {
        guard let id = people.speciesUrl, let url = URL(string: id) else {
            completion?(nil, nil)
            return
        }
        if let found: SpeciesModel = storage.find(with: id) {
            completion?(found, nil)
            return
        }
        http.requestJson(for: url) { (result) in
            switch result {
            case .failure(let error):
                completion?(nil, error)
            case .success(_, let json):
                if let species: SpeciesModel = self.storage.createOrUpdate(with: id, json: json) {
                    completion?(species, nil)
                } else {
                    completion?(nil, nil)
                }
            }
        }
    }
}
