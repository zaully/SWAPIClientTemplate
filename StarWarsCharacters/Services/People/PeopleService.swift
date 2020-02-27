//
//  PeopleService.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import CoreData

protocol PeopleService: class {
    func getAllPeople() -> [People]
    func loadAllPeople(completion: (([People], AppError?) -> Void)?)
}

class PeopleServiceImpl: PeopleService {
    private let storage: DataStorage
    private let http: HttpService
    private var loadingPages = Set<Int>()

    init(storage: DataStorage, http: HttpService) {
        self.storage = storage
        self.http = http
    }

    func getAllPeople() -> [People] {
        return storage.getAll() as [PeopleModel]
    }

    func loadAllPeople(completion: (([People], AppError?) -> Void)?) {
        http.requestJson(for: PeopleApi.list) { (result) in
            switch result {
            case .failure(let error):
                completion?(self.storage.getAll() as [PeopleModel], error)
            case .success(_, let json):
                let all = self.updatePeopleList(from: json)
                if let count = json["count"] as? Int, all > 0 {
                    let rest = count / all - (count % all == 0 ? 1 : 0)
                    self.loadRestPages(startWith: json["next"] as? String, pagesToLoad: rest, completion: completion)
                } else {
                    completion?(self.storage.getAll()as [PeopleModel], nil)
                }
            }
        }
    }
}

private extension PeopleServiceImpl {
    func loadRestPages(startWith: String?, pagesToLoad: Int, completion: (([People], AppError?) -> Void)?) {
        guard let start = startWith,
            let comps = URLComponents(string: start),
            let pageQuery = comps.queryItems?.first,
            let page = comps.queryItems?.first?.value,
            let startPage = Int(page) else {
            return
        }
        for i in startPage..<pagesToLoad + startPage {
            var nextComps = comps
            nextComps.queryItems = [URLQueryItem(name: pageQuery.name, value: "\(i)")]
            guard let url = nextComps.url else { continue }
            loadingPages.insert(i)
            var error: AppError?
            http.requestJson(for: url) { (result) in
                switch result {
                case .failure(let err):
                    error = err
                case .success(_, let json):
                    self.updatePeopleList(from: json)
                }
                self.loadingPages.remove(i)
                if self.loadingPages.isEmpty {
                    completion?(self.storage.getAll()as [PeopleModel], error)
                }
            }
        }
    }

    @discardableResult func updatePeopleList(from json: [String: Any]) -> Int {
        let all = json["results"] as? [[String: Any]] ?? []
        for peopleJson in all {
            self.updatePeopleModel(json: peopleJson)
        }
        return all.count
    }

    func updatePeopleModel(json: [String: Any]) {
        guard let url = json["url"] as? String,
            let link = URL(string: url),
            let id = Int64(link.lastPathComponent) else {
            return
        }

        _ = storage.createOrUpdate(with: id, json: json) as PeopleModel?
    }
}

enum PeopleApi: ApiEndpoint {
    case list
    case people(id: Int)

    var endpoint: String {
        switch self {
        case .list:
            return "people"
        case .people(let id):
            return "people/\(id)"
        }
    }

    var url: URL {
        return Api.base.appendingPathComponent(endpoint)
    }
}
