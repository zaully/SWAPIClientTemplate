//
//  Film+Savable.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol Film: class {
    var id: String? { get }
    var title: String? { get }
    var openingCrawlWordCount: Int { get }
    var isReady: Bool { get }
}

extension FilmModel: Film {
    var openingCrawlWordCount: Int {
        return Int(openingWordCount)
    }
    var isReady: Bool {
        return !(title?.isEmpty ?? true)
    }
}

extension FilmModel: Savable {
    static var key: SavableKey {
        return .string(field: "id")
    }

    func update(with index: Any, and json: [String: Any]) -> Bool {
        guard let index = index as? String else { return false }
        id = index
        title = json["title"] as? String
        let crawl = json["opening_crawl"] as? String ?? ""
        let count = crawl.replacingOccurrences(of: "\r\n", with: " ").components(separatedBy: " ").count
        openingWordCount = Int16(exactly: count - 1) ?? 0
        return true
    }
}
