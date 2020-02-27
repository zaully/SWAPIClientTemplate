//
//  DataStorage.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation
import CoreData

protocol DataStorage: class {
    func find<T: Savable>(with index: Any) -> T?
    func getAll<T: Savable>() -> [T]
    @discardableResult func createOrUpdate<T: Savable>(with index: Any, json: [String: Any]) -> T?
    func saveToDisk()
}

class CoreDataStorage: DataStorage {

    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "StarWarsCharacters")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func getAll<T: Savable>() -> [T] {
        return find(withPredicate: nil)
    }

    func createOrUpdate<T: Savable>(with index: Any, json: [String: Any]) -> T? {
        let model: T
        if let found: T = find(with: index) {
            model = found
        } else {
            model = create()
        }
        if model.update(with: index, and: json) {
            return model
        }
        persistentContainer.viewContext.delete(model)
        return nil
    }

    func find<T: Savable>(with index: Any) -> T? {
        let predicate = NSPredicate(format: "\(T.key.field) == \(T.key.keyFormat)", argumentArray: [index])
        return find(withPredicate: predicate).first
    }

    func create<T: Savable>() -> T {
        return T(context: persistentContainer.viewContext)
    }

    func saveToDisk() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

private extension CoreDataStorage {
    func find<T: Savable>(withPredicate predicate: NSPredicate?) -> [T] {
        let fetchRequest = NSFetchRequest<T>(entityName: T.entityName)
        fetchRequest.predicate = predicate
        let found = try? persistentContainer.viewContext.fetch(fetchRequest)
        return found ?? []
    }
}
