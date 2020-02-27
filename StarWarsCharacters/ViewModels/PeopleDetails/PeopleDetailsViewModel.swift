//
//  PeopleDetailsViewModel.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol PeopleDetailsView: AlertDisplayer {
    func display(species: String?)
    func displayInfo()
    func displayFilmViews(count: Int)
    func filmBeingLoading(at index: Int)
    func filmDidUpdate(film: Film, at index: Int, succeeded: Bool)
}

protocol PeopleDetailsViewModel: class {
    var people: People { get }
    var view: PeopleDetailsView? { get set }
}

class PeopleDetailsViewModelImpl: PeopleDetailsViewModel {
    let people: People
    private let species: SpeciesService
    private let film: FilmService

    weak var view: PeopleDetailsView? {
        didSet {
            view?.displayInfo()
            loadSpecies()
            loadFilms()
        }
    }

    init(species: SpeciesService, film: FilmService, people: People) {
        self.people = people
        self.species = species
        self.film = film
    }
}

private extension PeopleDetailsViewModelImpl {

    func loadSpecies() {
        species.getSpecies(for: people) { [weak self] (species, error) in
            if let error = error {
                self?.view?.show(error: error)
            }
            if let species = species {
                self?.view?.display(species: species.name)
            } else {
                self?.view?.display(species: "Unknown".localized)
            }
        }
    }

    func loadFilms() {
        let films = film.getFilms(for: people)
        view?.displayFilmViews(count: films.count)
        for i in 0..<films.count {
            if films[i].title != nil {
                view?.filmDidUpdate(film: films[i], at: i, succeeded: films[i].isReady)
                continue
            }
            self.view?.filmBeingLoading(at: i)
            self.film.reload(for: films[i]) { [weak self] (film, error) in
                if let error = error {
                    self?.view?.show(error: error)
                }
                if let film = film {
                    self?.view?.filmDidUpdate(film: film, at: i, succeeded: films[i].isReady)
                }
            }
        }
    }
}
