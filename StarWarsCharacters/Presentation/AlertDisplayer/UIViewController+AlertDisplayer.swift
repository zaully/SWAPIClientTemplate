//
//  UIViewController+AlertDisplayer.swift
//  StarWarsCharacters
//
//  Created by Vince Liang on 2020-02-26.
//  Copyright © 2020 Vince. All rights reserved.
//

import UIKit

protocol AlertDisplayer: class {
    func show(error: AppError)
}

extension UIViewController: AlertDisplayer {
    func show(error: AppError) {
        let title = "Error Code ".localized + "\(error.errorCode)"
        let alert = UIAlertController(title: title, message: error.message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK".localized, style: .default) { (_) in }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
}
