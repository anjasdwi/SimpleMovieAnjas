//
//  UIViewController+Keyboard.swift
//  SimpleMovieAnjas
//
//  Created by Anjas Dwi on 15/03/24.
//

import UIKit

extension UIViewController {

    /// Method for setup gesture to dismiss keyboard when tap all area of view
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// Method for dismiss keyboard
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}
