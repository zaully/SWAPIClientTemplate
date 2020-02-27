//
//  PeopleListViewModel.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-25.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

protocol PeopleListView: AlertDisplayer {
    var listBeingUpdated: Bool { set get }
    func listDidUpdate()
}

protocol PeopleListViewModel: class {
    var peopleCount: Int { get }
    var view: PeopleListView? { get set }
    func reload()
    func getPeople(at: Int) -> People?
}

class PeopleListViewModelImpl: PeopleListViewModel {
    private let service: PeopleService
    private var people = [People]()

    init(service: PeopleService) {
        self.service = service
        self.sortAndSave(people: service.getAllPeople())
    }

    var peopleCount: Int {
        return people.count
    }

    weak var view: PeopleListView? {
        didSet {
            if oldValue == nil {
                reload()
            }
        }
    }

    func getPeople(at: Int) -> People? {
        return people.get(at)
    }

    func reload() {
        view?.listBeingUpdated = true
        service.loadAllPeople { [weak self] (people, error) in
            if let error = error {
                self?.view?.show(error: PeopleListError.loadingError(error: error))
            }
            self?.view?.listBeingUpdated = false
            self?.sortAndSave(people: people)
        }
    }
}

private extension PeopleListViewModelImpl {
    func sortAndSave(people: [People]) {
        self.people = people.sorted(by: { (l, r) -> Bool in
            l.name ?? "" <= r.name ?? ""
        })
        view?.listDidUpdate()
    }
}

private enum PeopleListError: AppError {
    var errorCode: Int {
        switch self {
        case .loadingError(let error):
            return error.errorCode
        }
    }

    var message: String {
        switch self {
        case .loadingError(let error):
            return error.message + "\n\n" + "You might want to refresh it later".localized
        }
    }

    case loadingError(error: AppError)
}
