//
//  String+Localized.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-24.
//  Copyright © 2020 Vince. All rights reserved.
//

import Foundation

public extension String {
    var localized: String {
        return NSLocalizedString(self, comment: self)
    }
}
