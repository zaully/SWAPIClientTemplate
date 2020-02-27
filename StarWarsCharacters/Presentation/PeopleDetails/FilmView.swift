//
//  FilmView.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import UIKit

enum FilmViewContent {
    case loading
    case info(title: String?, wordCount: Int)
    case failedToLoad
}

class FilmView: UIView {
    @IBOutlet private var title: UILabel!
    @IBOutlet private var wordCount: UILabel!

    static func initView() -> FilmView {
        let view = UINib(nibName: "FilmView", bundle: nil).instantiate(withOwner: nil, options: nil).first as? FilmView
        return view!
    }

    func update(content: FilmViewContent) {
        switch content {
        case .info(let title, let wordCount):
            self.title.text = title
            self.wordCount.text = "\(wordCount)"
        case .loading:
            self.title.text = "loading...".localized
            self.wordCount.text = "unknown yet".localized
        case .failedToLoad:
            self.title.text = "loading failed".localized
            self.wordCount.text = "unknown yet".localized
        }
    }
}
