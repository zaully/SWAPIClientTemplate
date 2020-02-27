//
//  PeopleDetailsViewController.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import UIKit

class PeopleDetailsViewController: UIViewController {
    @IBOutlet private weak var name: UILabel!
    @IBOutlet private weak var yearOfBirth: UILabel!
    @IBOutlet private weak var gender: UILabel!
    @IBOutlet private weak var height: UILabel!
    @IBOutlet private weak var weight: UILabel!
    @IBOutlet private weak var skinColor: UILabel!
    @IBOutlet private weak var hairColor: UILabel!
    @IBOutlet private weak var eyeColor: UILabel!
    @IBOutlet private weak var species: UILabel!

    @IBOutlet private weak var films: UIStackView!

    private var vm: PeopleDetailsViewModel!

    static func initController(in storyboard: UIStoryboard? = nil, for people: People) -> UIViewController {
        let storyboard = storyboard ?? UIStoryboard(name: "Main", bundle: nil)
        let controller = storyboard.instantiateViewController(identifier: "details") as? PeopleDetailsViewController
        controller?.vm = PeopleDetailsViewModelImpl(species: Services.shared.species,
                                                    film: Services.shared.film,
                                                    people: people)
        return controller!
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
        vm.view = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
}

extension PeopleDetailsViewController: PeopleDetailsView {

    func display(species: String?) {
        self.species.text = species
    }

    func displayInfo() {
        name.text = vm.people.name
        yearOfBirth.text = vm.people.birthYear
        gender.text = vm.people.gender
        height.text = vm.people.height
        weight.text = vm.people.mass
        skinColor.text = vm.people.skinColor
        hairColor.text = vm.people.hairColor
        eyeColor.text = vm.people.eyeColor
    }

    func displayFilmViews(count: Int) {
        for sub in self.films.arrangedSubviews {
            self.films.removeArrangedSubview(sub)
        }
        (0..<count).forEach { (_) in
            let filmView = FilmView.initView()
            self.films.addArrangedSubview(filmView)
        }
    }

    func filmBeingLoading(at index: Int) {
        if let filmView = self.films.arrangedSubviews.get(index) as? FilmView {
            filmView.update(content: .loading)
        }
    }

    func filmDidUpdate(film: Film, at index: Int, succeeded: Bool) {
        if let filmView = self.films.arrangedSubviews.get(index) as? FilmView {
            let content: FilmViewContent
            if succeeded {
                content = .info(title: film.title, wordCount: film.openingCrawlWordCount)
            } else {
                content = .failedToLoad
            }
            filmView.update(content: content)
        }
    }
}
