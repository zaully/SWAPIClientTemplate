//
//  Services.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

class Services {
    static let shared = Services()
    private init() {}

    lazy var storage: DataStorage = CoreDataStorage()
    lazy var http: HttpService = HttpServiceImpl()
    lazy var people: PeopleService = PeopleServiceImpl(storage: self.storage, http: self.http)
    lazy var species: SpeciesService = SpeciesServiceImpl(storage: self.storage, http: self.http)
    lazy var film: FilmService = FilmServiceImpl(storage: self.storage, http: self.http)
}
