//
//  Array+IndexSafe.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-25.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

public extension Array {
    func get(_ i: Int) -> Element? {
        guard i >= 0, i < count else { return nil }
        return self[i]
    }
}
