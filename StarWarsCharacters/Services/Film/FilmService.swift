//
//  FilmService.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol FilmService: class {
    func getFilms(for people: People) -> [Film]
    func reload(for film: Film, completion: ((Film?, AppError?) -> Void)?)
}

class FilmServiceImpl: FilmService {

    private let storage: DataStorage
    private let http: HttpService

    init(storage: DataStorage, http: HttpService) {
        self.storage = storage
        self.http = http
    }

    func getFilms(for people: People) -> [Film] {
        return (people.films ?? []).compactMap { (id) -> FilmModel? in
            let film: FilmModel? = storage.find(with: id)
            return film ?? storage.createOrUpdate(with: id, json: [:])
        }
    }

    func reload(for film: Film, completion: ((Film?, AppError?) -> Void)?) {
        guard let id = film.id, let url = URL(string: id) else {
            completion?(film, nil)
            return
        }
        http.requestJson(for: url) { (result) in
            switch result {
            case .failure(let error):
                completion?(film, error)
            case .success(_, let json):
                let film: FilmModel? = self.storage.createOrUpdate(with: id, json: json)
                completion?(film, nil)
            }
        }
    }
}
