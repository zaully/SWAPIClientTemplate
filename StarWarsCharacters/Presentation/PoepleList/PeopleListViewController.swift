//
//  PeopleListViewController.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import UIKit

class PeopleListViewController: UITableViewController {

    private var vm: PeopleListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let backItem = UIBarButtonItem()
        backItem.title = nil
        navigationItem.backBarButtonItem = backItem
        refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl?.addTarget(self, action: #selector(reload), for: .valueChanged)

        vm = PeopleListViewModelImpl(service: Services.shared.people)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        vm.view = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vm.peopleCount
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let cell = cell as? PeopleListTableViewCell {
            cell.name.text = vm.getPeople(at: indexPath.row)?.name
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let people = vm.getPeople(at: indexPath.row) else {
            tableView.deselectRow(at: indexPath, animated: true)
            return
        }
        let details = PeopleDetailsViewController.initController(for: people)
        navigationController?.pushViewController(details, animated: true)
    }

    @objc func reload() {
        vm.reload()
    }

}

extension PeopleListViewController: PeopleListView {
    var listBeingUpdated: Bool {
        get {
            return refreshControl?.isRefreshing ?? false
        }
        set {
            guard let refresh = refreshControl else {
                return
            }
            if newValue {
                refresh.beginRefreshing()
                tableView.setContentOffset(CGPoint(x: 0, y: -refresh.frame.height), animated: true)
            } else {
                refresh.endRefreshing()
            }
        }
    }

    func listDidUpdate() {
        tableView.reloadData()
    }
}

class PeopleListTableViewCell: UITableViewCell {
    @IBOutlet weak var name: UILabel!
}
